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
ALLOWLIST_PATH = Path(__file__).with_name("secret-scan.allowlist")


def is_binary(data: bytes) -> bool:
    return b"\x00" in data


def redact_line(line: str) -> str:
    out = line
    for _, pat in PATTERNS:
        out = pat.sub("<REDACTED>", out)
    return out


def load_allowlist():
    if not ALLOWLIST_PATH.exists():
        return []
    patterns = []
    for line in ALLOWLIST_PATH.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        try:
            patterns.append(re.compile(line))
        except re.error:
            continue
    return patterns


def is_allowlisted(allowlist, path: Path, line: str) -> bool:
    if not allowlist:
        return False
    target = f"{path}:{line}"
    for pat in allowlist:
        if pat.search(target) or pat.search(line):
            return True
    return False


def scan_text(text: str, path: Path, allowlist):
    findings = []
    for i, line in enumerate(text.splitlines(), 1):
        if REDACT_MARKERS.search(line):
            continue
        if is_allowlisted(allowlist, path, line):
            continue
        for name, pat in PATTERNS:
            if pat.search(line):
                findings.append((i, name, redact_line(line)))
                break
    return findings


def scan_file(path: Path, allowlist):
    try:
        data = path.read_bytes()
    except Exception:
        return []
    if is_binary(data):
        return []
    text = data.decode("utf-8", errors="ignore")
    return scan_text(text, path, allowlist)


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

    allowlist = load_allowlist()

    findings_total = 0
    for path in files:
        findings = scan_file(path, allowlist)
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
