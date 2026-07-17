{ ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.pipewire.wireplumber.extraConfig."99-default-sink" = {
    "monitor.alsa.rules" = [{
      matches = [{ "node.name" = "alsa_output.pci-0000_00_1f.3.analog-stereo"; }];
      actions = { update-props = { "priority.session" = 2000; }; };
    }];
  };

 # ← ADD THIS BLOCK (volume knob fine-grained control)
  services.pipewire.extraConfig.pipewire-pulse."context.modules" = [
    {
      name = "libpipewire-module-pulse-device";
      args = {
        "pulse.min.req" = 128;
        "pulse.default.req" = 512;
        "pulse.max.req" = 512;
        "pulse.min.frag" = 128;
        "pulse.default.frag" = 512;
        "pulse.max.frag" = 512;
      };
    }
  ];
}

