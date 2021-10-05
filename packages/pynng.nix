{ stdenv
, cmake
, perl
, python3Packages
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pynng";
  version = "0.6.2";
  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1xr6q2l1sd0g3vap6hm2g0d6hpw8jwz3i0xlk0fj8jcvjxa0b4j0";
  };
  isPy27 = false;

  dontUseCmakeConfigure = true;
  nativeBuildInputs = [
    cmake
    perl
  ];
  doCheck = false;
  propagatedBuildInputs = with python3Packages; [
    setuptools
    trio
    pytest
    urllib3
    pytest-trio
    pytest-asyncio
    pytestrunner
    cffi
    sniffio
  ];

  meta = with stdenv.lib; {
    description = "Python bindings for Nanomsg Next Generation";
    homepage = https://github.com/codypiersall/pynng;
  };
}
