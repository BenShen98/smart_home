FROM benshen98/apline:3.9.5_armv6
# FROM alpine

# sam user creation, remember to add them to RUN below
ARG SAM_USERGROUP="samuser"
ARG SAM_MUSC="music"

RUN apk add --update samba-common-tools samba-client samba-server && \
    rm -rf /var/cache/apk/*

RUN addgroup $SAM_USERGROUP \
# MKDIR for folders
    && mkdir -p /data/homes && install -d -m 775 -g $SAM_USERGROUP /data/share \
# functions for add users (bot)
    && addsambot(){  adduser -D -s /bin/false "$1" && echo -e "$2\n$2" | smbpasswd -a -s "$1" && install -d -m 775 -o "$1" -g $SAM_USERGROUP "/data/$1"; } \
    && addsamuser(){ adduser -D -s /bin/false "$1" -h "/data/homes/$1" -G $SAM_USERGROUP && echo -e "$2\n$2" | smbpasswd -a -s "$1"; } \
# ADD USERS
    && addsamuser "ben" "2233" \
    && addsamuser "fiona" "1122" \
# ADD BOT (echo bot has its own group, but its home folder has SAM_USERGROUP group)
    && addsambot $SAM_MUSC "xx" \
# WRITING SMB.CONF CONFIG FILE
# https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html
    && echo $'\
    [global] \n\
        dns proxy = No \n\
        log file = /usr/local/samba/var/log.%m \n\
        max log size = 50 \n\
        server role = standalone server \n\
        server string = PI \n\
        workgroup = MYGROUP \n\
        idmap config * : backend = tdb \n\
        # force group = +'$SAM_USERGROUP$' # + is used for saftey \n\
        # hosts allow = 192.168.0. EXCEPT 192.168.0.1 \n\
        # hosts deny = all \n\
\n\
    [homes] \n\
        browseable = No \n\
        comment = Home Directories \n\
        writeable = Yes \n\
        path = /data/homes/%S \n\
        valid users = @'$SAM_USERGROUP$' \n\
\n\
    [share] \n\
        browseable = Yes \n\
        comment = Shared file space \n\
        writeable = Yes \n\
        path = /data/share \n\
        valid users = @'$SAM_USERGROUP$' \n\
\n\
    ['$SAM_MUSC$'] \n\
        browseable = Yes \n\
        comment = Music playlist\n\
        writeable = Yes \n\
        path = /data/'$SAM_MUSC$'/ \n\
        valid users = @'$SAM_USERGROUP$', '$SAM_MUSC$' \n\
    ' > /etc/samba/smb.conf

EXPOSE 445/tcp

ENTRYPOINT ["smbd", "--foreground", "--log-stdout", "--no-process-group"]
CMD []

# ENTRYPOINT []
# CMD ifconfig && smbd --foreground --log-stdout --no-process-group ; echo $? ; top > /dev/null
# smbd --foreground --log-stdout --no-process-group&
