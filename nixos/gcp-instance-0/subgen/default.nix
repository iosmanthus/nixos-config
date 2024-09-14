{ config, ... }:
let
  outboundTemplates = {
    shadowtls = {
      type = "shadowtls";
      version = 3;
      password = config.sops.placeholder."sing-box/shadowtls/password";
      tls = {
        enabled = true;
        server_name = config.sops.placeholder."sing-box/shadowtls/server-name";
        utls = {
          enabled = true;
          fingerprint = "firefox";
        };
      };
    };
    shadowsocks = {
      type = "shadowsocks";
      method = config.sops.placeholder."sing-box/shadowsocks/method";
      multiplex = {
        enabled = true;
        padding = true;
      };
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

    ../../../secrets/cloud/sing-box/secrets.json
    ../../../secrets/cloud/subgen/secrets.json
  ];

  sops.templates."config.jsonnet".content = ''
    function(secrets)
    local users = ${config.sops.placeholder."subgen/users"};
    local shadowsocksServerPassword = 
      '${config.sops.placeholder."sing-box/shadowsocks/server-password"}';
    local shadowsocksUsers = std.foldl(
      function(acc, user) acc + {
          [user.name]: {
            password: shadowsocksServerPassword + ':' + user.password,
          },
        },
      ${config.sops.placeholder."sing-box/shadowsocks/users"},
      {}
    );
    local mkInputs = function(username) [
      {
        type: 'local',
        name: 'outboundTemplates',
        value: ${builtins.toJSON outboundTemplates},
      },
      {
        type: 'remote',
        name: 'relaySubscription',
        url: '${config.sops.placeholder."subgen/relay-subscription-url"}',
      },
      {
        type: 'local',
        name: 'shadowsocksUser',
        value: shadowsocksUsers[username],
      },
      {
        type: 'local',
        name: 'defaultDnsServer',
        value: 'udp://' +
          '${config.sops.placeholder."gcp-instance-0/external-address-v4"}:' +
          '${toString config.services.self-hosted.chinadns.port}',
      },
      {
        type: 'local',
        name: 'originGroup',
        value: [
          {
            tag: 'gcp-asia-east-1',
            server: '${config.sops.placeholder."gcp-instance-0/external-address-v4"}',
            server_port: 18443,
          },
          {
            tag: 'gcp-us-west-1',
            server: '${config.sops.placeholder."gcp-instance-1/external-address-v4"}',
            server_port: 18443,
          },
          {
            tag: 'aws-ap-southeast-1',
            server: '${config.sops.placeholder."aws-lightsail-0/external-address-v4"}',
            server_port: 18443,
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
