FROM archlinux:latest

RUN yes | pacman -Syu && yes | pacman -Sy sudo
RUN useradd -m -G wheel -s /bin/bash -m app && passwd -d app
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers
WORKDIR /home/app
USER app
RUN rm .bash*
