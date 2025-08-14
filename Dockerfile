ARG RELEASE=24.04

FROM docker.io/library/ubuntu:${RELEASE}

LABEL com.github.containers.toolbox="true" \
      com.github.debarshiray.toolbox="true" \
      name="ubuntu-toolbox" \
      version="${RELEASE}" \
      usage="This image is meant to be used with the toolbox command" \
      summary="Base image for creating Ubuntu toolbox containers" \
      maintainer="Angel Iglesias <ang.iglesiasg@gmail.com>"

COPY README.md /

# remove some container-optimized apt configuration;
# removing docker-gzip-indexes specifically helps with command-not-found
RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes /etc/apt/apt.conf.d/docker-no-languages

# Restore documentation but do not upgrade all packages, that's not appropriate;
# Install ubuntu-minimal & ubuntu-standard
# Install extra packages as well as libnss-myhostname
COPY extra-packages /
RUN sed -Ei '/apt-get (update|upgrade)/s/^/#/' /usr/local/sbin/unminimize && \
    apt-get update && \
    yes | /usr/local/sbin/unminimize && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
        ubuntu-minimal ubuntu-standard \
        libnss-myhostname \
        flatpak-xdg-utils && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
       --no-install-recommends \
       gnome-terminal && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
        $(cat extra-packages | xargs) && \
    rm -rd /var/lib/apt/lists/*
RUN rm /extra-packages
    #rm /extra-packages && \
    #rm -rf /usr/share/terminfo && \
    #ln -s /usr/lib/terminfo /usr/share/terminfo

# Allow authentication with empty password, promptless
RUN sed -i '/^auth.*pam_unix.so/s/nullok_secure/try_first_pass nullok/' /etc/pam.d/common-auth && \
    /bin/echo -e "Defaults\t!fqdn" > /etc/sudoers.d/fqdn

# Fix empty bind-mount to clear selinuxfs (see #337)
RUN mkdir /usr/share/empty

# Add flatpak-spawn to /usr/bin
RUN ln -s /usr/libexec/flatpak-xdg-utils/flatpak-spawn /usr/bin/

# Having anything in /home prevents toolbox from symlinking /var/home there,
# and 'ubuntu' user with UID 1000 will most likely conflict with host user as well
RUN userdel --remove ubuntu || true

# Disable APT ESM hook which tries to enable some systemd services on each apt invocation
RUN rm /etc/apt/apt.conf.d/20apt-esm-hook.conf

CMD /bin/bash
