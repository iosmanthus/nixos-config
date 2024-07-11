function(
  relaySubscription,
  outboundTemplates,
  vlessUser,
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

  local vlessTemplate = outboundTemplates.vless;

  local vlessRelayOutbounds = std.map(
    function(node) vlessTemplate + vlessUser + node,
    relayNodes
  );

  local vlessRelayOutboundsTags = std.map(
    function(node) node.tag,
    vlessRelayOutbounds
  );

  local vlessOriginOutbounds = std.map(
    function(node) vlessTemplate + vlessUser + node,
    originGroup
  );

  local vlessOriginOutboundsTags = std.map(
    function(node) node.tag,
    vlessOriginOutbounds
  );

  local origin = {
    tag: 'origin',
    type: 'selector',
    outbounds: vlessOriginOutboundsTags,
  };

  local urltest = {
    tag: 'urltest',
    type: 'urltest',
    interval: '1m',
    outbounds: vlessRelayOutboundsTags,
  };

  local final = {
    tag: 'final',
    type: 'selector',
    outbounds: [urltest.tag, origin.tag] + vlessRelayOutboundsTags,
  };

  std.manifestJsonEx(template {
    experimental+: {
      clash_api+: {
        secret: std.sha3(std.sha3(vlessUser.uuid)),
      },
    },
  } {
    outbounds: [final, urltest, origin]
               + vlessRelayOutbounds
               + vlessOriginOutbounds
               + template.outbounds,
  }, indent='  ')
