let 
  alice = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBo4JtVDboLpPxWkFYypL9QOa25y3Qj808DGUXV0ZVdQ";
in 
{
  "BytzVPNAtlanta.ovpn.age".publicKeys = [ alice ];
  "BytzVPN.age".publicKeys = [ alice ];
}
