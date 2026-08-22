{ ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    pulse.enable      = true;
    wireplumber.enable = true;
  };

  # Ensure the built-in analog sink has highest priority
  # so the AK820 knob always controls the right device
  services.pipewire.wireplumber.extraConfig."99-default-sink" = {
    "monitor.alsa.rules" = [{
      matches = [{ "node.name" = "alsa_output.pci-0000_00_1f.3.analog-stereo"; }];
      actions = { update-props = { "priority.session" = 2000; }; };
    }];
  };
}
