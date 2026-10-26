-- NVIM_AI_UI: sidekick | codecompanion | avante | agentic | claudecode
-- NVIM_AI_AGENT: claude | copilot | codex | opencode | agy
-- NVIM_AI_COPILOT=0 disables copilot completion and NES
local agent = vim.env.NVIM_AI_AGENT or "claude"

local names = {
  claude = { cli = "claude", codecompanion = "claude_code", avante = "claude-code", agentic = "claude-agent-acp" },
  copilot = { cli = "copilot", codecompanion = "copilot_acp", avante = "copilot-acp", agentic = "copilot-acp" },
  codex = { cli = "codex", codecompanion = "codex", avante = "codex", agentic = "codex-acp" },
  opencode = { cli = "opencode", codecompanion = "opencode", avante = "opencode", agentic = "opencode-acp" },
  agy = { cli = "antigravity" },
}

return {
  ui = vim.env.NVIM_AI_UI or "sidekick",
  agent = agent,
  copilot = vim.env.NVIM_AI_COPILOT ~= "0",
  name = function(ui) return (names[agent] or {})[ui] or names.copilot[ui] end,
}
