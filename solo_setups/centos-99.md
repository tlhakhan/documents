## configuring home box centos-99

description: using box as general centos playground

### general packages installed so far
```bash

# general
yum install -y epel-release
yum install -y blktrace
yum install -y golang
yum install -y nodejs
yum install -y git
yum install -y tmux vim-enhanced iftop dstat
yum install -y zsh zsh-lovers

# console fonts
yum install -y terminus-fonts terminus-fonts-console

# ifconfig, iostat, mpstat, netstat, etc..
yum install -y net-tools
yum install -y sysstat

# for i3
yum install -y libstoragemgmt-megaraid-plugin
yum install -y xorg-x11-server-Xorg
yum install -y xorg-x11-xinit
yum install -y xorg-x11-drv-intel.x86_64
yum install -y i3.x86_64 i3-doc
```

### getting console fonts to be big
- Install packages `terminus-fonts terminus-fonts-console`
- Edit the file `/etc/vconsole.conf`

```
KEYMAP="us"
FONT="ter-v32n"
```

