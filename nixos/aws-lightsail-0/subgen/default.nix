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
  iosmanthus.subgen = {
    enable = true;
    configFile = config.sops.templates."config.jsonnet".path;
    exprPath = ./.;
  };

  systemd.services.subgen.restartTriggers = [
    config.sops.templates."config.jsonnet".content
  ];

  sops.templates."sspasswords".content = builtins.toJSON {
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
      {
        type: 'local',
        name: 'staticHost',
        value: '${config.sops.placeholder."aws-lightsail-0-ip"}'
      },
      {
        type: 'local',
        name: 'staticPort',
        value: 10080,
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
          value: ${config.sops.templates."sspasswords".content}[name],
        },
      ],
      expr: {
        type: 'local',
        path: 'default.jsonnet',
      },
    };
    {
      profiles: [
        mkProfile('iosmanthus', '$2y$12$I7BENGQd5h2UdSZ.2dI5tusnrz6pk2hmfsEPQOet9CVnUDeCPZReO'),
        mkProfile('lego', '$2y$12$g7xzL7VwtSGSKxKXlIBcReXRj2Y4kW4h.ui.Z5Hh6E9efzGsB/bZi'),
        mkProfile('lbwang', '$2y$12$ChjDDIC7qqyAwIOSa/mDBuGOjEfU3/COhUPbHgx/cv.76QEKjShEG'),
        mkProfile('tover', '$2y$12$d23vJw8MI17H/jQIoqrSfu8YXQvKWMhp3SAub1cOBy.zpc5nP.K0W'),
        mkProfile('alex', '$2y$12$qFMBz7CphHf4wQumwChBieQUYYkOHehgNbgWRJe8pMkjpvj2B/0TG'),
        mkProfile('mgw', '$2y$12$GyJGCjJd/ugnml9UzsVcc.DjItPfmK.37xG3ivZkERk1hGOT9JNua'),
      ],
    }
  '';
}
