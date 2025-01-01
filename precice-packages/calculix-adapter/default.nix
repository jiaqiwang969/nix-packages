{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  gcc,
  pkg-config,
  arpack,
  lapack,
  blas,
  spooles,
  libyamlcpp,
  precice,
  openmpi,
}:
let
  ccx_version = "2.20";  # 保持 CalculiX 版本不变
  ccx = fetchzip {
    urls = [
      "https://www.dhondt.de/ccx_2.20.src.tar.bz2"
      "https://web.archive.org/web/20240302101853if_/https://www.dhondt.de/ccx_2.20.src.tar.bz2"
    ];
    hash = "sha256-bCmG+rcQDJrcwDci/WOAgjfbhy1vxdD+wnwRlt/ovKo=";  # 保持 CalculiX 的 hash 不变
  };
in
stdenv.mkDerivation rec {
  pname = "calculix-adapter";
  version = "2.20.1";  # 更新为 2.20.1

  src = fetchFromGitHub {
    owner = "precice";
    repo = pname;
    rev = "51cf77765a0fe0badd86e541deb3eb914ee8a9f9";  # 更新为新的 rev
    hash = "sha256-TT6yBOlJbGwSoYU9BQhAanrDy5IxE7eaEDgSw3lC0f8=";  # 更新为新的 hash
  };

  nativeBuildInputs = [
    gcc
    pkg-config
    arpack
    lapack
    blas
    spooles
    libyamlcpp
    precice
    openmpi
  ];

  buildPhase = ''
    mpifort --version
    make -j \
      CCX=${ccx}/ccx_2.20/src \
      SPOOLES_INCLUDE="-I${spooles}/include/spooles/" \
      ARPACK_INCLUDE="$(${pkg-config}/bin/pkg-config --cflags-only-I arpack lapack blas)" \
      ARPACK_LIBS="$(${pkg-config}/bin/pkg-config --libs arpack lapack blas)" \
      YAML_INCLUDE="$(${pkg-config}/bin/pkg-config --cflags-only-I yaml-cpp)" \
      YAML_LIBS="$(${pkg-config}/bin/pkg-config --libs yaml-cpp)" \
      ADDITIONAL_FFLAGS=-fallow-argument-mismatch
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}

    cp bin/ccx_preCICE $out/bin
    cp bin/ccx_2.20.a $out/lib
  '';

  meta = {
    description = "preCICE-adapter for the CSM code CalculiX";
    homepage = "https://precice.org/adapter-calculix-overview.html";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ conni2461 ];
    mainProgram = "ccx_preCICE";
    platforms = lib.platforms.unix;
  };
}
