# fzf-z

This plugin was originally inspired as a mashup between
[fzf](https://github.com/junegunn/fzf), and oh-my-zsh's [z
plugin](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/z),
which allows you to track recently and commonly used directories. The *z*
plugin does a great job of allowing you to switch between frequently-used
directories just by typing `z *somedirectorysubstring*`, but it doesn't really
easily allow you to browse those directories, with partial-string search. This
plugin was invented to solve that problem.

Since then, I've extended it to support two other sources of information about
the directories you might be interested in, which are all mixed into the same
list delivered through `fzf`. In priority order (the order in which they are
shown in `fzf`, first to last):

1. Directories *under* the current directory. The number of these shown in
   `fzf` is limited by the `FZFZ_SUBDIR_LIMIT` environment variable, which
   defaults to 50. If you don't want those to be shown, simply set this to
   `0`.

1. Recently used dirs, as provided by the `z` command from the z plugin (the
   original purpose of this plugin). The order shown is the order given by `z
   -l`.

1. All subdirectories in all directories listed in the FZFZ_EXTRA_DIRS
   environment variables. These directories are space-separated, so for
   example:

   `export FZFZ_EXTRA_DIRS="~/MyDocuments '~/Desktop/Some Other Stuff'"`

To use the plugin, simply hit `<CTRL-g>` anywhere on an empty zsh
command-line, and it will bring up a list of directories according to the
three categories above (mixed together).  Select one, perhaps typing to filter
the list, and hit Enter - you'll change to that directory (assuming you have
the `AUTO_CD` zsh option turned on, which is recommended). This is similar to
the default **Ctrl-T** binding already provided by the [fzf zsh key-bindings
file](https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh). At
the moment, this plugin doesn't allow the **Ctrl-G** keybinding to be
customized, but you can change by simply forking the plugin and editing the
file if you want.

## Installation

You must have the [z
plugin](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/z)
installed as a pre-req. You must also have [fzf](https://github.com/junegunn/fzf)
installed. Both must be in your `$PATH`.

Treat this plugin like [any other zsh
plugin](http://joshldavis.com/2014/07/26/oh-my-zsh-is-a-disease-antigen-is-the-vaccine/).
For example:

### Antigen

If you're using [Antigen](https://github.com/zsh-users/antigen):

1. Add `antigen bundle andrewferrier/fzf-z` to your `.zshrc` where you've listed your other plugins.
2. Close and reopen your Terminal/iTerm window to **refresh context** and use the plugin. Alternatively, you can run `antigen bundle andrewferrier/fzf-z` in a running shell to have antigen load the new plugin.

### zgen

If you're using [zgen](https://github.com/tarjoilija/zgen):

1. Add `zgen load andrewferrier/fzf-z` to your `.zshrc` along with your other `zgen load` commands.
2. `rm ${ZGEN_INIT}/init.zsh && zgen save`

## Customizing

If you set the `FZFZ_EXCLUDE_PATTERN` environment variable to a regex (matched
with `egrep`) it will exclude any directory which matches it from appearing in
the subdirectory results (it isn't applied to the `z` results, since it's
assumed any directory you've navigated to before is one you might be
interested in). By default this variable is set to filter out anything in a
`.git` directory.

You can also set `FZFZ_EXTRA_OPTS` to add any additional options you like to
the `fzf` command - for example, `-e` will turn exact matching on by default.

By default, fzf-z will filter out duplicates between its different mechanisms
of finding file paths; however, this does slow it down. If you don't care
about that and want to speed it up, set `FZFZ_UNIQUIFIER="cat"`.

## Performance

If it's installed and in your `PATH`, `fzf-z` will use
[fd](https://github.com/sharkdp/fd). If not, it'll fall back to `find`, which
is slower. The behaviour is slightly differently also; `fd` will exclude files
ignored by `.gitignore` or similar, which `find` will not do, so you will get
less results. Generally, this is what you want, though.
