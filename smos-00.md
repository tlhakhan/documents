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
```

### Adding pkgsrc to GZ

```bash
# tools version
BOOTSTRAP_TAR="bootstrap-2017Q1-tools.tar.gz"
curl -kO https://pkgsrc.joyent.com/packages/SmartOS/bootstrap/${BOOTSTRAP_TAR}

# install bootstrap kit to /opt/tools
tar -zxpf ${BOOTSTRAP_TAR} -C /

# add to PATH/MANPATH.
export PATH=/opt/tools/sbin:/opt/tools/bin:$PATH
export MANPATH=/opt/tools/man:$MANPATH
```
