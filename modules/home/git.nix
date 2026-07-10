{ config, inputs, ... }:
{
  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Luca";
        email = inputs.secrets.email;

      };
      init.defaultBranch = "main";
      credential.helper = "store";
      core.editor = "nvim";
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
    };
  };

  home.file.".ssh/allowed_signers".text = ''
    ${inputs.secrets.email} namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBJ8I33Kaq9DW9eWl2wAujokyM+QjqFA1hRgfBsAs9I ${inputs.secrets.email}
  '';

}
