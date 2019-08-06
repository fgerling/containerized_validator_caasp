step 'Check supportconfig'

info 'Generate supportconfig'
ssh "${IP_MASTERS[0]}" sudo supportconfig -b -B supportconfig -ipsuse_caasp >> "$LOGFILE"
ssh "${IP_MASTERS[0]}" sudo chmod +r /var/log/nts_supportconfig.txz
scp "${IP_MASTERS[0]}:/var/log/nts_supportconfig.txz" "$LOGPATH"

info 'Check for files'
files=$(tar -tvf "$LOGPATH/nts_supportconfig.txz")

size=$(echo "$files" | grep crio.txt | awk '{print $3}')
test $size -gt 1000

size=$(echo "$files" | grep kubernetes.txt | awk '{print $3}')
test $size -gt 1000
