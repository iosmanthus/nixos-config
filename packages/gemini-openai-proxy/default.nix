{ buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "gemini-openai-proxy";

  version = "unstable-2024-04-24";

  src = fetchFromGitHub {
    owner = "iosmanthus";
    repo = "gemini-openai-proxy";
    rev = "7b63124d4ca9eddd42354f0ccbe2725e051daa63";
    hash = "sha256-qhSHeQUS3JtlsYFQoU86dzHyZgiGkVsGoAe5fZ4WTfc=";
  };

  vendorHash = "sha256-Hwhn5a1ZBMg6Bo0rfQZ5uZb96zl0npJTXQKfyfYEw5w=";
}
