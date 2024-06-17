{
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
        clash_mode: 'Direct',
        server: 'local-secure',
      },
      {
        clash_mode: 'Global',
        server: 'secure',
      },
      {
        outbound: 'any',
        server: 'local-secure',
      },
      {
        rule_set: 'geosite-cn',
        server: 'local-secure',
      },
      {
        type: 'logical',
        mode: 'and',
        rules: [
          {
            rule_set: 'geosite-geolocation-!cn',
            invert: true,
          },
          {
            rule_set: [
              'geoip-cn',
              'geoip-private',
            ],
          },
        ],
        server: 'secure',
        client_subnet: '121.46.17.159/24',
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
        address: 'https://1.1.1.1/dns-query',
        detour: 'final',
        tag: 'secure',
      },
      {
        address: '119.29.29.29',
        detour: 'direct',
        tag: 'local',
      },
      {
        address: 'https://doh.pub/dns-query',
        address_resolver: 'local',
        detour: 'direct',
        tag: 'local-secure',
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
        tag: 'geosite-cn',
        format: 'binary',
        url: 'https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geosite/geosite-cn.srs',
        download_detour: 'urltest',
      },
      {
        type: 'remote',
        tag: 'geosite-geolocation-!cn',
        format: 'binary',
        url: 'https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geosite/geosite-geolocation-!cn.srs',
        download_detour: 'urltest',
      },
      {
        type: 'remote',
        tag: 'geoip-cn',
        format: 'binary',
        url: 'https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geoip/geoip-cn.srs',
        download_detour: 'urltest',
      },
      {
        type: 'remote',
        tag: 'geoip-private',
        format: 'binary',
        url: 'https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geoip/geoip-private.srs',
        download_detour: 'urltest',
      },
      {
        type: 'remote',
        tag: 'geosite-category-ads-all',
        format: 'binary',
        url: 'https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geosite/geosite-category-ads-all.srs',
        download_detour: 'urltest',
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
        rule_set: 'geosite-cn',
        outbound: 'direct',
      },
    ],
  },
  experimental: {
    cache_file: {
      enabled: true,
      cache_id: '3109dc66-e71d-40d0-9e55-1b60244d0a90',
      store_fakeip: true,
    },
    clash_api: {
      external_controller: '0.0.0.0:7990',
      external_ui_download_detour: 'urltest',
      external_ui: './ui',
    },
  },
  inbounds: [
    {
      auto_route: true,
      inet4_address: '172.19.0.1/30',
      // inet6_address: 'fdfe:dcba:9876::1/126',
      interface_name: 'utun@130dfab',
      sniff: true,
      // sniff_override_destination: true,
      stack: 'mixed',
      strict_route: false,
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
