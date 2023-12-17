{
  dns: {
    independent_cache: true,
    rules: [
      {
        geosite: [
          'cn',
        ],
        server: 'dnspod',
      },
      {
        outbound: 'any',
        server: 'dnspod',
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
        tag: 'dnspod',
      },
      {
        tag: 'remote',
        address: 'fakeip',
      },
    ],
    fakeip: {
      enabled: true,
      inet4_range: '198.18.0.0/15',
      inet6_range: 'fc00::/18',
    },
    strategy: 'prefer_ipv6',
  },
  experimental: {
    clash_api: {
      cache_file: 'cache.db',
      external_controller: '127.0.0.1:7990',
      external_ui: './ui',
      external_ui_download_detour: 'final',
      store_selected: true,
    },
  },
  inbounds: [
    {
      auto_route: true,
      inet4_address: '172.19.0.1/30',
      inet6_address: 'fdfe:dcba:9876::1/126',
      interface_name: 'utun3',
      sniff: true,
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
  log: {
    level: 'debug',
    timestamp: true,
  },
  route: {
    auto_detect_interface: true,
    final: 'final',
    geoip: {
      download_detour: 'final',
      download_url: 'https://github.com/iosmanthus/sing-box-geo/releases/latest/download/geoip.db',
    },
    geosite: {
      download_detour: 'final',
      download_url: 'https://github.com/iosmanthus/sing-box-geo/releases/latest/download/geosite.db',
    },
    rules: [
      {
        outbound: 'dns-out',
        protocol: 'dns',
      },
      {
        geosite: [
          'cn',
        ],
        outbound: 'direct',
      },
      {
        geoip: [
          'cn',
          'private',
        ],
        outbound: 'direct',
      },
      {
        domain_keyword: [
          'ddrk',
          'ddys',
        ],
        outbound: 'final',
      },
    ],
  },
}
