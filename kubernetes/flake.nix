{
  description = "Tools needed for deploying the sample Kubernetes pygeoapi setup";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true; # For `postman`
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            bzip2
            kubectl
            minikube

            # Keep this line if you use bash.
            bashInteractive
          ];

          shellHook = ''
          '';
        };
      });
}
