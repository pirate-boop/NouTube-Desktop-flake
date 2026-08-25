{ lib
, stdenv
, unzip
, makeWrapper
, electron
, copyDesktopItems
, makeDesktopItem
, sources
}:

stdenv.mkDerivation rec {
  pname = "noutube";
  version = sources.noutube.version;
  src = sources.noutube.src;

  nativeBuildInputs = [
    unzip
    makeWrapper
    copyDesktopItems
  ];

  unpackPhase = ''
    runHook preUnpack
    unzip -q $src
    runHook postUnpack
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "noutube";
      exec = "noutube %U";
      icon = "noutube";
      desktopName = "NouTube";
      genericName = "YouTube & YouTube Music Client";
      comment = "YouTube and YouTube Music in a single app";
      categories = [ "AudioVideo" "Video" "Audio" "Player" ];
      startupWMClass = "NouTube";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/noutube $out/share/pixmaps $out/bin

    # Handle subfolder extracted by electron-builder zip
    if [ -d "dist/linux-unpacked" ]; then
      cd dist/linux-unpacked
    fi

    # Copy resources folder containing app.asar
    cp -r resources $out/share/noutube/

    # Copy application icon if available
    if [ -f resources/icon.png ]; then
      cp resources/icon.png $out/share/pixmaps/noutube.png
    fi

    # Create binary wrapper executing system Electron with app.asar
    makeWrapper ${electron}/bin/electron $out/bin/noutube \
      --add-flags "$out/share/noutube/resources/app.asar" \
      --add-flags "--ozone-platform-hint=auto" \
      --add-flags "--enable-features=WaylandWindowDecorations"

    runHook postInstall
  '';

  meta = with lib; {
    description = "YouTube and YouTube Music in a single app";
    homepage = "https://github.com/nonbili/NouTube-Desktop";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    mainProgram = "noutube";
  };
}
