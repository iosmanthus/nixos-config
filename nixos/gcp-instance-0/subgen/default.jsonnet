function(
  relaySubscription,
  outboundTemplates,
  shadowsocksUser,
  originGroup,
  defaultDnsServer,
)
  local mkTemplate = import './template.jsonnet';

  local template = mkTemplate({
    defaultDnsServer: defaultDnsServer,
  });

  local relayList = std.parseJson(relaySubscription.data).relays;

  local relayNodes = std.sort(
    std.mapWithIndex(
      function(i, relay)
        local targetName = std.split(relay.target_host, '.')[0];
        {
          tag: targetName + '[' + std.toString(i) + ']',
          server: relay.source_host,
          server_port: relay.source_port,
        },
      relayList
    ),
    function(node) node.tag
  );

  local shadowsocksTemplate = outboundTemplates.shadowsocks;

  local shadowsocksRelayOutbounds = std.map(
    function(node) shadowsocksTemplate + shadowsocksUser + node,
    relayNodes
  );

  local shadowsocksRelayOutboundsTags = std.map(
    function(node) node.tag,
    shadowsocksRelayOutbounds
  );

  local shadowsocksOriginOutbounds = std.map(
    function(node) shadowsocksTemplate + shadowsocksUser + {
      tag: node.tag,
      detour: '~> ' + node.tag,
    },
    originGroup
  );

  local shadowtlsTemplate = outboundTemplates.shadowtls;

  local shadowtlsOriginOutbounds = std.map(
    function(node) shadowtlsTemplate + node + {
      tag: '~> ' + node.tag,
    },
    originGroup
  );

  local shadowsocksOriginOutboundsTags = std.map(
    function(node) node.tag,
    shadowsocksOriginOutbounds
  );

  local origin = {
    tag: 'origin',
    type: 'selector',
    outbounds: shadowsocksOriginOutboundsTags,
  };

  local relay = {
    tag: 'relay',
    type: 'selector',
    outbounds: shadowsocksRelayOutboundsTags,
  };

  local final = {
    tag: 'final',
    type: 'selector',
    outbounds: [origin.tag, relay.tag] + shadowsocksRelayOutboundsTags,
  };

  std.manifestJsonEx(template {
    experimental+: {
      clash_api+: {
        secret: std.sha3(std.sha3(shadowsocksUser.password)),
      },
    },
  } {
    outbounds: [final, origin, relay]
               + shadowsocksRelayOutbounds
               + shadowsocksOriginOutbounds
               + shadowtlsOriginOutbounds
               + template.outbounds,
  }, indent='  ')
