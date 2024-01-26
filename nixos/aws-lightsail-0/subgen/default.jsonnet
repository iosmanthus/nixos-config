function(
  finalNode,
  ssUserPassword,
  subscription,
  personalPort,
  staticHost,
  staticPort,
)
  local shadowtls = finalNode.shadowtls;
  local shadowsocks = finalNode.shadowsocks;
  local template = import './template.jsonnet';
  local relayNodes = std.filter(
    function(out) std.get(out, 'server_port') == 158,
    subscription.outbounds
  );
  local shadowtlsOutbounds = std.map(
    function(out) shadowtls {
      tag: out.tag + ' - outbound',
      server: out.server,
      server_port: personalPort,
    },
    relayNodes
  ) + [(shadowtls {
          tag: 'static - outbound',
          server: staticHost,
          server_port: staticPort,
        })];
  local shadowsocksOutbounds = std.map(function(out) shadowsocks {
    tag: out.tag,
    detour: out.tag + ' - outbound',
    password: shadowsocks.password + ':' + ssUserPassword,
  }, relayNodes) + [(shadowsocks {
                       tag: 'static',
                       detour: 'static - outbound',
                       password: shadowsocks.password + ':' + ssUserPassword,
                     })];
  local final = {
    tag: 'final',
    type: 'selector',
    outbounds: std.map(function(out) out.tag, shadowsocksOutbounds),
  };
  std.manifestJsonEx(template {
    outbounds: [final] + shadowsocksOutbounds + shadowtlsOutbounds + template.outbounds,
  }, indent='  ')
