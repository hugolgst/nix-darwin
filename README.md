```bash
# Install nix
sh <(curl -L https://nixos.org/nix/install)
# Build config and install darwin-rebuild
nix run nix-darwin -- switch --flake ~/.config/nix-darwin
```
