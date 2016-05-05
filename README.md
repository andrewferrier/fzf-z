# fzf-z

If you're anything like me, you like [fzf](https://github.com/junegunn/fzf),
you like [zsh](http://www.zsh.org/), and you oh-my-zsh's [z
plugin](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/z).

However, although the *z* plugin does a great job of allowing you to switch
between frequently-used directories just by typing `z
*somedirectorysubstring*`, it doesn't really easily allow you to browse those
directories, with partial-string search.

This zsh plugin brings together the *z* plugin and *fzf* to allow you to
easily browse recently used directories at any point on the command line. For
example:

```
    cd <CTRL-G>
```

Will bring up a list of recently used directories. Select one, perhaps typing
to filter the list, and hit Enter - you'll change to that directory. This can
be used anywhere a directory is needed, and is similar to the default
**Ctrl-T** binding already provided by the [fzf zsh key-bindings
file](https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh).

## Installation

This instructions need to be expanded, but for the moment - simply treat this
plugin like [any other zsh
plugin](http://joshldavis.com/2014/07/26/oh-my-zsh-is-a-disease-antigen-is-the-vaccine/).
