# Emacs compilation

Based on [this documentation](https://www.rahuljuliato.com/posts/compiling_emacs_29_2).

Pre-requisite packages:

```bash
sudo apt install libxaw7-dev \
  libjpeg-dev libgif-dev libtiff-dev \
  gnutls-dev gnutls-bin \
  libcairo2-dev \
  libharfbuzz-dev \
  libmailutils-dev \
  libtool-bin \
  texinfo \
  libmagick++-dev \
  libgccjit0 libgccjit-12-dev libgccjit-11-dev libgccjit-10-dev libgccjit-9-dev \
  libjson-c-dev \
  libtree-sitter-dev \
  libjansson-dev
```

```bash
./configure --with-native-compilation=aot\
            --with-tree-sitter\
            --with-gif\
            --with-png\
            --with-jpeg\
            --with-rsvg\
            --with-tiff\
            --with-imagemagick\
            --with-x-toolkit=lucid\
            --with-json\
            --with-mailutils
```

```bash
make -j8 && make install

```

# After install (lsp, lint, etc.)

```bash
git clone --depth 1 --single-branch https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
```

```bash
pip install semgrep --user
go install terraform-ls@latest
go install golang.org/x/tools/gopls@latest
go install golangci-lint@latest
go install github.com/go-delve/delve/cmd/dlv@latest
```


# Cloning real config

```
rm -rf $HOME/.config/doom
git clone git@github.com:nmaupu/emacs-config.git $HOME/.config/doom
```
