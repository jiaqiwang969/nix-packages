{ stdenv, fetchFromGitLab, cmake, gfortran, bison, bzip2, mpi, flex, xz, zlib, lib }:

let
  version = "7.0.6"; # 显式定义版本号
in

stdenv.mkDerivation {
  pname = "scotch";
  inherit version;

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "scotch";
    repo = "scotch";
    rev = "v${version}"; # 使用显式定义的版本号
    hash = "sha256-RW1H0By7jqSM9bT4v6zIuaAZj3iyM1vNsfIcFlRxlkc=";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_INSTALL_PREFIX=$out"
  ];

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs = [
    bison
    bzip2
    mpi
    flex
    xz
    zlib
  ];

  installPhase = ''
    make install DESTDIR=$out

    mkdir -p $out/bin $out/lib $out/include

    mv $out/*/bin/* $out/bin/ 2>/dev/null || true
    mv $out/*/lib/* $out/lib/ 2>/dev/null || true
    mv $out/*/include/* $out/include/ 2>/dev/null || true

    find $out -type d -empty -delete
  '';

  meta = {
    description = "Graph and mesh/hypergraph partitioning, graph clustering, and sparse matrix ordering";
    homepage = "http://www.labri.fr/perso/pelegrin/scotch";
    license = lib.licenses.cecill-c;
    maintainers = [ lib.maintainers.bzizou ];
  };
}
