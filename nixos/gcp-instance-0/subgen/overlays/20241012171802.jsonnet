function(o)
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
      rules: o.route.rules[:3] + [
        {
          rule_set: 'geosite-apple',
          outbound: 'direct',
        },
      ] + o.route.rules[3:],
    },
    dns+: {
      rules: o.dns.rules[:3] + [
        {
          rule_set: 'geosite-apple',
          server: 'local',
        },
      ] + o.dns.rules[3:],
    },
  }
