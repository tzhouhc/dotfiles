local wezterm = require 'wezterm'

local M = {}

-- reference:
-- https://wezfurlong.org/wezterm/config/lua/window-events/format-tab-title.html

local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on(
  'format-tab-title',
  function(tab, _, _, _, hover, max_width)
    local edge_background = '#2E3440'
    local background = '#4C566A'
    local foreground = '#D8DEE9'

    if tab.is_active then
      background = '#5E81AC'
      foreground = '#3B4252'
    elseif hover then
      background = '#81A1C1'
      foreground = '#2E3440'
    end

    local edge_foreground = background

    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    local left_edge
    if tab.tab_id == 0 then
      left_edge = ' '
    else
      left_edge = SOLID_RIGHT_ARROW
    end

    return {
      { Background = { Color = edge_foreground } },
      { Foreground = { Color = edge_background } },
      { Text = left_edge },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = '  [' .. title .. ']  ' },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end
)

local tab_colors = {
  background = '#2E3440',

  new_tab = {
    bg_color = '#2E3440',
    fg_color = '#434C5E',
  },
  new_tab_hover = {
    bg_color = '#81A1C1',
    fg_color = '#2E3440',
    italic = true,
  }
}

function M.update_config(config)
  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
  if config['colors'] then
    config.colors['tab_bar'] = tab_colors
  else
    config.colors = {
      tab_bar = tab_colors
    }
  end
end

return M
