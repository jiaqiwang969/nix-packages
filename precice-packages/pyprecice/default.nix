{
  lib,
  fetchFromGitHub,
  python3,
  precice,
  pkg-config,
  openmpi,
  openssh,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "pyprecice";
  version = "3.1.2";  # 更新为 3.1.2

  src = fetchFromGitHub {
    owner = "precice";
    repo = "python-bindings";
    rev = "1f750461c1d023f4de5d394804393be0566f904e";  # 更新为新的 rev
    hash = "sha256-/atuMJVgvY4kgvrB+LuQZmJuSK4O8TJdguC7NCiRS2Y=";  # 更新为新的 hash
  };


  nativeBuildInputs = with python3.pkgs; [
    cython
    openmpi
    openssh
    pkg-config
  ];

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.mpi4py
    precice
    python3.pkgs.pkgconfig
  ];

  doCheck = false;

  meta = with lib; {
    description = "Python language bindings for preCICE";
    homepage = "https://github.com/precice/python-bindings";
    license = [ licenses.lgpl3Only ];
    maintainers = with maintainers; [ conni2461 ];
    platforms = lib.platforms.unix;
  };
}
