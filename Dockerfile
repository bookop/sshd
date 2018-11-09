FROM alpine:3.8
LABEL MAINTAINER="openlock"

RUN echo "http://mirrors.aliyun.com/alpine/v3.8/main" > /etc/apk/repositories \
    && echo "http://mirrors.aliyun.com/alpine/v3.8/community" >> /etc/apk/repositories \
    && apk update	\
    &&apk add --no-cache openssh xauth \
    && echo "root:root" | chpasswd \
    && rm -rf /var/cache/apk/* /tmp/*

# -----------------------------------------------------------------------------
# Configure SSH 
# -----------------------------------------------------------------------------

RUN  sed -i \
           -e 's/#AllowTcpForwarding.*/AllowTcpForwarding\ yes/' \
           -e 's/#X11Forwarding.*/X11Forwarding\ yes/' \
           -e 's/#X11UseLocalhost.*/X11UseLocalhost\ no/' \
           -e 's/#PermitRootLogin.*/PermitRootLogin\ yes/' \
           /etc/ssh/sshd_config


#COPY entrypoint.sh /entrypoint.sh
#RUN chmod a+x /entrypoint.sh


RUN ssh-keygen -A

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
#ENTRYPOINT ["/entrypoint.sh"]
