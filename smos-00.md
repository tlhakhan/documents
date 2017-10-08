## Configuring home smos-00 server

### Adding authorized keys file

```bash

# make a folder called config.inc
mkdir -p /usbkey/config.inc

# create creates keys file
cat << 'eof' > /usbkey/config.inc/authorized_keys
keys_here
'eof'

# tell config where to root's auth keys
echo "root_authorized_keys_file=authorized_keys" >>/usbkey/config

# this will create a file in / called .dcinfo, which will have a key=val 
# ex. datacenter_name=home
# this also changes prompt so that it looks like:  [root@smos-00 (home) ~]
echo "datacenter_name='dc_name'" >> /usbkey/config
```

### Adding pkgsrc to GZ

```bash
# tools version
BOOTSTRAP_TAR="bootstrap-2017Q1-tools.tar.gz"
curl -kO https://pkgsrc.joyent.com/packages/SmartOS/bootstrap/${BOOTSTRAP_TAR}

# install bootstrap kit to /opt/tools
tar -zxpf ${BOOTSTRAP_TAR} -C /

# add to PATH/MANPATH.
# make these part of ~/.profile or ~/.bash_profile
## todo:  make them persist after reboot
export PATH=/opt/tools/sbin:/opt/tools/bin:$PATH
export MANPATH=/opt/tools/man:$MANPATH
```

### Mounting userfiles post-boot
- Add the service manifest to `/opt/custom/smf`, SmartOS post-boot will automatically pick up the service manifests and import them and enable/disable them.
- Add service manifest scripts to `/opt/custom/smf/share`.  Useful place for binaries and shell scripts used by the smf file.
- Below example sourced from:  https://wiki.smartos.org/display/DOC/Allowing+user+CRUD+in+the+global+zone
```xml
<?xml version='1.0'?>
<!DOCTYPE service_bundle SYSTEM '/usr/share/lib/xml/dtd/service_bundle.dtd.1'>
<service_bundle type='manifest' name='export'>
  <service name='site/mount_usbkey_userfiles' type='service' version='0'>
    <create_default_instance enabled='true'/>
    <single_instance/>
    <dependency name='filesystem' grouping='require_all' restart_on='error' type='service'>
      <service_fmri value='svc:/system/filesystem/local'/>
    </dependency>
    <method_context/>
    <exec_method name='start' type='method' exec='/opt/custom/smf/share/mount_usbkey_userfiles start' timeout_seconds='60'/>
    <exec_method name='stop' type='method' exec='/opt/custom/smf/share/mount_usbkey_userfiles stop' timeout_seconds='60'/>
    <property_group name='startd' type='framework'>
      <propval name='duration' type='astring' value='transient'/>
      <propval name='ignore_error' type='astring' value='core,signal'/>
    </property_group>
    <property_group name='application' type='application'/>
    <stability value='Evolving'/>
    <template>
      <common_name>
        <loctext xml:lang='C'>Mount /etc/passwd, /etc/shadow, and /etc/group from /usbkey</loctext>
      </common_name>
    </template>
  </service>
</service_bundle>
```

```bash
#!/usr/bin/bash

case "$1" in
'start')
  if [[ -n $(/bin/bootparams | grep '^smartos=true') ]]; then
    if [[ -z $(/usr/sbin/mount -p | grep '/etc/passwd') ]]; then 
      if [[ /etc/passwd -ot /usbkey/passwd ]]; then
        cp /usbkey/passwd /etc/passwd
      else
        cp /etc/passwd /usbkey/passwd 
      fi
      touch /etc/passwd /usbkey/passwd
      mount -F lofs /usbkey/passwd /etc/passwd
    fi
    if [[ -z $(/usr/sbin/mount -p | grep '/etc/group') ]]; then 
      if [[ /etc/group -ot /usbkey/group ]]; then
        cp /usbkey/group /etc/group
      else
        cp /etc/group /usbkey/group 
      fi
      touch /etc/group /usbkey/group
      mount -F lofs /usbkey/group /etc/group
    fi
    if [[ -z $(/usr/sbin/mount -p | grep '/etc/shadow') ]]; then 
      if [[ /etc/shadow -ot /usbkey/shadow ]]; then
        cp /usbkey/shadow /etc/shadow
      else
        cp /etc/shadow /usbkey/shadow 
      fi
      touch /etc/shadow /usbkey/shadow
      mount -F lofs /usbkey/shadow /etc/shadow
    fi
  fi
  ;;
'stop')
  if [[ -n $(/usr/sbin/mount -p | grep 'group') ]]; then umount /etc/group; touch /etc/group; fi
  if [[ -n $(/usr/sbin/mount -p | grep 'passwd') ]]; then umount /etc/passwd; touch /etc/passwd; fi
  if [[ -n $(/usr/sbin/mount -p | grep 'shadow') ]]; then umount /etc/shadow; touch /etc/shadow; fi
  ;;
*)
  echo "Usage: $0 { start | stop }"
  exit 1
  ;;
esac
```
