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

## Watching The Build
While the puppet run goes it will write logs to `/var/log` and `/tmp/swiftstack/install-output`.

## Errors in build
Somehow this error with beanstalkd happens sometimes.

```
/tmp/install-2016-08-14-17:19:47.log

 ** [out :: localhost] Reading state information...
 ** [out :: localhost] The following NEW packages will be installed:
 ** [out :: localhost] ss-beanstalkd
 ** [out :: localhost] 0 upgraded, 1 newly installed, 0 to remove and 121 not upgraded.
 ** [out :: localhost] Need to get 0 B/29.4 kB of archives.
 ** [out :: localhost] After this operation, 153 kB of additional disk space will be used.
 ** [out :: localhost] Selecting previously unselected package ss-beanstalkd.
 ** [out :: localhost] (Reading database ... 190579 files and directories currently installed.)
 ** [out :: localhost] Preparing to unpack .../ss-beanstalkd_1.9-3~trusty_amd64.deb ...
 ** [out :: localhost] Unpacking ss-beanstalkd (1.9-3~trusty) ...
 ** [out :: localhost] Processing triggers for ureadahead (0.100.0-16) ...
 ** [out :: localhost] Setting up ss-beanstalkd (1.9-3~trusty) ...
 ** [out :: localhost] * Starting in-memory queueing server  ss-beanstalkd
 ** [out :: localhost] ...fail!
 ** [out :: localhost] Processing triggers for ureadahead (0.100.0-16) ...
 ** [out :: localhost] STDERR: invoke-rc.d: initscript ss-beanstalkd, action "start" failed.
 ** [out :: localhost] dpkg: error processing package ss-beanstalkd (--configure):
 ** [out :: localhost] subprocess installed post-installation script returned error exit status 1
 ** [out :: localhost] Errors were encountered while processing:
 ** [out :: localhost] ss-beanstalkd
 ** [out :: localhost] E: Sub-process /usr/bin/dpkg returned an error code (1)
 ** [out :: localhost] ---- End output of apt-get -q -y -o 'DPkg::options::=--force-confold' install ss-beanstalkd=1.9-3~trusty ----
 ** [out :: localhost] Ran apt-get -q -y -o 'DPkg::options::=--force-confold' install ss-beanstalkd=1.9-3~trusty returned 100
 ** [out :: localhost] /home/swiftstack/deploy-gems/ruby/1.9.1/gems/mixlib-shellout-1.6.1/lib/mixlib/shellout.rb:272:in `invalid!'
```

The workaround for now is to re-run the `puppet apply` command.  It seems to complete the second time without issues.


