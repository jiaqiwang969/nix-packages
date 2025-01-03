{ stdenv, fetchFromGitLab, bison, mpi, flex, zlib, lib }:

stdenv.mkDerivation {
  pname = "scotch";
  version = "6.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "scotch";
    repo = "scotch";
    rev = "v${version}";
    hash = "sha256-GUV6s+P56OAJq9AMe+LZOMPICQO/RuIi+hJAecmO5Wc=";
  };

  buildInputs = [
    bison
    mpi
    flex
    zlib
  ];

  preConfigure = ''
    cd src
    # 复制模板配置文件
    cp Make.inc/Makefile.inc.x86-64_pc_linux2 Makefile.inc
    # 启用共享库的构建
    sed -i 's/^LIB.*=.*/LIB       = .so/' Makefile.inc
    sed -i 's/^CCS.*=.*/CCS       = $(CC) -fPIC/' Makefile.inc
    sed -i 's/^CCP.*=.*/CCP       = $(CC) -shared/' Makefile.inc
  '';

  buildPhase = ''
    cd src
    make scotch
    make ptscotch
  '';

  installPhase = ''
    cd src
    make prefix=$out install
  '';

  meta = {
    description = "Graph and mesh/hypergraph partitioning, graph clustering, and sparse matrix ordering";
    longDescription = ''
      Scotch is a software package for graph and mesh/hypergraph partitioning, graph clustering,
      and sparse matrix ordering.
    '';
    homepage = "http://www.labri.fr/perso/pelegrin/scotch";
    license = lib.licenses.cecill-c;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.linux;
  };
}
