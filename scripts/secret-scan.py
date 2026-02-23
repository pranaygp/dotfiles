#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path

PATTERNS = [
    ("npm_auth", re.compile(r"//registry\.npmjs\.org/:_authToken\s*=\s*\S+", re.I)),
    ("github_pat", re.compile(r"gh[pous]_[A-Za-z0-9_]{20,}")),
    ("github_pat_v2", re.compile(r"github_pat_[A-Za-z0-9_]{20,}")),
    ("slack_token", re.compile(r"xox[baprs]-[A-Za-z0-9-]{10,}")),
    ("google_api_key", re.compile(r"AIza[0-9A-Za-z-_]{30,}")),
    ("aws_access_key", re.compile(r"AKIA[0-9A-Z]{16}")),
    ("private_key", re.compile(r"-----BEGIN (?:RSA|EC|OPENSSH|DSA)? ?PRIVATE KEY-----")),
    ("op_reference", re.compile(r"op://[\w\-]+/[\w\-]+/[\w\-]+")),
    (
        "generic_kv",
        re.compile(
            r"(?i)(?:token|secret|password|passwd|api[_-]?key|access[_-]?token|auth[_-]?token)\s*[:=]\s*[^\s#\"']{8,}"
        ),
    ),
]

REDACT_MARKERS = re.compile(r"<REDACTED>|REDACTED", re.I)


def is_binary(data: bytes) -> bool:
    return b"\x00" in data


def redact_line(line: str) -> str:
    out = line
    for _, pat in PATTERNS:
        out = pat.sub("<REDACTED>", out)
    return out


def scan_text(text: str):
    findings = []
    for i, line in enumerate(text.splitlines(), 1):
        if REDACT_MARKERS.search(line):
            continue
        for name, pat in PATTERNS:
            if pat.search(line):
                findings.append((i, name, redact_line(line)))
                break
    return findings


def scan_file(path: Path):
    try:
        data = path.read_bytes()
    except Exception:
        return []
    if is_binary(data):
        return []
    text = data.decode("utf-8", errors="ignore")
    return scan_text(text)


def staged_files():
    try:
        out = subprocess.check_output(
            ["git", "diff", "--cached", "--name-only", "--diff-filter=ACM"],
            text=True,
        )
    except Exception:
        return []
    files = []
    for line in out.splitlines():
        line = line.strip()
        if not line:
            continue
        p = Path(line)
        if p.exists() and p.is_file():
            files.append(p)
    return files


def main():
    parser = argparse.ArgumentParser(
        description="Scan files for likely secrets and fail if found."
    )
    parser.add_argument("--mode", choices=["staged", "paths"], default="staged")
    parser.add_argument("--path", action="append", dest="paths")
    args = parser.parse_args()

    if args.mode == "staged":
        files = staged_files()
    else:
        files = [Path(p) for p in (args.paths or [])]

    findings_total = 0
    for path in files:
        findings = scan_file(path)
        if findings:
            findings_total += len(findings)
            for line_no, name, redacted in findings:
                print(f"{path}:{line_no}: [{name}] {redacted}")

    if findings_total > 0:
        print(
            "Potential secrets detected. Review the paths above before committing.",
            file=sys.stderr,
        )
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
