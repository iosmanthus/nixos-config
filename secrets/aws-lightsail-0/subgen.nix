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
      multiplex = {
        enabled = true;
        min_streams = 4;
        max_streams = 8;
      };
      udp_over_tcp = true;
    };
  };
in
{
  sops.secrets = {
    "subgen/subscription-url" = { };
    "subgen/personal-port" = { };
  };

  sops.templates."sspassword".content = builtins.toJSON {
    iosmanthus = config.sops.placeholder."sing-box/shadowsocks/users/iosmanthus";
    lego = config.sops.placeholder."sing-box/shadowsocks/users/lego";
    lbwang = config.sops.placeholder."sing-box/shadowsocks/users/lbwang";
    tover = config.sops.placeholder."sing-box/shadowsocks/users/tover";
    alex = config.sops.placeholder."sing-box/shadowsocks/users/alex";
    mgw = config.sops.placeholder."sing-box/shadowsocks/users/mgw";
  };

  sops.templates."config.jsonnet".content = ''
    function(secrets)
    local sharedInputs = [
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
        name: 'personalPort',
        value: ${config.sops.placeholder."subgen/personal-port"},
      },
    ];
    local mkProfile = function(name, hashedPassword) {
      name: name,
      auth: {
        hashedPassword: hashedPassword,
      },
      inputs: sharedInputs + [
        {
          type: 'local',
          name: 'ssUserPassword',
          value: ${config.sops.templates."sspassword".content}[name],
        },
      ],
      expr: {
        type: 'local',
        path: 'default.jsonnet',
      },
    };
    {
      profiles: [
        mkProfile('iosmanthus', '$2y$10$W.rSv8wGsrNYMdHf5D41A.7LQQRLJeHWpHCZm8Pluqz8aZtd7bSi.'),
        mkProfile('lego', '$2y$10$zWUDy54ZvvSv0HByXV3vsO.KsHDZ3zUXdd0k8Lxi3SqWKItLX7VBm'),
        mkProfile('lbwang', '$2y$10$ApfNtxL44UZkeVLhCEKxfuzAYtEeO7naNHg9L/w4H3Ko.8aeAdUA.'),
        mkProfile('tover', '$2y$10$ZN029oB16UgAk3maJE6Opeyb7L83Gw8VMP9TvEs0lSWOPBhKoW9Ay'),
        mkProfile('alex', '$2y$10$j0tYQfI0KSvaMf7O.OW/DerDEeKyx3bRZgWyOSBISvV5HP3L/mZa.'),
        mkProfile('mgw', '$2y$10$uqmtmsaBwAHmKwpHEpvCgekZ.iSVTJkA9CkyjdKDZA3RfqGxs0Wqy'),
      ],
    }
  '';
}
