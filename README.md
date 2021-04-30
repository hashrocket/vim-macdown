# macdown.vim

> write markdown in Vim with live-reloads in
> [MacDown](https://macdown.uranusjr.com/)

## Usage

### Installation

Using this plugin requires two things:

- You are on a Mac
- You have [MacDown](https://macdown.uranusjr.com/) installed

To install `macdown.vim`, use your favorite Vim plugin manager (e.g.
[Plug](https://github.com/junegunn/vim-plug)):

```vimscript
Plug 'hashrocket/vim-macdown'
```

### Commands

* `<leader>p` (`\p` with default vim config)
* `:MacDownPreview` to open the current file in MacDown
* `:MacDownClose` to close MacDown
* `:MacDownExit` to close MacDown, but wait for the close to finish before returning focus to Vim (Necessary while exiting vim)
* `:MacDownOff` to disable this plugin during the current vim session
* `:MacDownOn` to enable (default) this plugin during the current vim session

Make some edits to a markdown file and then hit `<leader>p` to view a
preview in Macdown.

### .vimrc

Add the following to your `.vimrc`:

#### On save for .md files

```vimscript
" execute commands on filetype save
autocmd BufWritePost *.md exec :MacDownPreview
```

#### On close .md file

```vimscript
" Enable closing MacDown when ':q' closes the current file, but doesn't
" exit vim from vim-macdown plugin
autocmd BufWinLeave *.md :MacDownClose
```

#### On close .md file and exit vim

```vimscript
" Enable closing MacDown when ':q' exits vim from vim-macdown plugin
autocmd VimLeavePre *.md :MacDownExit
```

## License

macdown.vim is released under the [MIT License](http://www.opensource.org/licenses/MIT).

---

## About

[![Hashrocket logo](https://hashrocket.com/hashrocket_logo.svg)](https://hashrocket.com)

macdown.vim is supported by the team at [Hashrocket, a multidisciplinary
design and development consultancy](https://hashrocket.com). If you'd like
to [work with us](https://hashrocket.com/contact-us/hire-us) or [join our
team](https://hashrocket.com/contact-us/jobs), don't hesitate to get in
touch.
