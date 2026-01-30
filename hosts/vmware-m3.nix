{ ... }:
{
  imports = [
    ./vmware.nix
    ./vmware-m3-hardware.nix
  ];

  networking.hostName = "vmware-m3";
}
