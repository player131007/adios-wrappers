{ types, ... }:
{
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
  };

  options = {
    configContents = {
      type = types.string;
      description = ''
        Settings to be injected into the wrapped package's `dunstrc`.

        See the documentation for syntax and valid options:
        https://dunst-project.org/documentation/

        Disjoint with the `configFile` option.
      '';
    };
    configFile = {
      type = types.pathLike;
      description = ''
        `dunstrc` file to be injected into the wrapped package.

        See the documentation for syntax and valid options:
        https://dunst-project.org/documentation/

        Disjoint with the `configContents` option.
      '';
    };

    dropinFiles = {
      type = types.listOf types.pathLike;
      description = ''
        `*.conf` files to be injected into the wrapped package alongside the main configuration.

        See the documentation for syntax and valid options:
        https://dunst-project.org/documentation/dunst/#FILES
      '';
    };

    package = {
      type = types.derivation;
      description = "The dunst package to be wrapped.";
      defaultFunc = { inputs }: inputs.nixpkgs.pkgs.dunst;
    };
  };

  impl =
    { options, inputs }:
    let
      inherit (builtins) listToAttrs;
      inherit (inputs.nixpkgs.pkgs) writeText;
    in
    assert !(options ? configContents && options ? configFile);
    inputs.mkWrapper {
      inherit (options) package;
      symlinks = {
        "$out/dunst/dunstrc" =
          if options ? configFile then
            options.configFile
          else if options ? configContents then
            writeText "dunstrc" options.configContents
          else
            null;
      }
      // (
        if options ? dropinFiles then
          listToAttrs (
            map (path: {
              name = "$out/dunst/dunstrc.d/${baseNameOf path}";
              value = path;
            }) options.dropinFiles
          )
        else
          {}
      );

      environment = {
        XDG_CONFIG_HOME = "$out";
      };
    };

  meta = {
    maintainers = [ "mango" ];
  };
}
