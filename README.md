# sspuppet
masterless puppet to build swiftstack controller

## Building a controller

1. Edit the /etc/apt/sources.list to have a standard ubuntu14 repo list:
```
###### Ubuntu Main Repos
deb http://01.archive.ubuntu.com/ubuntu/ trusty main universe

###### Ubuntu Update Repos
deb http://01.archive.ubuntu.com/ubuntu/ trusty-security main universe
#deb http://01.archive.ubuntu.com/ubuntu/ trusty-updates main universe
```

2. run `apt-get update` to index the repo listing.

3. checkout this module as `/etc/puppet`

4. install puppet with `apt-get install puppet`

5. run puppet to install the packages and set up the controller
```
puppet apply /etc/puppet/manifests/site.pp
```

after complete, the randomly generated localadmin password is in `/tmp/swiftstack/localadmin-pw`

or generate a new one with this command:
```
sg swiftstack "/deploy/ssman/current/ssman/manage.py user localadmin --traceback --generate-password" > /tmp/swiftstack/localadmin-pw
```


