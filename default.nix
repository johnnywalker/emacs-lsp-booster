{
  rustPlatform,
  lib,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "emacs-lsp-booster";
  version = "0.2.1-1";

  cargoSha256 = "sha256-xwrMrhhFcoQDOhYQyjR1iKSnRn0zaOa2odHzqgmIsYw=";

  src = lib.cleanSource ./.;

  # The tests contain what are essentially benchmarks—it seems prudent not to
  # stress our users' computers in that way every time they build the package.
  doCheck = false;

  meta = with lib; {
    description = "Improve performance of Emacs LSP servers by converting JSON to bytecode";
    homepage = "https://github.com/blahgeek/${pname}";
    license = [licenses.mit];
    maintainers = [];
    mainProgram = "emacs-lsp-booster";
  };
}
