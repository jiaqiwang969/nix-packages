{ stdenv, fetchFromGitLab, cmake, gfortran, bison, bzip2, mpi, flex, xz, zlib, lib }:

stdenv.mkDerivation {
  pname = "scotch";
  version = "7.0.6";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "scotch";
    repo = "scotch";
    rev = "v${version}";
    hash = "sha256-RW1H0By7jqSM9bT4v6zIuaAZj3iyM1vNsfIcFlRxlkc=";
  };

  # 使用单一输出
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_INSTALL_PREFIX=$out"   # 确保所有内容安装到 $out
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

  # 重定义安装阶段，确保所有文件放入单一路径
  installPhase = ''
    # 默认安装
    make install DESTDIR=$out

    # 确保目录结构正确
    mkdir -p $out/bin $out/lib $out/include

    # 如果二进制、库文件或头文件未正确放置，可以手动移动
    mv $out/*/bin/* $out/bin/ 2>/dev/null || true
    mv $out/*/lib/* $out/lib/ 2>/dev/null || true
    mv $out/*/include/* $out/include/ 2>/dev/null || true

    # 删除多余的空目录
    find $out -type d -empty -delete
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
  };
}
