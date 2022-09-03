{ lib, stdenv, fetchFromGitHub, git, gcc, gnumake }:

stdenv.mkDerivation rec {
  pname = "keyd";
  version = "v2.4.2";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "keyd";
    rev = version;
    sha256 = "sha256-QWr+xog16MmybhQlEWbskYa/dypb9Ld54MOdobTbyMo=";
  };

  nativeBuildInputs = [ git gcc gnumake ];

  buildPhase = ''
    CC=gcc make all
  '';

  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/share/keyd/layouts/
    mkdir -p $out/share/man/man1/
    mkdir -p $out/share/doc/keyd/examples/
    mkdir -p $out/share/libinput/
    
    install -m755 bin/* $out/bin
    install -m644 docs/*.md $out/share/doc/keyd/
    install -m644 examples/* $out/share/doc/keyd/examples/
    install -m644 layouts/* $out/share/keyd/layouts
    install -m644 data/*.1.gz $out/share/man/man1/
    install -m644 data/keyd.compose $out/share/keyd/
    # NOTE: this is not the correct way to install quirks, it won't work
    install -Dm644 keyd.quirks $out/share/libinput/30-keyd.quirks
  '';

  meta = {
    description = "A key remapping daemon for linux";
    license = lib.licenses.mit;
    homepage = "https://github.com/rvaiya/keyd";
    platforms = lib.platforms.linux;
  };
}
