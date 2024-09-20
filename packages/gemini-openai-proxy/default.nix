{ buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "gemini-openai-proxy";

  version = "unstable-2024-09-18";

  src = fetchFromGitHub {
    owner = "zhu327";
    repo = "gemini-openai-proxy";
    rev = "0ae0c82235df8929c17efcaebae50368b9fe6eb4";
    hash = "sha256-Hgl2uUegBK/2Pd6SMH15Y0BlOuL+AtU/FXSZXwD3+VI=";
  };

  vendorHash = "sha256-Hwhn5a1ZBMg6Bo0rfQZ5uZb96zl0npJTXQKfyfYEw5w=";
}
