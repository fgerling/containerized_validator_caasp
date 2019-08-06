step "Run sonobuoy"

sono_run="sonobuoy run -p e2e --wait"
if [ -f ~/.ssh/id_shared ]; then
    info "Use .ssh/id_shared"
    sono_run+=" --ssh-key=$HOME/.ssh/id_shared --ssh-user=sles"
else
    warn 'Sonobuoy could run more tests with ~/.ssh/id_shared'
fi

$sono_run &>> "$LOGFILE" & spinner "Run sonobuoy testsuite"
results=$(sonobuoy retrieve)
sonobuoy e2e $results | tee -a "$LOGFILE" | grep 'failed tests: 0'
