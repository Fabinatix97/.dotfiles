FROM archlinux:latest

RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm sudo git vim

RUN useradd -ms /bin/bash dev \
    && usermod -aG wheel dev \
    && echo "dev ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/dev \
    && chmod 440 /etc/sudoers.d/dev

USER dev
WORKDIR /home/dev

RUN git clone https://github.com/Fabinatix97/.dotfiles.git \
    && cd .dotfiles \
    && git switch arch

ENV USER=dev

CMD ["/bin/bash"]
