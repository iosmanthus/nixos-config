{ writeShellScriptBin
, glib
}:
writeShellScriptBin "xdg-open" ''
  set -xeuo pipefail
  targetFile=$1
  # Some programs run xdg-open with no stderr available so || true is needed
  >&2 echo "xdg-open workaround: using org.freedesktop.portal to open $targetFile" || true
  if [ -e "$targetFile" ]; then
    exec {targetFileReadFd}< "$targetFile"
    ${glib}/bin/gdbus call --session \
      --dest org.freedesktop.portal.Desktop \
      --object-path /org/freedesktop/portal/desktop \
      --method org.freedesktop.portal.OpenURI.OpenFile \
      --timeout 5 \
      "" "$targetFileReadFd" {}
      exec {targetFileReadFd}>&- || true
  else
    if ! echo "$targetFile" | grep -q '://'; then
      targetFile="https://$targetFile"
    fi
    ${glib}/bin/gdbus call --session \
      --dest org.freedesktop.portal.Desktop \
      --object-path /org/freedesktop/portal/desktop \
      --method org.freedesktop.portal.OpenURI.OpenURI \
      --timeout 5 \
      "" "$targetFile" {}
  fi
''
