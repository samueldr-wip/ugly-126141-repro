{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  networking.useDHCP = false;
  networking.interfaces.br0.useDHCP = true;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.virbr0.useDHCP = true;
  networking.interfaces.virbr0-nic.useDHCP = true;
  system.stateVersion = "20.09"; # Did you read the comment?

  # ---------------------------------------------------------------------------

  environment.systemPackages = with pkgs; [
    # Does not reproduce
    #(hello.overrideAttrs(_: { forceRebuild = 1; postInstall = "echo hi"; }))
    # Reproduces (requires allowUnfree)
    #tigervnc
  ];

  fonts.fonts = with pkgs; [
    # Artturin's issue
    fira-code
  ];

  # For tigervnc; which is what I hit the issue on personally.
  #nixpkgs.config.allowUnfree = true;
}
