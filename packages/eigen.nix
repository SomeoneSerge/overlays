{ lib
, stdenv
, fetchFromGitLab
, cmake
, suitesparse
}:

stdenv.mkDerivation rec {
  pname = "eigen";
  version = "3.4-rc1";

  src = fetchFromGitLab {
    owner = "libeigen";
    repo = pname;
    rev = version;
    hash = "sha256-YBdj7qnfZkRfQtaM9COedPrFxJTAus6ebl1cSMt4YAs=";
  };

  # relative to CMAKE_INSTALL_PREFIX
  cmakeFlags = [
    "-DINCLUDE_INSTALL_DIR=include/eigen3"
  ];

  patches = [
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://eigen.tuxfamily.org";
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ sander raskin ];
    platforms = platforms.unix;
  };
}
