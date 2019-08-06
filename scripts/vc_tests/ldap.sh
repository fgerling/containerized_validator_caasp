step "Helm & Ldap"

info 'Setup LDAP'
# Helm v2
kubectl --namespace kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --wait | tee -a "$LOGFILE" | grep 'Happy Helming'
helm install --name ldap --set adminPassword=admin --set env.LDAP_DOMAIN=example.com stable/openldap >> "$LOGFILE"

# Helm v3
#helm install ldap stable/openldap --set adminPassword=admin --set env.LDAP_DOMAIN=example.com >> "$LOGFILE"

kubectl wait --for=condition=available deploy/ldap-openldap --timeout=3m >> "$LOGFILE"
ldap_pod=$(kubectl get pods -l=app=openldap --no-headers | cut -d' ' -f1)
kubectl exec -i $ldap_pod -- ldapadd -x -D "cn=admin,dc=example,dc=com" -w admin >> "$LOGFILE" << EOF
dn: uid=curie,dc=example,dc=com
uid: curie
objectClass: inetOrgPerson
objectClass: person
cn: Marie Curie
sn: Curie
mail: curie@email.com
userPassword: password
EOF
kubectl create rolebinding curie-role --clusterrole=admin --user=curie@email.com --namespace=default >> "$LOGFILE"

info 'Setup DEX'
sed -i '/connectors:/,/^$/ {
	s/openldap.kube-system.svc/ldap-openldap.default.svc/
	s/cn=Users,//
	s/cn=Groups,//
}' addons/dex/dex.yaml
#kubectl apply -f addons/dex/dex.yaml >> "$LOGFILE"
#dex_pod=$(kubectl get pods -n kube-system -l=app=oidc-dex --no-headers | cut -d' ' -f1)
#kubectl delete pod -n kube-system $dex_pod
kubectl replace --force -f addons/dex/dex.yaml >> "$LOGFILE"
kubectl wait --for=condition=available deploy/ldap-openldap --timeout=3m >> "$LOGFILE"

# Wait for dns reload (lookup ldap-openldap.default.svc.cluster.local: no such host)
sleep 120

info 'Get kubeconfig and check access'
if pip -q --disable-pip-version-check show selenium && which chromedriver google-chrome-stable > /dev/null; then
	$BASEDIR/vc_tests/get_curie_config.py $IP_LB
	test -f kubeconf.txt
	KUBECONFIG=kubeconf.txt kubectl get deploy/ldap-openldap >> "$LOGFILE"
	KUBECONFIG=kubeconf.txt kubectl get deploy/oidc-gangway -n kube-system 2>> "$LOGFILE" && { error 'Leave devil'; exit 1; }
else
	warn "Selenium not set up, skipping user kubeconfig test"
	# sudo pip install selenium
	# sudo zypper in https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
	# chrome_driver_ver=$(curl -s http://chromedriver.chromium.org/ | tr -s '\302\240' ' ' | grep -oP 'Latest stable.*?ChromeDriver [0-9.]+' | awk '{print $(NF)}')
	# wget "https://chromedriver.storage.googleapis.com/$chrome_driver_ver/chromedriver_linux64.zip"
	# unzip chromedriver_linux64.zip -d ~/bin && rm chromedriver_linux64.zip
fi

# # import from ldap.forumsys.com #1
# ldap_pod=$(kubectl get pods -l=app=openldap --no-headers | cut -d' ' -f1)
# ldapsearch -x -H ldap://ldap.forumsys.com:389 -b dc=example,dc=com -LLL | kubectl exec -i $ldap_pod -- ldapadd -cx -H ldap://localhost:389 -D "cn=admin,dc=example,dc=com" -w admin

# helm install --name ldap --set adminPassword=admin,customLdifFiles=forumsys.ldif stable/openldap
# ldapsearch -x -H ldap://ldap.forumsys.com:389 -b dc=example,dc=com -LLL "(|(objectclass=groupOfUniqueNames)(objectclass=inetOrgPerson))" > forumsys.ldif

: