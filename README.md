# sspuppet
masterless puppet to build swiftstack controller

running with puppet apply will make a swiftstack controller
    puppet apply /etc/puppet/manifests/site.pp


after complete, the randomly generated localadmin password is in `/tmp/swiftstack/localadmin-pw`

or generate a new one with this command:
    sg swiftstack "/deploy/ssman/current/ssman/manage.py user localadmin --traceback --generate-password" > /tmp/swiftstack/localadmin-pw



