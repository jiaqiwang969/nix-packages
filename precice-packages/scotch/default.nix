{lib, stdenv, fetchFromGitLab, cmake, gfortran, bison, bzip2, mpi, flex, xz, zlib }:

stdenv.mkDerivation {
  pname = "scotch";
  version = "7.0.6";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "scotch";
    repo = "scotch";
    rev = "v7.0.6";
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

  meta = {
    description = "Graph and mesh/hypergraph partitioning, graph clustering, and sparse matrix ordering";
    homepage = "http://www.labri.fr/perso/pelegrin/scotch";
    license = stdenv.lib.licenses.cecill-c;
    maintainers = with stdenv.lib.maintainers; [ bzizou ];
  };
}