function(
  finalNode,
  ssUserPassword,
  subscription,
  personalPort
)
  local shadowtls = finalNode.shadowtls;
  local shadowsocks = finalNode.shadowsocks;
  local template = import './template.jsonnet';
  local relayNodes = std.filter(
    function(out) std.get(out, 'server_port') == 8443,
    subscription.outbounds
  );
  local shadowtlsOutbounds = std.map(
    function(out) {
      tag: out.tag + ' - outbound',
      server: out.server,
      server_port: personalPort,
    } + shadowtls,
    relayNodes
  );
  local shadowsocksOutbounds = std.map(function(out) shadowsocks {
    tag: out.tag,
    detour: out.tag + ' - outbound',
    password: shadowsocks.password + ':' + ssUserPassword,
  }, relayNodes);
  local final = {
    tag: 'final',
    type: 'selector',
    outbounds: std.map(function(out) out.tag, shadowsocksOutbounds),
  };
  std.manifestJsonEx(template {
    outbounds: [final] + shadowsocksOutbounds + shadowtlsOutbounds + template.outbounds,
  }, indent='  ')
