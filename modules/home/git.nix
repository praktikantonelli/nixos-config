{ inputs, ... }:
{
  programs.git = {
    enable = true;
    signing.format = "openpgp";

    settings = {
      user = {
        name = "Luca";
        email = inputs.secrets.email;

      };
      init.defaultBranch = "main";
      credential.helper = "store";
      core.editor = "nvim";
    };
  };

}
