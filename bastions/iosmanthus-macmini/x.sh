#!/usr/bin/env bash

case "$1" in
    "import")
        defaults import com.apple.symbolichotkeys ./shortcuts.xml
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u ;;
    "export")
        defaults export com.apple.symbolichotkeys - > ./shortcuts.xml ;;
    *)
        echo "unknown commands"
        exit 1 ;;
esac

