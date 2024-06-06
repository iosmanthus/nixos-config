function(
  finalNode,
  ssUserPassword,
  subscription,
  originGroup,
)
  local shadowtls = finalNode.shadowtls;

  local shadowsocks = finalNode.shadowsocks;

  local template = import './template.jsonnet';

  local sub = std.parseJson(subscription.data);

  local relayNodes = std.mapWithIndex(
    function(i, relay)
      local targetName = std.split(relay.target_host, '.')[0];
      {
        tag: targetName + '[' + std.toString(i) + ']',
        server: relay.source_host,
        server_port: relay.source_port,
      },
    sub.relays
  );

  local shadowtlsOutbounds = std.map(
    function(out) shadowtls {
      tag: out.tag + ' - outbound',
      server: out.server,
      server_port: out.server_port,
    },
    relayNodes
  ) + std.map(
    function(out) shadowtls {
      tag: out.tag + ' - outbound',
      server: out.host,
      server_port: out.port,
    },
    originGroup
  );

  local relaySsOutbounds = std.map(
    function(out) shadowsocks {
      tag: out.tag,
      detour: out.tag + ' - outbound',
      password: shadowsocks.password + ':' + ssUserPassword,
    },
    relayNodes
  );
  local originSsOutbounds = std.map(
    function(out) shadowsocks {
      tag: out.tag,
      detour: out.tag + ' - outbound',
      password: shadowsocks.password + ':' + ssUserPassword,
    },
    originGroup
  );

  local relaySsOutboundsTags = std.map(function(out) out.tag, relaySsOutbounds);
  local originSsOutboundsTags = std.map(function(out) out.tag, originSsOutbounds);

  local urltest = {
    tag: 'urltest',
    type: 'urltest',
    outbounds: relaySsOutboundsTags,
    interval: '10s',
  };

  local origin = {
    tag: 'origin',
    type: 'selector',
    outbounds: originSsOutboundsTags,
  };

  local final = {
    tag: 'final',
    type: 'selector',
    outbounds: [urltest.tag, origin.tag] + relaySsOutboundsTags,
  };

  std.manifestJsonEx(template {
    experimental+: {
      clash_api+: {
        secret: std.sha3(std.sha3(ssUserPassword)),
      },
    },
  } {
    outbounds: [final, urltest, origin] + relaySsOutbounds + originSsOutbounds + shadowtlsOutbounds + template.outbounds,
  }, indent='  ')
