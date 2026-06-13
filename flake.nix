{
  inputs.adios.url = "github:llakala/lladios"; # My personal fork

  outputs = inputs: {
    wrapperModules = import ./default.nix {
      adios = inputs.adios;
    };
  };
}
