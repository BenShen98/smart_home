FROM balenalib/raspberrypi3-node:8

RUN apt-get update && \
    apt-get install openssh-server git&& \
    apt-get clean

RUN mkdir /var/run/sshd && \
    install -d ~/.ssh -m 755 && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    ssh-keygen -A && \
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

# SSH login fix. Otherwise user is kicked off after login
# NOTE: Find not needed, but commented here in case required in the future
# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 22

CMD $(umask 077 && echo "$PUBKEY" > ~/.ssh/authorized_keys ) && \
    git config --global user.name "$GIT_NAME" && git config --global user.email "$GIT_EMAIL" &&\
    /usr/sbin/sshd -D
