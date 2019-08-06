step "Cilium: L3/L4 policy test" # http://docs.cilium.io/en/v1.5/gettingstarted/http/

curlreq='curl -sm10 -XPOST deathstar.default.svc.cluster.local/v1/request-landing'

info "Deploy deathstar"
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.5/examples/minikube/http-sw-app.yaml >> "$LOGFILE"
kubectl wait --for=condition=ready pods --all --timeout=3m >> "$LOGFILE"
kubectl exec tiefighter -- $curlreq | grep -q 'Ship landed'
kubectl exec xwing -- $curlreq | grep -q 'Ship landed'

info "Check with L3/L4 policy"
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.5/examples/minikube/sw_l3_l4_policy.yaml >> "$LOGFILE"
kubectl exec tiefighter -- $curlreq | grep -q 'Ship landed'
( kubectl exec xwing -- $curlreq 2>&1 || :) | grep 'terminated with exit code 28' >> "$LOGFILE"

info "Check status (N/N)"
node_count=$(kubectl get --no-headers nodes | wc -l)
cilium_podid=$(kubectl get pods -n kube-system -l k8s-app=cilium | cut -d' ' -f1 | tail -1)
cilium_status="-n kube-system exec $cilium_podid -- cilium status"
kubectl $cilium_status | tee -a $LOGFILE | grep -E "^Controller Status:\s+([0-9]+)/\1 healthy" > /dev/null || error "Controller unhealthy"
for i in {1..10}; do
    kubectl $cilium_status | grep -E "^Cluster health:\s+($node_count)/\1 reachable" >> "$LOGFILE" && break
    [ $i -ne 10 ] && sleep 30 || error "Nodes unreachable bsc#??????"
done

: