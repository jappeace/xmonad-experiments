# this is the machine image, spawns all services
{ hardware-path ? ./hardware/remote.nix, ... }:

let

  pkgs = import ./pin.nix { };
  sshPort = 6023;
  config = {
    imports = [ hardware-path ];
    swapDevices = [ {
        device="/swapfile";
        size=1024*5;
        }];

    programs = {
        vim.defaultEditor = true;
    };

    services.openssh = {
        enable = true;
        permitRootLogin = "yes";
        ports = [ sshPort ];
    };

    users.extraUsers.root = {
        openssh.authorizedKeys.keys = (import encrypted/keys.nix { });
    };
    users.extraUsers.jappie = {
        createHome = true;
        extraGroups = ["wheel" "video" "audio" "disk" "networkmanager"];
        group = "users";
        home = "/home/jappie";
        openssh.authorizedKeys.keys = (import encrypted/keys.nix { });
        isNormalUser = true;
        uid = 1000;
        shell = pkgs.bash;
    };
    users.extraGroups.vboxusers.members = [ "jappie" ];

    networking = {
        firewall.allowedTCPPorts = [ sshPort ];
    };
  };
in
{ 
  system.build.image = import <nixpkgs/nixos/lib/make-disk-image.nix> {
      name = "nixos-vmdk-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
      format = "vpc";
      inherit pkgs config;
      lib = pkgs.lib;
      partitionTableType = "legacy";
      diskSize = 11 * 1024;
  };
}
