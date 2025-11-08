# vsrocq.nvim
A Neovim client for [VsRocq `vsroqtop`](https://github.com/rocq-prover/vsrocq).

## Prerequisites
* [Latest stable version of Neovim](https://github.com/neovim/neovim/releases/tag/stable)
* [`vsrocqtop`](https://github.com/rocq-prover/vsrocq#installing-the-language-server)

## Setup
### [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'whonore/Coqtail' " for ftdetect, syntax, basic ftplugin, etc
Plug 'tomtomjhj/vsrocq.nvim'

...

" Don't load Coqtail
let g:loaded_coqtail = 1
let g:coqtail#supported = 0

" Setup vsrocq.nvim
lua require'vsrocq'.setup()
```

### [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  'whonore/Coqtail',
  init = function()
      vim.g.loaded_coqtail = 1
      vim.g["coqtail#supported"] = 0
  end,
},
{
  'tomtomjhj/vsrocq.nvim',
  filetypes = 'coq',
  dependecies = {
    'whonore/Coqtail',
  },
  opts = {
    vsrocq = { ... }
    lsp = { ... }
  },
},
```

## Interface
* vsrocq.nvim uses Neovim's built-in LSP client and nvim-lspconfig.
  See [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim/)
  for basic example configurations for working with LSP.
* `:VsRocq` command
    * `:VsRocq continuous`: Use the "Continuous" proof mode. It shows goals for the cursor position.
    * `:VsRocq manual`: Use the "Manual" proof mode (default), where the following four commands are used for navigation.
        * `:VsRocq stepForward`
        * `:VsRocq stepBackward`
        * `:VsRocq interpretToEnd`
        * `:VsRocq interpretToPoint`
    * `:VsRocq panels`: Open the proofview panel and query panel.
    * Queries
        * `:VsRocq search {pattern}`
        * `:VsRocq about {pattern}`
        * `:VsRocq check {pattern}`
        * `:VsRocq print {pattern}`
        * `:VsRocq locate {pattern}`
    * Proofview
        * `:VsRocq admitted`: Show the admitted goals.
        * `:VsRocq shelved`: Show the shelved goals.
        * `:VsRocq goals`: Show the normal goals and messages (default).
    * etc
        * `:VsRocq jumpToEnd`: Jump to the end of the checked region.

## Configurations
The `setup()` function takes a table with the followings keys:
* `vsrocq`: Settings specific to VsRocq, used in both the client and the server.
  This corresponds to the `"configuration"` key in VsRocq's [package.json][].
* `lsp`: The settings forwarded to `:help lspconfig-setup`. `:help vim.lsp.ClientConfig`.

### Basic LSP configuration

Some settings in VsRocq's [package.json][] should be configured in nvim's LSP client configuration:
* `"vsrocq.path"` and `"vsrocq.args"` → `lsp.cmd`
* `"vsrocq.trace.server"` → `lsp.trace`

| Key                | Type                               | Default value                      | Description                                                                                                                    |
| ------------------ | ---------------------------------- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `lsp.cmd`          | `string[]`                         | `{ "vsrocqtop" }`                   | Path to `vsrocqtop` (e.g. `path/to/vsrocq/bin/vsrocqtop`) and arguments passed                                                    |
| `lsp.trace`        | `"off" \| "messages" \| "verbose"` | `"off"`                            | Toggles the tracing of communications between the server and client                                                            |

### Memory management (since >= vsrocq 2.1.7)

| Key                  | Type  | Default value | Description                                                                                                                                           |
| -------------------- | ----- | ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `vsrocq.memory.limit` | `int` | 4             | specifies the memory limit (in Gb) over which when a user closes a tab, the corresponding document state is discarded in the server to free up memory |

### Goal and info view panel

| Key                         | Type                         | Default value | Description                                                                                                   |
| --------------------------- | ---------------------------- | ------------- | ------------------------------------------------------------------------------------------------------------- |
| `vsrocq.goals.diff.mode`     | `"on" \| "off" \| "removed"` | `"off"`       | Toggles diff mode. If set to `removed`, only removed characters are shown                                     |
| `vsrocq.goals.messages.full` | `bool`                       | `false`       | A toggle to include warnings and errors in the proof view                                                     |
| `vsrocq.goals.maxDepth`      | `int`                        | `17`          | A setting to determine at which point the goal display starts eliding (since version >= 2.1.7 of `vsrocqtop`) |

### Proof checking
| Key                                   | Type                             | Default value | Description                                                                                                                                                                                                                 |
| ------------------------------------- | -------------------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `vsrocq.proof.mode`                    | `"Continuous" \| "Manual"`       | `"Manual"`    | Decide whether documents should checked continuously or using the classic navigation commmands (defaults to `Manual`)                                                                                                       |
| `vsrocq.proof.pointInterpretationMode` | `"Cursor" \| "NextCommand"`      | `"Cursor"`    | Determines the point to which the proof should be check to when using the 'Interpret to point' command                                                                                                                      |
| `vsrocq.proof.cursor.sticky`           | `bool`                           | `true`        | A toggle to specify whether the cursor should move as Rocq interactively navigates a document (step forward, backward, etc...)                                                                                               |
| `vsrocq.proof.delegation`              | `"None" \| "Skip" \| "Delegate"` | `"None"`      | Decides which delegation strategy should be used by the server. `Skip` allows to skip proofs which are out of focus and should be used in manual mode. `Delegate` allocates a settable amount of workers to delegate proofs |
| `vsrocq.proof.workers`                 | `int`                            | `1`           | Determines how many workers should be used for proof checking                                                                                                                                                               |
| `vsrocq.proof.block`                   | `bool`                           | `true`        | Determines if the the execution of a document should halt on first error (since version >= 2.1.7 of `vsrocqtop`)                                                                                                             |

### Code completion (experimental)
| Key                                 | Type                                                      | Default value            | Description                                                   |
| ----------------------------------- | --------------------------------------------------------- | ------------------------ | ------------------------------------------------------------- |
| `vsrocq.completion.enable`           | `bool`                                                    | `false`                  | Toggle code completion                                        |
| `vsrocq.completion.algorithm`        | `"StructuredSplitUnification" \| "SplitTypeIntersection"` | `"SplitTypeIntersection"`| Which completion algorithm to use                             |
| `vsrocq.completion.unificationLimit` | `int` (minimum 0)                                         | `100`                    | Sets the limit for how many theorems unification is attempted |

### Diagnostics
| Key                      | Type   | Default value | Description                                      |
| ------------------------ | ------ | ------------- | ------------------------------------------------ |
| `vsrocq.diagnostics.full` | `bool` | `false`       | Toggles the printing of `Info` level diagnostics |

### Example:
```lua
require'vsrocq'.setup {
  vsrocq = {
    proof = {
      -- In manual mode, don't move the cursor when stepping forward/backward a command
      cursor = { sticky = false },
    },
  },
  lsp = {
    on_attach = function(client, bufnr)
      -- your mappings, etc

      -- In manual mode, use ctrl-alt-{j,k,l} to step.
      vim.keymap.set({ 'n', 'i' }, '<C-M-j>', '<Cmd>VsRocq stepForward<CR>', { buffer = bufnr, desc='VsRocq step forward' })
      vim.keymap.set({ 'n', 'i' }, '<C-M-k>', '<Cmd>VsRocq stepBackward<CR>', { buffer = bufnr, desc='VsRocq step backward' })
      vim.keymap.set({ 'n', 'i' }, '<C-M-l>', '<Cmd>VsRocq interpretToPoint<CR>', { buffer = bufnr, desc='VsRocq interpret to point' })
      vim.keymap.set({ 'n', 'i' }, '<C-M-G>', '<Cmd>VsRocq interpretToEnd<CR>', { buffer = bufnr, desc = 'VsRocq interpret to end' })
    end,
    -- autostart = false, -- use this if you want to manually `:LspStart vscoqtop`.
    -- cmd = { 'vsrocqtop', '-bt', '-vsrocq-d', 'all' }, -- for debugging the server
  },
}
```

NOTE:
Do not call `lspconfig.vscoqtop.setup()` yourself.
`require'vsrocq'.setup` does it for you.

## Features not implemented yet
* Fancy proofview rendering
    * proof diff highlights
* Make lspconfig optional

## See also
* [coq.ctags](https://github.com/tomtomjhj/coq.ctags) for go-to-definition.
* [coq-lsp.nvim](https://github.com/tomtomjhj/coq-lsp.nvim) for `coq-lsp` client.

[package.json]: https://github.com/rocq-prover/vsrocq/blob/main/client/package.json
