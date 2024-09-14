{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  nix-update-script,
}:

buildGoModule rec {
  pname = "sing-box";

  version = "1.10.0-alpha.20";

  src = fetchFromGitHub {
    # owner = "SagerNet";
    owner = "iosmanthus";
    repo = pname;
    rev = "052273fa0c221390112e171a90f6c6ad6332d45b";
    hash = "sha256-3O5J/0+5MJs+iq3MPB8UaKLb+QSlNiD82X8yoLRrMTo=";
  };

  proxyVendor = true;

  vendorHash = "sha256-7s1al/w53ylD6LmIkDxGuhq3p3tWotnpbi21IkfnZVc=";

  tags = [
    "with_quic"
    "with_grpc"
    "with_dhcp"
    "with_wireguard"
    "with_ech"
    "with_utls"
    "with_reality_server"
    "with_acme"
    "with_clash_api"
    "with_v2ray_api"
    "with_gvisor"
  ];

  subPackages = [ "cmd/sing-box" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-X=github.com/sagernet/sing-box/constant.Version=${version}" ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd sing-box \
        --bash <(${emulator} $out/bin/sing-box completion bash) \
        --fish <(${emulator} $out/bin/sing-box completion fish) \
        --zsh  <(${emulator} $out/bin/sing-box completion zsh )
    '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://sing-box.sagernet.org";
    description = "The universal proxy platform";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
