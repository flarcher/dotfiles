# Personal dot files

Here are my personal dot files.
This repository is designed to work with [ChezMoi](https://www.chezmoi.io/).

## Configure dotfiles local directory

Before to apply changes, you may need to tell _chezmoi_ where is located your local fork of this repository: edit your file `~/.config/chezmoi/chezmoi.toml` and add the following (where _$SRC_PARENT_DIR_ must be replaced):

```
sourceDir = "$SRC_PARENT_DIR/dotfiles"
workingTree = "$SRC_PARENT_DIR/dotfiles"
```

