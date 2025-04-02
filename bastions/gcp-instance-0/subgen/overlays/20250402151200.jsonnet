function(o, version='1_10')
  o {
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
      ] + o.dns.rules[3:],
    },
  }
