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
        server: 'local',
      },
      {
        clash_mode: 'Global',
        server: 'secure',
      },
      {
        rule_set: 'cn-site',
        server: 'local',
      },
      {
        outbound: 'any',
        server: 'local',
      },
      {
        domain_keyword: [
          'pingcap',
          'tidb',
          'clinic',
        ],
        server: 'secure',
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
        address: 'tls://1.1.1.1',
        detour: 'final',
        tag: 'secure',
      },
      {
        address: '119.29.29.29',
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
        tag: 'cn-site',
        format: 'binary',
        url: 'https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geosite/geosite-cn.srs',
        download_detour: 'urltest',
      },
      {
        type: 'remote',
        tag: 'cn-ip',
        format: 'binary',
        url: 'https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geoip/geoip-cn.srs',
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
        rule_set: 'cn-site',
        outbound: 'direct',
      },
      {
        domain_suffix: [
          'pingcap.net',
        ],
        outbound: 'direct',
      },
      {
        ip_is_private: true,
        outbound: 'direct',
      },
      {
        rule_set: 'cn-ip',
        outbound: 'direct',
      },
    ],
  },
  experimental: {
    cache_file: {
      enabled: true,
      cache_id: '3109dc66-e71d-40d0-9e55-1b60244d0a90',
    },
    clash_api: {
      external_controller: '127.0.0.1:7990',
      external_ui: './ui',
      external_ui_download_detour: 'final',
    },
  },
  inbounds: [
    {
      auto_route: true,
      inet4_address: '172.19.0.1/30',
      inet6_address: 'fdfe:dcba:9876::1/126',
      interface_name: 'utun3',
      sniff: true,
      sniff_override_destination: true,
      stack: 'mixed',
      strict_route: true,
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
  ],
}
