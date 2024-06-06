{ config
, ...
}:
let
  finalNode = {
    shadowtls = {
      type = "shadowtls";
      version = 3;
      password = config.sops.placeholder."sing-box/shadowtls/password";
      tls = {
        enabled = true;
        server_name = config.sops.placeholder."sing-box/shadowtls/handshake/server";
        utls = {
          enabled = true;
          fingerprint = "chrome";
        };
      };
    };
    shadowsocks = {
      type = "shadowsocks";
      method = config.sops.placeholder."sing-box/shadowsocks/method";
      password = config.sops.placeholder."sing-box/shadowsocks/password";
      udp_over_tcp = true;
    };
  };
in
{
  services.self-hosted.subgen = {
    enable = true;
    configFile = config.sops.templates."config.jsonnet".path;
    exprPath = ./.;
  };

  systemd.services.subgen.restartTriggers = [
    config.sops.templates."config.jsonnet".content
  ];

  sops.templates."config.jsonnet".content = ''
    function(secrets)
    local users = ${config.sops.placeholder."subgen/users"};
    local sspasswords = std.foldl(
      function(acc, user)
        acc + {
          [user.name]: user.password,
        },
      ${config.sops.placeholder."sing-box/shadowsocks/users"},
      {}
    );
    local mkInputs = function(username) [
      {
        type: 'local',
        name: 'finalNode',
        value: ${builtins.toJSON finalNode},
      },
      {
        type: 'remote',
        name: 'subscription',
        url: "${config.sops.placeholder."subgen/subscription-url"}",
      },
      {
        type: 'local',
        name: 'ssUserPassword',
        value: sspasswords[username],
      },
      {
        type: 'local',
        name: 'originGroup',
        value: [
          {
            tag: 'aws-ap-southeast-1',
            host: '${config.sops.placeholder."aws-lightsail-0/external-address-v4"}',
            port: 10080,
          },
          {
            tag: 'gcp-asia-east-1',
            host: '${config.sops.placeholder."gcp-instance-0/external-address-v4"}',
            port: 10080,
          },
          {
            tag: 'gcp-us-west-1',
            host: '${config.sops.placeholder."gcp-instance-1/external-address-v4"}',
            port: 10080,
          },
        ],
      },
    ];
    local mkProfile = function(username, hashedPassword) {
      name: username,
      auth: {
        hashedPassword: hashedPassword,
      },
      inputs: mkInputs(username),
      expr: {
        type: 'local',
        path: 'default.jsonnet',
      },
    };
    {
      profiles: std.map(
        function(user) mkProfile(user.name, user.hashedPassword),
        users,
      ),
    }
  '';
}
