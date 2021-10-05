{ lib
, stdenv
, fetchurl
, cmake
, suitesparse
, lapack
, blas
, metis
, libf2c
, gnutar
}:

stdenv.mkDerivation rec {
  pname = "sparselm";
  version = "1.3";
  src = fetchurl {
    url = "https://users.ics.forth.gr/~lourakis/sparseLM/sparselm-${version}.tgz";
    sha256 = "sha256-3t1sJYuJE438R3WzLokY3dGl0FsprfmiEBRW/DMo3cU=";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [ suitesparse lapack blas metis ];
  cmakeFlags =
    let
      suiteSparseLibs = map (name: "-D${name}_LIBDIR=${suitesparse}/lib") [ "CHOLMOD" "CSPARSE" "LDL" "UMFPACK" "AMD" ];
    in
    suiteSparseLibs ++ [
      "-DSUITESPARSE_PATH=${suitesparse}"
      "-DHAVE_CHOLMOD=yes"
    ] ++ [
      "-DMETIS_LIBDIR=${metis}/lib"
      "-DMETIS_LIBS=metis"
      "-DCHOLMOD_LIBS=cholmod"
      "-DAMD_LIBS=ccolamd;colamd;camd;amd"
      "-DF2C_LIB_NAME=${libf2c}/lib/libf2c.a"
      "-DCMAKE_CXX_FLAGS=-lm"
      "-DCMAKE_EXE_LINKER_FLAGS=-lm"
    ];
  installPhase = ''
    mkdir -p $out/lib $out/include/sparselm
    install -D libsplm.a $out/lib/libsplm.a
    ${gnutar}/bin/tar -xf ${src} -C $out/include/sparselm --strip-components=1 sparselm-1.3/splm.h sparselm-1.3/splm_priv.h 
    mkdir -p $out/share/pkgconfig

    cat <<EOF > $out/share/pkgconfig/sparselm.pc
    prefix=$out
    exec_prefix=\''${prefix}

    Name: sparselm
    Version: 1.3
    Description: Sparse Levenberg-Marquardt nonlinear least squares in C/C++
    Libs: -l\''${prefix}/lib/libsplm.a
    Cflags: -I\''${prefix}/include/sparselm
    EOF

    cat $out/share/pkgconfig/sparselm.pc >&2
  '';
  checkPhase = ''
    ./splmdemo
  '';
  doCheck = true;
}
