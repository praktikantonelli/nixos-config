{ inputs, ... }: {
  programs.git = {
    enable = true;

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
