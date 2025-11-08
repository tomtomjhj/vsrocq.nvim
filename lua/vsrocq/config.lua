---@class vsrocq.Config
local Config = {
  memory = {
    ---@type integer
    limit = 4,
  },

  goals = {
    diff = {
      ---@type "off"|"on"|"removed"
      mode = 'off',
    },

    messages = {
      ---@type boolean
      full = true,
    },

    ---@type "String"|"Pp"
    ppmode = "Pp",

    ---@type integer
    maxDepth = 17,
  },

  proof = {
    ---@type "Manual"|"Continuous"
    mode = 'Manual',

    ---@type "Cursor"|"NextCommand"
    pointInterpretationMode = 'Cursor',

    cursor = {
      ---@type boolean
      sticky = true,
    },

    ---@type "None"|"Skip"|"Delegate"
    delegation = 'None',

    ---@type integer
    workers = 1,

    ---@type boolean
    block = true,
  },

  completion = {
    ---@type boolean
    enable = false,

    ---@type integer
    unificationLimit = 100,

    ---@type "StructuredSplitUnification"|"SplitTypeIntersection"
    algorithm = 'SplitTypeIntersection',
  },

  diagnostics = {
    ---@type boolean
    full = false,
  },
}

Config.__index = Config

-- keys in config
local goals_diff_keys = { 'off', 'on', 'removed' }
local goals_ppmode_keys = { 'Pp', 'String' }
local proof_delegation_keys = { 'None', 'Skip', 'Delegate' }
local proof_mode_keys = { 'Manual', 'Continuous' }
local proof_pointInterpretationMode_keys = { 'Cursor', 'NextCommand' }
local completion_algorithm_keys = { 'StructuredSplitUnification', 'SplitTypeIntersection' }

---@param opts table
---@return vsrocq.Config
function Config:new(opts)
  local config = vim.tbl_deep_extend('keep', opts, self)
  vim.validate {
    ['vsrocq'] = { config, 'table' },
    ['vsrocq.memory'] = { config.memory, 'table' },
    ['vsrocq.memory.limit'] = {
      config.memory.limit,
      function(x)
        return type(x) == 'number' and x > 0
      end,
      'positive number',
    },
    ['vsrocq.goals'] = { config.goals, 'table' },
    ['vsrocq.goals.diff'] = { config.goals.diff, 'table' },
    ['vsrocq.goals.diff.mode'] = {
      config.goals.diff.mode,
      function(x)
        return type(x) == 'string' and vim.list_contains(goals_diff_keys, x)
      end,
      'one of ' .. table.concat(goals_diff_keys, ', '),
    },
    ['vsrocq.goals.messages'] = { config.goals.messages, 'table' },
    ['vsrocq.goals.messages.full'] = { config.goals.messages.full, 'boolean' },
    ['vsrocq.goals.maxDepth'] = { config.goals.maxDepth, 'number' },
    ['vsrocq.goals.ppmode'] = {
      config.goals.ppmode,
      function(x) return type(x) == 'string' and vim.list_contains(goals_ppmode_keys, x) end,
      'ome of ' .. table.concat(goals_ppmode_keys, ', '),
    },
    ['vsrocq.proof'] = { config.proof, 'table' },
    ['vsrocq.proof.mode'] = {
      config.proof.mode,
      function(x)
        return type(x) == 'string' and vim.list_contains(proof_mode_keys, x)
      end,
      'one of ' .. table.concat(proof_mode_keys, ', '),
    },
    ['vsrocq.proof.pointInterpretationMode'] = {
      config.proof.pointInterpretationMode,
      function(x)
        return type(x) == 'string' and vim.list_contains(proof_pointInterpretationMode_keys, x)
      end,
      'one of ' .. table.concat(proof_pointInterpretationMode_keys, ', '),
    },
    ['vsrocq.proof.cursor'] = { config.proof.cursor, 'table' },
    ['vsrocq.proof.cursor.sticky'] = { config.proof.cursor.sticky, 'boolean' },
    ['vsrocq.proof.delegation'] = {
      config.proof.delegation,
      function(x)
        return type(x) == 'string' and vim.list_contains(proof_delegation_keys, x)
      end,
      'one of ' .. table.concat(proof_delegation_keys, ', '),
    },
    ['vsrocq.proof.workers'] = { config.proof.workers, 'number' },
    ['vsrocq.proof.block'] = { config.proof.block, 'boolean' },
    ['vsrocq.completion'] = { config.completion, 'table' },
    ['vsrocq.completion.enable'] = { config.completion.enable, 'boolean' },
    ['vsrocq.completion.unificationLimit'] = { config.completion.unificationLimit, 'number' },
    ['vsrocq.completion.algorithm'] = {
      config.completion.algorithm,
      function(x)
        return type(x) == 'string' and vim.list_contains(completion_algorithm_keys, x)
      end,
      'one of ' .. table.concat(completion_algorithm_keys, ', '),
    },
    ['vsrocq.diagnostics'] = { config.diagnostics, 'table' },
    ['vsrocq.diagnostics.full'] = { config.diagnostics.full, 'boolean' },
  }
  setmetatable(config, self)
  return config
end

---@return vsrocq.LspOptions
function Config:to_lsp_options()
  local LspConfig = require('vsrocq.lsp_options')
  return LspConfig:new(self)
end

return Config
