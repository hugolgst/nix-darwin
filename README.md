```bash
sh <(curl -L https://nixos.org/nix/install)
```

Change hostname in `flake.nix` and change username + home in `home/default.nix`.

```bash
nix run nix-darwin -- switch --flake ~/.config/nix-darwin
```
