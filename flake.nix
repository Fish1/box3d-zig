{
  description = "box3d zig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zigflake = {
      url = "github:silversquirl/zig-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      zigflake,
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      zig = zigflake.packages.x86_64-linux.zig_0_17_0;
      zls = zigflake.packages.x86_64-linux.zig_0_17_0.zls;
    in
    {
      devShells.x86_64-linux = {
        default = pkgs.mkShell {
          packages = [
            zig
            zls
          ];
        };
      };
    };
}
