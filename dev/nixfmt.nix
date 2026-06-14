{ nixfmt, fetchFromGitHub }:

nixfmt.overrideAttrs {
  dontVersionCheck = true;
  src = fetchFromGitHub {
    owner = "llakala";
    repo = "nixfmt";
    rev = "a9719fef6619eb931ec71bcff6d1c584a74e477e";
    hash = "sha256-EakufsS1XKqHT0Hlo4bXd0PPxTjx+XmabFLHWt/pFbc=";
  };
}
