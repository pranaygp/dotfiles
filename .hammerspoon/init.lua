-- Keep the external monitor above the built-in display.
-- macOS defaults new displays to side-by-side; the watcher below runs
-- arrange-displays.sh whenever the screen configuration changes.

local arrangeScript = os.getenv("HOME") .. "/.hammerspoon/arrange-displays.sh"

local function arrangeDisplays()
  hs.task.new(arrangeScript, function(exitCode, stdOut, stdErr)
    if exitCode ~= 0 then
      print(string.format("arrange-displays.sh exited %d: %s", exitCode, stdErr or ""))
    end
  end):start()
end

-- The watcher fires several times while displays settle; debounce.
local debounce = nil
screenWatcher = hs.screen.watcher.new(function()
  if debounce then debounce:stop() end
  debounce = hs.timer.doAfter(2, arrangeDisplays)
end)
screenWatcher:start()

-- Also fix the arrangement on Hammerspoon launch/reload.
arrangeDisplays()
