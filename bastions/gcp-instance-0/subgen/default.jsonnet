local relaySubscription = std.extVar('relaySubscription');

local outboundTemplates = std.extVar('outboundTemplates');

local shadowsocksUser = std.extVar('shadowsocksUser');

local originGroup = std.extVar('originGroup');

local defaultDnsServer = std.extVar('defaultDnsServer');

local overlay = std.extVar('overlay');

local version = std.extVar('version');

local isRouter = std.extVar('router') == 'true';

local defaultTemplate = import './templates/1_10.jsonnet';

local templates = {
  '1_10': defaultTemplate,
  '1_11': import './templates/1_11.jsonnet',
};

local mkTemplate = std.get(templates, version, defaultTemplate);

local template = mkTemplate({
  defaultDnsServer: defaultDnsServer,
  isRouter: isRouter,
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

std.manifestJsonEx(overlay(template {
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
}), indent='  ')
