FROM base/archlinux
RUN echo "[multilib]"  >>/etc/pacman.conf &&\
    echo "Include = /etc/pacman.d/mirrorlist"  >>/etc/pacman.conf &&\
    pacman -Syu &&\
    pacman -S --noconfirm base-devel git &&\
    echo "%wheel      ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers &&\
    useradd -m -g users -G lp,power,storage,wheel -s /bin/bash develop &&\
    echo -e "develop\ndevelop" | passwd develop
USER develop
WORKDIR /home/develop
RUN git clone https://aur.archlinux.org/package-query.git &&\
    cd package-query &&\
    yes | makepkg -s &&\
    sudo pacman -U --noconfirm *.pkg.tar.xz &&\
    cd .. &&\
    rm -R package-query &&\
    git clone https://aur.archlinux.org/yaourt.git &&\
    cd yaourt &&\
    yes | makepkg -s &&\
    sudo pacman -U --noconfirm *.pkg.tar.xz &&\
    cd .. &&\
    rm -R yaourt
