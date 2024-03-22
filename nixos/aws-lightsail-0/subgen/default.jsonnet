function(
  finalNode,
  ssUserPassword,
  subscription,
  personalPort,
  extraRelays,
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
  ) + std.map(
    function(out) shadowtls {
      tag: out.tag + ' - outbound',
      server: out.host,
      server_port: out.port,
    },
    extraRelays
  );
  local shadowsocksOutbounds = std.map(
    function(out) shadowsocks {
      tag: out.tag,
      detour: out.tag + ' - outbound',
      password: shadowsocks.password + ':' + ssUserPassword,
    },
    relayNodes
  ) + std.map(
    function(out) shadowsocks {
      tag: out.tag,
      detour: out.tag + ' - outbound',
      password: shadowsocks.password + ':' + ssUserPassword,
    },
    extraRelays
  );
  local final = {
    tag: 'final',
    type: 'selector',
    outbounds: std.map(function(out) out.tag, shadowsocksOutbounds),
  };
  local urltest = {
    tag: 'urltest',
    type: 'urltest',
    outbounds: final.outbounds,
  };
  std.manifestJsonEx(template {
    outbounds: [final, urltest] + shadowsocksOutbounds + shadowtlsOutbounds + template.outbounds,
  }, indent='  ')
