{ ... }:
{
  imports = [
    ./vmware.nix
    ./vmware-m1-hardware.nix
  ];

  networking.hostName = "vmware-m1";
}
