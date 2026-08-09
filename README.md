# Erlang QoL Snippets

[![中文文档](https://img.shields.io/badge/%E4%B8%AD%E6%96%87%E6%96%87%E6%A1%A3-%E7%82%B9%E5%87%BB%E6%9F%A5%E7%9C%8B-orange)](README_CN.md)

Erlang code generation templates and everyday code snippets for the [Zed editor](https://zed.dev), ported from the [erlang-code-generation](https://github.com/Qualia91/erlang-code-generation) VSCode extension.

## Features

- **11 module templates** — gen_server, gen_statem, supervisor, header (`.hrl` with include guard), empty module, Common Test suite, poolboy worker, cowboy websocket handler, cowboy REST handler, lager handler, escript
- **3 comment templates** — header / section / function
- **14 everyday code snippets** — log, receive, case, try, eunit tests, poolboy/cowboy/child-spec snippets

## Requirements

- Zed editor
- An extension that provides the Erlang language (e.g. the official [`erlang`](https://github.com/zed-extensions/erlang) extension — it also bundles the ELP and erlang_ls language servers). Snippets are scoped to the `Erlang` language.

## Installation (development)

Until this extension is published to the Zed extension registry, install it as a dev extension:

1. Zed → Extensions panel → **Install Dev Extension** (or run `zed: install dev extension` from the command palette)
2. Select this repository's directory
3. In Extensions panel, the card shows `erlang-qol-snippets` as a dev extension

## Usage

### Via snippet completion

Open an `.erl` / `.hrl` file and type a snippet prefix, then select it from the completion menu.

| Prefix | Snippet |
| --- | --- |
| `log` | print to console |
| `rec` / `reca` | receive / receive with after |
| `case` / `if` / `try` / `?` | case / if / try / inline try-catch |
| `eunit` | eunit tests section |
| `pools` / `cows` / `works` / `sups` | poolboy specs / cowboy web supervisor / worker child specs / supervisor child specs |
| `comsec` / `funsec` / `comhdr` | comment: section / function / header |
| `mod-genserver` | gen_server module template |
| `mod-genstatem` | gen_statem module template |
| `mod-supervisor` | supervisor module template |
| `mod-header` | header (`.hrl`) template with include guard |
| `mod-empty` | empty module template |
| `mod-ct` | Common Test suite template |
| `mod-poolboy-worker` | poolboy worker template |
| `mod-websocket-handler` | cowboy websocket handler template |
| `mod-rest-handler` | cowboy REST handler template |
| `mod-lager-handler` | lager handler template |
| `mod-escript` | escript template |

### Via keybindings (recommended)

Zed extensions cannot register commands, so module templates are triggered by binding the [`editor::InsertSnippet`](https://zed.dev/docs/keymaps) action in your user keymap (`~/.config/zed/keymap.json` on Windows: `%APPDATA%\Zed\keymap.json`):

```json
[
  {
    "context": "Editor && !menu && !picker",
    "bindings": {
      "ctrl-shift-p g": ["editor::InsertSnippet", { "language": "erlang", "name": "module: gen_server template" }],
      "ctrl-shift-p s": ["editor::InsertSnippet", { "language": "erlang", "name": "module: gen_statem template" }],
      "ctrl-shift-p u": ["editor::InsertSnippet", { "language": "erlang", "name": "module: supervisor template" }],
      "ctrl-shift-p h": ["editor::InsertSnippet", { "language": "erlang", "name": "module: header template" }],
      "ctrl-shift-p e": ["editor::InsertSnippet", { "language": "erlang", "name": "module: empty template" }],
      "ctrl-shift-p c": ["editor::InsertSnippet", { "language": "erlang", "name": "module: CT template" }],
      "ctrl-shift-p p": ["editor::InsertSnippet", { "language": "erlang", "name": "module: poolboy worker template" }],
      "ctrl-shift-p w": ["editor::InsertSnippet", { "language": "erlang", "name": "module: websocket handler template" }],
      "ctrl-shift-p r": ["editor::InsertSnippet", { "language": "erlang", "name": "module: cowboy rest handler template" }],
      "ctrl-shift-p l": ["editor::InsertSnippet", { "language": "erlang", "name": "module: lager handler template" }],
      "ctrl-shift-p x": ["editor::InsertSnippet", { "language": "erlang", "name": "module: escript template" }],
      "ctrl-shift-p 1": ["editor::InsertSnippet", { "language": "erlang", "name": "comment: header" }],
      "ctrl-shift-p 2": ["editor::InsertSnippet", { "language": "erlang", "name": "comment: section" }],
      "ctrl-shift-p 3": ["editor::InsertSnippet", { "language": "erlang", "name": "comment: function" }]
    }
  }
]
```

Press `ctrl-shift-p` then the letter. Note that when a chord is pending, pressing `ctrl-shift-p` alone opens the command palette after a ~1s delay. `$1`/`$2`/`$3` tabstops guide you through module name, author and fields.

## Editing templates / adding new snippets

Zed requires all snippets for one language to live in a single file (`snippets/erlang.json`), so this repository maintains one JSON file per snippet in `snippets-src/` and merges them with a build script.

1. Edit `snippets-src/<nn-name>.json` (one snippet per file) or add a new one, e.g. `27-my-snippet.json`:

   ```json
   {
     "My snippet": {
       "prefix": "my",
       "body": ["...", "\t${1:placeholder}"],
       "description": "Optional description"
     }
   }
   ```

2. Run the merge script (PowerShell, no dependencies):

   ```powershell
   .\build.ps1
   ```

3. In Zed: Extensions panel → **Rebuild** on the dev extension card.

Notes:

- Snippet names must be unique (the build script fails on duplicates).
- Tabstops must be numbered continuously (`$1`, `$2`, ... `$0` for the final position); placeholders with the same number are linked (typing once fills all occurrences).
- Zed does not support snippet variables (`$TM_FILENAME_BASE` etc.) — use linked tabstops instead.
- A literal `$` inside the body must be escaped as `\\$`.
- Do not edit `snippets/erlang.json` directly — it is generated by `build.ps1`.

## Contributors

- Original extension [erlang-code-generation](https://github.com/Qualia91/erlang-code-generation) and its developer [Qualia91](https://github.com/Qualia91) — this project is a Zed port of their work.

## License

[MIT](LICENSE) — portions are derived from the MIT-licensed [erlang-code-generation](https://github.com/Qualia91/erlang-code-generation) VSCode extension (Copyright (c) 2022 BOC Dev).
