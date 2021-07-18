# TODO List

- [ ] **WIP** Configure XMonad, make it more productive
    - [ ] a status bar
    - [ ] a two-pane layout
- [ ] **WIP** Refactor firewall construction
    - [x] Use `tun2socks` to replace `tproxy`
      - [x] Pull out the logic of `tun2socks` module to a generic module.
        ```nix
        services.tun2socks = {
            enable = true;
            gateway = "....";
            proxy = "...";
            fwmark = "...";
        }
        ```
    - [x] Create new `iptables` rules to enforce purity.
    - [x] Pack `clash-premium`
    - [ ] Use [arion](https://github.com/hercules-ci/arion) to describe the proxy cluster
- [ ] Move normal user's profile's package into system package scope
    - [ ] **WIP** Migrating to `home-manager`
- [ ] **WIP** use `sops-nix` to manage secret
    - [x] OpenVPN
    - [ ] SSH config private key, archiving that we only need to keep one SSH/GPG key privately maybe using Vault backended with AWS S3.
    - [ ] Maybe Clash 