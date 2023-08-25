{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
, nix-update-script
}:

buildGoModule rec {
  pname = "sing-box";
  version = "unstable-2023-08-12";

  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = pname;
    rev = "a89d51f4f73efb22914476c01f6878674cdbb158";
    sha256 = "1j6h3hx29sylspibc70i0df7ng87n9ban8bc41kazajys09d6f4b";
  };

  proxyVendor = true;

  vendorSha256 = "1yj1nx8i35najcrpwnggbl4av16qbn01l1f53f56hf9zsg8jyk6i";

  tags = [
    "with_quic"
    "with_grpc"
    "with_dhcp"
    "with_wireguard"
    "with_shadowsocksr"
    "with_ech"
    "with_utls"
    "with_reality_server"
    "with_acme"
    "with_clash_api"
    "with_v2ray_api"
    "with_gvisor"
  ];

  subPackages = [
    "cmd/sing-box"
  ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-X=github.com/sagernet/sing-box/constant.Version=${version}"
  ];

  postInstall = let emulator = stdenv.hostPlatform.emulator buildPackages; in ''
    installShellCompletion --cmd sing-box \
      --bash <(${emulator} $out/bin/sing-box completion bash) \
      --fish <(${emulator} $out/bin/sing-box completion fish) \
      --zsh  <(${emulator} $out/bin/sing-box completion zsh )
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib;{
    homepage = "https://sing-box.sagernet.org";
    description = "The universal proxy platform";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
