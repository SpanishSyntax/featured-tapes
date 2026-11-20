# Featured Tapes
A hand-picked selection of tapes ( rices, dotfiles, etc ) to use with [tapes][]

The tapes in this repo can be installed with the [cli][tapes] via
```bash
tapes install-featured TAPE-NAME
```

### Available Tapes

- [Caelestia](https://github.com/futurekismo-oss/featured-tapes/tree/main/caelestia)
- [End-4](https://github.com/futurekismo-oss/featured-tapes/tree/main/end-4)
- [Nebula](https://github.com/futurekismo-oss/featured-tapes/tree/main/nebula)
- [Serpantinum](https://github.com/futurekismo-oss/featured-tapes/tree/main/serpantinum)
- [Noctalia-Libre](https://github.com/futurekismo-oss/featured-tapes/tree/main/noctalia-libre)

----

<details>
<summary><strong>NixOS & Home Manager</strong></summary>

Because `setup.sh` scripts target imperative distributions, this repository also provides a Nix flake that builds each tape cleanly into the Nix store and supplies its runtime packages, fonts, and QML plugins declaratively.

### Quick trial (without modifying your system)

```bash
nix develop github:futurekismo-oss/featured-tapes#nebula
# then follow the printed `tapes insert -p /nix/store/...` command
```

### Home Manager

Add `featured-tapes` to your flake inputs and enable the rices you want:

```nix
{
  imports = [ inputs.featured-tapes.homeManagerModules.default ];

  programs.featured-tapes = {
    enable = true;
    tapes = [ "caelestia" "nebula" "noctalia-libre" ];
    # mutable = true; # default: seeds writable copies into ~/.tapes/<name> (set false for read-only /nix/store symlinks)
  };
}
```

Each enabled rice is seeded into `~/.tapes/<name>` with its Nix runtime dependencies, QML plugins, and fonts installed, ready to insert via `tapes insert <name>` or `tapes-deck`.

</details>

----

## Contributing
Want to add a tape? Read [CONTRIBUTING.md](CONTRIBUTING.md) for the structure, the `tape.toml` format and the rules for `setup.sh`.


[tapes]: https://github.com/futurekismo-oss/tapes
