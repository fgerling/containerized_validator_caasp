step "Reboot all nodes"

# Reboot nodes
for IP in "${IP_MASTERS[@]}" "${IP_WORKERS[@]}"; do
  ssh "$IP" sudo reboot 2>> "$LOGFILE" &
done
sleep 10

# Wait until they come back
curl --retry 10 --retry-delay 30 --retry-connrefused ${IP_MASTERS[0]}:6443
kubectl wait --for=condition=ready pods --all --timeout=5m >> "$LOGFILE"

# Check services are runnning
curl "${IP_MASTERS[0]}:$nodeport" | grep -om1 "Welcome to nginx"
kubectl exec tiefighter -- $curlreq | grep 'Ship landed'
( kubectl exec xwing -- $curlreq 2>&1 || :) | grep 'terminated with exit code 28'

: