local M = {}

function M.update_config(config)
  -- quit when asked to
  config.exit_behavior = 'Close'
  config.window_close_confirmation = 'NeverPrompt'
end

return M
