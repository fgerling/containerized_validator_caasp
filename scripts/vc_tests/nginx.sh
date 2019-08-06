step "Nginx: deploy & scale & expose"

kubectl create deployment nginx --image=nginx:stable-alpine
kubectl scale deployment nginx --replicas=$((2 * ${#IP_WORKERS[@]}))
kubectl expose deployment nginx --port=80 --type=NodePort
kubectl wait --for=condition=available deploy/nginx --timeout=3m >> "$LOGFILE"

nodeport=$(kubectl get svc/nginx -o json | jq '.spec.ports[0].nodePort')
curl "${IP_WORKERS[0]}:$nodeport" | grep -o "Welcome to nginx" | uniq
