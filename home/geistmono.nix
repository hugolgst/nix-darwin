{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "geistmono-nerdfonts";
  version = "3.3.0";

  src = pkgs.fetchzip {
    url =
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/GeistMono.zip";
    sha256 = "sha256-4El6oqFDs3jYLbyQfFgDvGz9oP2s3hZ/hZO13Afah0g=";
    stripRoot = false;
  };

  installPhase = ''
    echo "Contents of the source directory:"
    ls -la

    echo "Finding font files..."
    mkdir -p $out/share/fonts/truetype

    # Find all font files and copy them to the output directory
    find . -type f \( -name "*.ttf" -o -name "*.otf" \) | while read -r font; do
      echo "Installing font: $font"
      install -m444 "$font" $out/share/fonts/truetype/
    done

    # Verify installed fonts
    echo "Installed fonts:"
    ls -la $out/share/fonts/truetype/
  '';

  meta = with pkgs.lib; {
    description = "GeistMono Nerd Font";
    homepage = "https://github.com/ryanoasis/nerd-fonts";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
