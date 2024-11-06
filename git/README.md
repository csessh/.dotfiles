# .gitconfig

## Configuration 

```bash
cd ~/.dotfiles
stow git
```

## Dependencies

This configuration requires:

* [delta](https://github.com/dandavison/delta)
* [git-lfs](https://git-lfs.com/)

### git-delta

This package must be installed by downloading a `.deb` from the official [release page](https://github.com/dandavison/delta/releases).

```bash
cd ~/.dotfiles/git/
wget https://github.com/dandavison/delta/releases/download/<version>/git-delta_<version>_arm64.deb 
sudo dpkg -i git-delta_<version>_arm64.deb
```

### git-lfs

```bash
sudo apt install git-lfs
```

## Special alias

`git adog` has been with me for years. I don't even know how I came up with it.
I must have wanted a dog so badly back then.

I, now, have two fat cats.
