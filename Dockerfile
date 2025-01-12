FROM docker.io/library/alpine:3.21

# Install OpenSSH server and Gitolite
# Unlock the automatically-created git user
RUN set -x \
 && apk add --no-cache gitolite openssh \
 && passwd -u git

COPY gitconfig /etc/gitconfig
COPY sshd_config /etc/ssh/sshd_config

# Volume used to store SSH host keys, generated on first run
VOLUME /etc/ssh/keys

# Volume used to store all Gitolite data (keys, config and repositories), initialized on first run
VOLUME /var/lib/git

# Entrypoint responsible for SSH host keys generation, and Gitolite data initialization
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

# Expose port 2222 to access SSH
EXPOSE 2222

# Default command is to run the SSH server
CMD ["sshd"]

