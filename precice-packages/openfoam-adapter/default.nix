{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  openfoam,
  precice,

  debugMode ? false,
  enableTimings ? false,
}:


stdenv.mkDerivation rec {
  pname = "precice-openfoam-adapter";
  version = "OpenFOAM9";  # 修改为 OpenFOAM9 分支

  src = fetchFromGitHub {
    owner = "precice";
    repo = "openfoam-adapter";
    rev = "a2885806836a4f516abce0be52128aa5083320fe";  # 更新为新的 rev
    hash = "sha256-C1B1WYct/VRwEBGJp7suCU4z1ymBcjIfBOBiAhrHy1c=";  # 更新为新的 hash
  };


  nativeBuildInputs = [
    openfoam
    pkg-config
    precice
  ];

  buildPhase = ''
    source ${openfoam}/bin/set-openfoam-vars

    export FOAM_USER_LIBBIN=$PWD
    export ADAPTER_TARGET_DIR=$PWD
    export ADAPTER_PREP_FLAGS="${lib.optionalString debugMode "-DADAPTER_DEBUG_MODE"} ${lib.optionalString enableTimings "-DADAPTER_ENABLE_TIMINGS"}"

    ./Allwmake -j -q

    cp ${openfoam}/bin/set-openfoam-vars .
    chmod 644 set-openfoam-vars
    echo "LD_LIBRARY_PATH=$out/lib:$LD_LIBRARY_PATH" >> set-openfoam-vars
  '';

  installPhase = ''
    mkdir -p $out/lib $out/bin
    cp libpreciceAdapterFunctionObject.so $out/lib/
    cp ./set-openfoam-vars $out/bin/set-openfoam-adapter-vars
  '';

  meta = {
    description = "An OpenFOAM function object for CHT, FSI, and fluid-fluid coupled simulations using preCICE";
    homepage = "https://precice.org/adapter-openfoam-overview.html";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ cheriimoya ];
    platforms = lib.platforms.unix;
  };
}
