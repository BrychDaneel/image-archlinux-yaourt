FROM archlinux/base
MAINTAINER Brychikov Daneel <brychdaneel@mail.ru>

RUN mkdir build_context
COPY cache_autoclean.hook makepkg_compress_format.awk build_context
RUN cd build_context &&\
    mv cache_autoclean.hook /etc/pacman.d/hooks/ &&\
    awk -f makepkg_compress_format.awk </etc/makepkg.conf >./makepkg.conf &&\
    mv ./makepkg.conf /etc/makepkg.conf &&\
    cd .. &&\
    rm -R build_context &&\
    echo "[multilib]"  >>/etc/pacman.conf &&\
    echo "Include = /etc/pacman.d/mirrorlist"  >>/etc/pacman.conf &&\
    pacman -Sy &&\
    pacman -S --needed --noconfirm base-devel git &&\
    echo "%wheel      ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers &&\
    useradd -m -g users -G lp,power,storage,wheel -s /bin/bash develop &&\
    echo -e "develop\ndevelop" | passwd develop
USER develop
WORKDIR /home/develop
RUN git clone --depth=1 https://aur.archlinux.org/package-query.git &&\
    cd package-query &&\
    yes | makepkg -s &&\
    sudo pacman -U --noconfirm *.pkg.tar &&\
    cd .. &&\
    rm -R package-query &&\
    git clone --depth=1 https://aur.archlinux.org/yaourt.git &&\
    cd yaourt &&\
    yes | makepkg -s &&\
    sudo pacman -U --noconfirm *.pkg.tar &&\
    cd .. &&\
    rm -R yaourt
