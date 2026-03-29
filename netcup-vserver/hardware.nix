{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ 
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  networking = {
    useDHCP = lib.mkDefault true;

    nameservers = [
      "46.38.225.230"
      "46.38.252.230"
      "2a03:4000:0:1::e1e6"
      "2a03:4000:8000::fce6"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
