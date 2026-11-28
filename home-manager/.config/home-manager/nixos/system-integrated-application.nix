{ workstationUser, ... }:

# Apps that need system integration. Everything else goes in home/desktop.nix.
{
  ###################################
  # 1Password
  ###################################
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ workstationUser ];
  };

  ###################################
  # localsend
  ###################################
  programs.localsend.enable = true;
}
