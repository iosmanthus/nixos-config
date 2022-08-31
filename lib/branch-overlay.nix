{ branch, packages, ... }:
(branch.lib.foldl
  (overlay: package: (overlay // { ${package} = branch.${package}; }))
{ }
  packages)
