{ config, lib, pkgs, ... }:

let
  keydConfig = ''
    [ids]
    
    *
    
    [main]
    
    shift = oneshot(shift)
    meta = oneshot(meta)
    control = oneshot(control)
    
    leftalt = oneshot(alt)
    rightalt = oneshot(altgr)
    
    capslock = overload(control, esc)
    insert = S-insert
  '';
  keyd = pkgs.callPackage (import ./derivation.nix) { };
in
{
  environment.systemPackages = [
    keyd
  ];

  environment.etc."keyd/default.conf".text = keydConfig;

  # system service
  systemd.services.keyd = {
      description = "key remapping daemon";
      requires = [ "local-fs.target" ];
      after = [ "local-fs.target" ];
      wantedBy = [ "sysinit.target" ];
      serviceConfig = {
        ExecStart = "${keyd}/bin/keyd";
        # Restart = "on-failure";
        Type = "simple";
      };
  };

  # keyd group for extra config
  users.groups.keyd = {};
}
