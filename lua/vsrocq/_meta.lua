---@alias buffer integer
---@alias window integer

---Position for indexing used by most API functions (0-based line, 0-based column) (:h api-indexing).
---@class APIPosition: { [1]: integer, [2]: integer }

---Position for "mark-like" indexing (1-based line, 0-based column) (:h api-indexing).
---@class MarkPosition: { [1]: integer, [2]: integer }

-- https://github.com/coq-community/vscoq/blob/main/docs/protocol.md

-- # Configuration

-- # Highlights

---"vsrocq/UpdateHighlights" notification (server → client) parameter.
---@class vsrocq.UpdateHighlightsNotification
---@field uri lsp.DocumentUri
---@field processingRange lsp.Range[]
---@field processedRange lsp.Range[]

-- # Goal view

---@alias vsrocq.PpTag string

---@alias vsrocq.BlockType
---| vsrocq.BlockType.Pp_hbox
---| vsrocq.BlockType.Pp_vbox
---| vsrocq.BlockType.Pp_hvbox
---| vsrocq.BlockType.Pp_hovbox

---@class vsrocq.BlockType.Pp_hbox
---@field [1] "Pp_hbox"

---@class vsrocq.BlockType.Pp_vbox
---@field [1] "Pp_vbox"
---@field [2] integer

---@class vsrocq.BlockType.Pp_hvbox
---@field [1] "Pp_hvbox"
---@field [2] integer

---@class vsrocq.BlockType.Pp_hovbox
---@field [1] "Pp_hovbox"
---@field [2] integer new lines in this box adds this amount of indent

---@alias vsrocq.PpString
---| vsrocq.PpString.Ppcmd_empty
---| vsrocq.PpString.Ppcmd_string
---| vsrocq.PpString.Ppcmd_glue
---| vsrocq.PpString.Ppcmd_box
---| vsrocq.PpString.Ppcmd_tag
---| vsrocq.PpString.Ppcmd_print_break
---| vsrocq.PpString.Ppcmd_force_newline
---| vsrocq.PpString.Ppcmd_comment

---@class vsrocq.PpString.Ppcmd_empty
---@field [1] "Ppcmd_empty"
---@field size integer

---@class vsrocq.PpString.Ppcmd_string
---@field [1] "Ppcmd_string"
---@field [2] string
---@field size? integer

---@class vsrocq.PpString.Ppcmd_glue
---@field [1] "Ppcmd_glue"
---@field [2] (vsrocq.PpString)[]
---@field size? integer

---@class vsrocq.PpString.Ppcmd_box
---@field [1] "Ppcmd_box"
---@field [2] vsrocq.BlockType
---@field [3] vsrocq.PpString
---@field size? integer

---@class vsrocq.PpString.Ppcmd_tag
---@field [1] "Ppcmd_tag"
---@field [2] vsrocq.PpTag
---@field [3] vsrocq.PpString
---@field size? integer

---@class vsrocq.PpString.Ppcmd_print_break
---@field [1] "Ppcmd_print_break"
---@field [2] integer number of spaces when this break is not line break
---@field [3] integer additional indent of the new lines (added to box's indent)
---@field size? integer

---@class vsrocq.PpString.Ppcmd_force_newline
---@field [1] "Ppcmd_force_newline"
---@field size? integer

---@class vsrocq.PpString.Ppcmd_comment
---@field [1] "Ppcmd_comment"
---@field [2] string[]
---@field size? integer

--[[
  if pp[1] == 'Ppcmd_empty' then
    ---@cast pp vsrocq.PpString.Ppcmd_empty
  elseif pp[1] == 'Ppcmd_string' then
    ---@cast pp vsrocq.PpString.Ppcmd_string
  elseif pp[1] == 'Ppcmd_glue' then
    ---@cast pp vsrocq.PpString.Ppcmd_glue
  elseif pp[1] == 'Ppcmd_box' then
    ---@cast pp vsrocq.PpString.Ppcmd_box
  elseif pp[1] == 'Ppcmd_tag' then
    ---@cast pp vsrocq.PpString.Ppcmd_tag
  elseif pp[1] == 'Ppcmd_print_break' then
    ---@cast pp vsrocq.PpString.Ppcmd_print_break
  elseif pp[1] == 'Ppcmd_force_newline' then
    ---@cast pp vsrocq.PpString.Ppcmd_force_newline
  elseif pp[1] == 'Ppcmd_comment' then
    ---@cast pp vsrocq.PpString.Ppcmd_comment
  end
--]]

---@class vsrocq.Goal
---@field id integer
---@field goal vsrocq.PpString
---@field hypotheses (vsrocq.PpString)[]

---@class vsrocq.ProofViewGoals
---@field goals vsrocq.Goal[]
---@field shelvedGoals vsrocq.Goal[]
---@field givenUpGoals vsrocq.Goal[]
---@field unfocusedGoals vsrocq.Goal[]

---@enum vsrocq.MessageSeverity
---|1 # error
---|2 # warning
---|3 # information
---|4 # hint

---@alias vsrocq.RocqMessage {[1]: vsrocq.MessageSeverity, [2]: vsrocq.PpString}

---"vsrocq/proofView" notification (server → client) parameter.
---@class vsrocq.ProofViewNotification
---@field proof vsrocq.ProofViewGoals|vim.NIL|nil
---@field messages vsrocq.RocqMessage[]

---"vsrocq/moveCursor" notification (server → client) parameter.
---Sent as response to "vsrocq/stepForward" and "vsrocq/stepBack" notifications.
---@class vsrocq.MoveCursorNotification
---@field uri lsp.DocumentUri
---@field range lsp.Range

-- # Query panel

-- TODO: query response does not contain appropriate line breaks for window width (unlike coqide)

---"vsrocq/search" request parameter.
---@class vsrocq.SearchRocqRequest
---@field id string this doesn't need to be an actual UUID
---@field textDocument lsp.VersionedTextDocumentIdentifier
---@field pattern string
---@field position lsp.Position

---"vsrocq/search" response parameter.
---@class vsrocq.SearchRocqHandshake
---@field id string

---"vsrocq/searchResult" notification parameter.
---@class vsrocq.SearchRocqResult
---@field id string
---@field name vsrocq.PpString
---@field statement vsrocq.PpString

---Request parameter for "vsrocq/about", "vsrocq/check", "vsrocq/print", "vsrocq/locate"
---@class vsrocq.SimpleRocqRequest
---@field textDocument lsp.VersionedTextDocumentIdentifier
---@field pattern string
---@field position lsp.Position

---Response parameter for "vsrocq/about", "vsrocq/check", "vsrocq/print", "vsrocq/locate"
---@alias vsrocq.SimpleRocqReponse vsrocq.PpString

---Request parameter for "vsrocq/resetRocq"
---@class vsrocq.ResetRocqRequest
---@field textDocument lsp.VersionedTextDocumentIdentifier
