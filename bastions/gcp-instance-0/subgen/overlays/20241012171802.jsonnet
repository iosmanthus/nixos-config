function(o, version='1_10')
  local idx = if version > '1_10' then 4 else 3;
  o {
    route+: {
      rule_set+: [
        {
          type: 'remote',
          tag: 'geosite-apple',
          format: 'binary',
          url: 'https://raw.githubusercontent.com/lyc8503/sing-box-rules/rule-set-geosite/geosite-apple.srs',
          download_detour: 'origin',
        },
      ],
      rules: o.route.rules[:idx] + [
        {
          rule_set: 'geosite-apple',
          outbound: 'direct',
        },
      ] + o.route.rules[idx:],
    },
    dns+: {
      rules: o.dns.rules[:3] + [
        {
          domain_keyword: [
            'aws',
            'pingcap',
            'tidb',
            'clinic',
          ],
          server: 'secure',
        },
        {
          rule_set: 'geosite-apple',
          server: 'local',
        },
      ] + o.dns.rules[3:],
    },
  }
