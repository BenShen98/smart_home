#!/bin/bash
. "$( dirname ${BASH_SOURCE[0]} )/_setup.sh"


hostList="ha mos z2m"

read -rd '' remote_code<<EOF
    # function
    function getcrt {
        cn=\$1
        openssl req -nodes -newkey rsa:2048 -keyout \${cn}.key -out \${cn}.csr -subj "/CN=\${cn}"
        openssl x509 -req -in \${cn}.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out \${cn}.crt -days 360
        rm \${cn}.csr
    }

    # boiler plate
    dir=\$(mktemp -d)
    cd \$dir
    error=0

    # ca self sign
    openssl req -nodes -new -x509 -keyout ca.key -out ca.crt -subj "/CN=CA" -days 1826

    # host requries mqtt
    for config in $hostList; do

        # gen certificate
        getcrt \$config
        vol="\$(balena volume ls --format '{{ .Mountpoint }}/' --filter "name=\$(basename \$config)-config" --filter "dangling=false")"

        # move certificate
        if [ \$(echo \$vol | wc -l) -eq 1 ]; then
            cp ./{ca.crt,\${config}.crt,\${config}.key} \$vol
        else
            >&2 echo "WARNING: mutiple \$vol exist"
            error=\$((\$error+1))
        fi

    done

    # send certificate back if under debug mode
    if [ $_DEV -eq 1 ]; then
        getcrt $(hostname)
        tar -c ./ # tar file to stdout
    fi

    # clean up
    rm -rf \$dir

    if [ \$error -eq 0 ]; then
        >&2 echo "key generated without error"
    else
        >&2 echo "\$error error generated"
        exit \$error
    fi
EOF


if [ $_DEV -eq 1 ]; then
    echo "debug mode: export crt to 'crt.${_REMOTE}.$(date '+%H-%M-%S').tar'"
    echo "$remote_code" | ssh -p 22222 $_REMOTE "bash -s" > ${_DNDIR}/crt.${_REMOTE}.$(date '+%H-%M-%S').tar
else
    echo "$remote_code" | ssh -p 22222 $_REMOTE "bash -s"
fi

