self: super: {
  installApplication = { name, appname ? name, version, src, description
    , homepage, postInstall ? "", sourceRoot ? ".", ... }:
    with super;
    stdenv.mkDerivation {
      name = "${name}-${version}";
      version = "${version}";
      src = src;
      buildInputs = [ undmg unzip ];
      sourceRoot = sourceRoot;
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = ''
        mkdir -p "$out/Applications/${appname}.app"
        cp -pR * "$out/Applications/${appname}.app"
      '' + postInstall;
      meta = with super.lib; {
        description = description;
        homepage = homepage;
        maintainers = with maintainers; [ jwiegley ];
        platforms = platforms.darwin;
      };
    };

  iTerm2 = self.installApplication rec {
    name = "iTerm2";
    appname = "iTerm";
    version = "3_4_4";
    sourceRoot = "iTerm.app";
    src = super.fetchurl {
      url = "https://iterm2.com/downloads/stable/iTerm2-${version}.zip";
      sha256 =
        "cdf6dce864e53f60445f012cf6e4fb8113ed0ae28532921a0dec835565eb4b13";
      # date = 2019-10-09T08:28:05-0700;
    };
    description =
      "iTerm2 is a replacement for Terminal and the successor to iTerm";
    homepage = "https://www.iterm2.com";
  };
}
