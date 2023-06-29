{ stdenvNoCC, fetchzip, makeDesktopItem, makeWrapper,lib, steam-run }:

stdenvNoCC.mkDerivation rec {
  pname = "BloodHound";
  version = "4.3.1";

  src = fetchzip {
      url = "https://github.com/BloodHoundAD/BloodHound/releases/download/v${version}/BloodHound-linux-x64.zip";
      name = "${pname}-linux-x64.zip";
      hash = "sha256-gGfZ5Mj8rmz3dwKyOitRExkgOmSVDOqKpPxvGlE4izw=";
  };

  dontBuild = true;
  dontConfigure = true;


  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications

    cp -r . $out/share/${pname}
    
    for icon in $out/share/${pname}/resources/app/src/img/*.png; do 
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/BloodHound"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/BloodHound/icon.png"
    done

    ln -s "${desktopItem}/share/applications" "$out/share/applications"

    makeWrapper ${steam-run}/bin/steam-run $out/bin/${pname} \
    --add-flags $out/share/${pname}/${pname}

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = "BloodHound";
    exec = "${pname}";
    icon = "logo-white-transparent-full";
    desktopName = "BloodHound";
    genericName = "BloodHound";
    comment = meta.description;
    categories = [ "Security" "System" ];
  };

  meta = with lib; {
    description = "BloodHound is a single page Javascript web application, built on top of Linkurious, compiled with Electron, with a Neo4j database fed by a C# data collector.";
    homepage = "https://github.com/BloodHoundAD/BloodHound";
    mainProgram = "BloodHound";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
  };
}
