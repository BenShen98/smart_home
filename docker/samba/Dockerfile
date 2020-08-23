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
    && while IFS="" read -r entry; do addsamuser ${entry}; done < /run/secrets/nas_users \
# ADD BOT (echo bot has its own group, but its home folder has SAM_USERGROUP group)
    && while IFS="" read -r entry; do addsambot ${entry}; done < /run/secrets/nas_bots

EXPOSE 445/tcp

ENTRYPOINT ["smbd", "--foreground", "--log-stdout", "--no-process-group"]
CMD []
