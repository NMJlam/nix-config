{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }: {
    nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        ({ pkgs, ... }: {
          networking.hostName = "homelab";
          networking.networkmanager.enable = true;

          users.users.nathan = {
            isNormalUser = true;
            extraGroups = [ "wheel" "networkmanager" ];
          };

          services.openssh.enable = true;

          nix.settings.experimental-features = [ "nix-command" "flakes" ];
          environment.systemPackages = [ pkgs.git ];
        })
      ];
    };
  };
}
