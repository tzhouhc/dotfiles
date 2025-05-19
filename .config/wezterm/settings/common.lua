local M = {}

function M.update_config(config)
  -- quit when asked to
  config.exit_behavior = 'Close'
  config.window_close_confirmation = 'NeverPrompt'
  config.warn_about_missing_glyphs = false
  config.tab_and_split_indices_are_zero_based = false
  config.tab_max_width = 40
end

return M
