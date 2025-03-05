-- ctrl + arrow keys or Q/R/Z/C for moving the active window around the screen.
-- See https://www.hammerspoon.org/docs/hs.window.html for docs

hs.window.animationDuration = 0

local M = {}

-- alternates between right half/third/quarter.
function M.right_half()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.y = max.y
  if f.w == max.w / 3 then
    f.w = max.w / 4
  elseif f.w == max.w / 2 then
    f.w = max.w / 3
  else
    f.w = max.w / 2
  end
  f.x = max.x + max.w - f.w
  f.h = max.h
  win:setFrame(f)
end

-- alternates between left half/third/quarter.
function M.left_half()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  if f.w == max.w / 3 then
    f.w = max.w / 4
  elseif f.w == max.w / 2 then
    f.w = max.w / 3
  else
    f.w = max.w / 2
  end
  f.h = max.h
  win:setFrame(f)
end

function M.maximize()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end

-- alternates between bottom half/third/quarter.
-- window might not actually allow the resizing.
function M.bottom_half()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.w = max.w
  if f.h == max.h / 3 then
    f.h = max.h / 4
  elseif f.h == max.h / 2 then
    f.h = max.h / 3
  else
    f.h = max.h / 2
  end
  f.y = max.y + max.h - f.h
  win:setFrame(f)
end

-- alternates between top half/third/quarter.
-- window might not actually allow the resizing.
function M.top_half()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y / 2
  f.w = max.w
  if f.h == max.h / 3 then
    f.h = max.h / 4
  elseif f.h == max.h / 2 then
    f.h = max.h / 3
  else
    f.h = max.h / 2
  end
  win:setFrame(f)
end


function M.top_left_quadrant()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y / 2
  if f.w == max.w / 3 then
    f.w = max.w / 4
  elseif f.w == max.w / 2 then
    f.w = max.w / 3
  else
    f.w = max.w / 2
  end
  f.h = max.h / 2
  win:setFrame(f)
end

function M.top_right_quadrant()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.y = max.y / 2
  if f.w == max.w / 3 then
    f.w = max.w / 4
  elseif f.w == max.w / 2 then
    f.w = max.w / 3
  else
    f.w = max.w / 2
  end
  f.x = max.x + max.w - f.w
  f.h = max.h / 2
  win:setFrame(f)
end

function M.bottom_left_quadrant()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y + (max.h / 2)
  if f.w == max.w / 3 then
    f.w = max.w / 4
  elseif f.w == max.w / 2 then
    f.w = max.w / 3
  else
    f.w = max.w / 2
  end
  f.h = max.h / 2
  win:setFrame(f)
end

function M.bottom_right_quadrant()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.y = max.y + (max.h / 2)
  if f.w == max.w / 3 then
    f.w = max.w / 4
  elseif f.w == max.w / 2 then
    f.w = max.w / 3
  else
    f.w = max.w / 2
  end
  f.x = max.x + max.w - f.w
  f.h = max.h / 2
  win:setFrame(f)
end

return M
