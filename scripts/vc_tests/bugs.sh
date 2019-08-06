step "Check for existing bugs"

# Containers registry
[ "$SKUBA_BUILD" = "release" ] && domain="com" || domain="de"
ssh "${IP_MASTERS[0]}" sudo crictl images | grep -Ev "^IMAGE|^registry.suse.$domain" | column -t && warn "Foreign containers: ^^^"

# Warn about BETA flag
skuba version 2>&1 | grep "BETA" > /dev/null && warn "This is a BETA release"

# Swap is turned off
[ -z "$(ssh ${IP_MASTERS[0]} sudo swapon --noheadings --show)" ]

: