# fzf-z

If you're anything like me, you like [fzf](https://github.com/junegunn/fzf),
you like [zsh](http://www.zsh.org/), and you like oh-my-zsh's [z
plugin](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/z).

However, although the *z* plugin does a great job of allowing you to switch
between frequently-used directories just by typing `z
*somedirectorysubstring*`, it doesn't really easily allow you to browse those
directories, with partial-string search.

This zsh plugin brings together the *z* plugin and *fzf* to allow you to
easily browse recently used directories at any point on the command line. Just
type `<CTRL-g>` on an empty zsh command-line, and it will bring up a list of
recently used directories. Select one, perhaps typing to filter the list, and
hit Enter - you'll change to that directory. This is similar to the default
**Ctrl-T** binding already provided by the [fzf zsh key-bindings
file](https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh). At
the moment, this plugin doesn't allow the **Ctrl-G** keybinding to be customized,
but you can change by simply forking the plugin and editing the file if you want.

## Installation

Treat this plugin like [any other zsh
plugin](http://joshldavis.com/2014/07/26/oh-my-zsh-is-a-disease-antigen-is-the-vaccine/).

### Antigen

If you're using [Antigen](https://github.com/zsh-users/antigen):

1. Add `antigen bundle andrewferrier/fzf-z` to your `.zshrc` where you've listed your other plugins.
2. Close and reopen your Terminal/iTerm window to **refresh context** and use the plugin. Alternatively, you can run `antigen bundle andrewferrier/fzf-z` in a running shell to have antigen load the new plugin.

### zgen

If you're using [zgen](https://github.com/tarjoilija/zgen):

1. Add `zgen load andrewferrier/fzf-z` to your `.zshrc` along with your other `zgen load` commands.
2. `rm ${ZGEN_INIT}/init.zsh && zgen save`
