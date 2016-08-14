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

3. copy a ssh key with access to github over to the new host

```
$ scp ~/.ssh/id_rsa ss-controller-6123.ccg21.dev.paypalcorp.com:
```
and on the new host, copy the key to root's homedir:
```
ropeck@ss-controller-6123:~$ mv id_rsa /root/.ssh
```

4. install git and puppet 
```
$ sudo apt-get install -y git puppet
```

3. checkout this module as `/etc/puppet`
```
$ cd /etc/
$ sudo mv puppet puppet-orig
$ sudo git clone git@github.paypal.com:ropeck/sspuppet.git puppet
```

5. run puppet to install the packages and set up the controller
```
puppet apply /etc/puppet/manifests/site.pp
```

6. after complete, the randomly generated localadmin password is in `/tmp/swiftstack/localadmin-pw` or generate a new one with this command:
```
sg swiftstack "/deploy/ssman/current/ssman/manage.py user localadmin --traceback --generate-password" > /tmp/swiftstack/localadmin-pw
```

6. log into the new controller using a web browser by loading the vm's hostname.
```
http://ss-build-6189.ccg21.dev.paypalcorp.com
```
which will redirect to the ssl login page:
```
https://ss-build-6189.ccg21.dev.paypalcorp.com/accounts/login/
```

