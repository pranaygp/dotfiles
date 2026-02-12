local M = {}

--- Detect macOS system appearance
---@return boolean true if dark mode
function M.is_dark_mode()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:match("Dark") ~= nil
  end
  return true -- default to dark mode if detection fails
end

return M
