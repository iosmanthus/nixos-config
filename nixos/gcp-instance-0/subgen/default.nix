{ config
, ...
}:
let
  outboundTemplates = {
    vless = {
      type = "vless";
      tcp_fast_open = true;
      tls = {
        enabled = true;
        server_name = config.sops.placeholder."sing-box/vless/reality/server-name";
        utls = {
          enabled = true;
          fingerprint = "firefox";
        };
        reality = {
          enabled = true;
          public_key = config.sops.placeholder."sing-box/vless/reality/public-key";
          short_id = config.sops.placeholder."sing-box/vless/reality/short-id";
        };
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
    local vlessUsers = std.foldl(
      function(acc, user) acc + {
          [user.name]: {
            uuid: user.uuid,
            flow: user.flow,
          },
        },
      ${config.sops.placeholder."sing-box/vless/users"},
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
        name: 'vlessUser',
        value: vlessUsers[username],
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
            server_port: 10080,
          },
          {
            tag: 'gcp-us-west-1',
            server: '${config.sops.placeholder."gcp-instance-1/external-address-v4"}',
            server_port: 10080,
          },
          {
            tag: 'aws-ap-southeast-1',
            server: '${config.sops.placeholder."aws-lightsail-0/external-address-v4"}',
            server_port: 10080,
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
