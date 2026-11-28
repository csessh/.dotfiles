{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lsoff";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "yutat23";
    repo = "lsoff";
    rev = "v${version}";
    hash = "sha256-ZhckDheORnoKz2468jUu1J4bAvY9yA8opUFn84alguA=";
  };

  vendorHash = "sha256-IQJQwWWL7fRbfA+u92yv7oV5LYuhu8BW4DGTlHHwXs4=";

  meta = with lib; {
    description = "lsof-like TUI for listing listening TCP/UDP ports";
    homepage = "https://github.com/yutat23/lsoff";
    license = licenses.mit;
    mainProgram = "lsoff";
  };
}
