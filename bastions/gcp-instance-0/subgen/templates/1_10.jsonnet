function(inputs) {
  log: {
    level: 'debug',
    timestamp: true,
  },
  dns: {
    fakeip: {
      enabled: true,
      inet4_range: '198.18.0.0/15',
      inet6_range: 'fc00::/18',
    },
    independent_cache: true,
    rules: [
      {
        outbound: 'any',
        server: 'local',
      },
      {
        clash_mode: 'Direct',
        server: 'local',
      },
      {
        clash_mode: 'Global',
        server: 'secure',
      },
      {
        query_type: [
          'A',
          'AAAA',
        ],
        rule_set: 'geosite-geolocation-!cn',
        server: 'remote',
      },
      {
        rule_set: 'geosite-china-list',
        server: 'local',
      },
      {
        rule_set: 'geosite-chinadns',
        server: 'local',
      },
      {
        rule_set: [
          'geoip-cn',
          'geoip-private',
        ],
        server: 'secure',
        client_subnet: '121.46.17.1/24',
      },
      {
        query_type: [
          'A',
          'AAAA',
        ],
        server: 'remote',
      },
    ],
    servers: [
      {
        address: inputs.defaultDnsServer,
        address_resolver: 'local',
        detour: 'final',
        tag: 'secure',
      },
      {
        address: '114.114.114.114',
        detour: 'direct',
        tag: 'local',
      },
      {
        address: 'fakeip',
        tag: 'remote',
      },
    ],
  },
  route: {
    auto_detect_interface: true,
    final: 'final',
    rule_set: [
      {
        type: 'remote',
        tag: 'geosite-china-list',
        format: 'binary',
        url: 'https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geosite/geosite-china-list.srs',
        download_detour: 'origin',
      },
      {
        type: 'remote',
        tag: 'geosite-geolocation-!cn',
        format: 'binary',
        url: 'https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geosite/geosite-geolocation-!cn.srs',
        download_detour: 'origin',
      },
      {
        type: 'remote',
        tag: 'geoip-cn',
        format: 'binary',
        url: 'https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geoip/geoip-cn.srs',
        download_detour: 'origin',
      },
      {
        type: 'remote',
        tag: 'geoip-private',
        format: 'binary',
        url: 'https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geoip/geoip-private.srs',
        download_detour: 'origin',
      },
      {
        type: 'remote',
        tag: 'geosite-category-ads-all',
        format: 'binary',
        url: 'https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geosite/geosite-category-ads-all.srs',
        download_detour: 'origin',
      },
      {
        type: 'remote',
        tag: 'geosite-chinadns',
        format: 'binary',
        url: 'https://chinadns.iosmanthus.com/binary',
        update_interval: '30m',
        download_detour: 'origin',
      },
    ],
    rules: [
      {
        outbound: 'dns-out',
        protocol: 'dns',
      },
      {
        clash_mode: 'Direct',
        outbound: 'direct',
      },
      {
        clash_mode: 'Global',
        outbound: 'final',
      },
      {
        rule_set: 'geosite-category-ads-all',
        outbound: 'block',
      },
      {
        protocol: 'bittorrent',
        outbound: 'direct',
      },
      {
        rule_set: 'geoip-cn',
        outbound: 'direct',
      },
      {
        rule_set: 'geoip-private',
        outbound: 'direct',
      },
      {
        protocol: 'quic',
        outbound: 'block',
      },
    ],
  },
  experimental: {
    cache_file: {
      enabled: true,
      cache_id: '3109dc66-e71d-40d0-9e55-1b60244d0a90',
      store_fakeip: true,
      store_rdrc: true,
    },
    clash_api: {
      external_controller: '0.0.0.0:7990',
      external_ui_download_detour: 'origin',
      external_ui: './ui',
    },
  },
  inbounds: [
    {
      auto_route: true,
      strict_route: inputs.isRouter,
      auto_redirect: inputs.isRouter,
      inet4_address: '172.19.0.1/30',
      interface_name: 'utun7',
      sniff: true,
      stack: 'mixed',
      tag: 'tun-in',
      type: 'tun',
    },
  ],
  outbounds: [
    {
      tag: 'dns-out',
      type: 'dns',
    },
    {
      tag: 'direct',
      type: 'direct',
    },
    {
      tag: 'block',
      type: 'block',
    },
  ],
}
