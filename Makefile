TAR=bsdtar

# WARNING: the 20191109 snapshot is broken and fails to update:
#
# sudo chroot rootfs /sbin/xbps-install --sync --update --yes xbps
# [*] Updating `https://alpha.de.repo.voidlinux.org/current/x86_64-repodata' ...
# x86_64-repodata: 1947KB [avg rate: 5979KB/s]
# libcrypto45-3.0.2_2 (update) breaks installed pkg `libressl-2.9.2_1'
# libcrypto45-3.0.2_2 (update) breaks installed pkg `libtls19-2.9.2_1'
# libssl47-3.0.2_2 (update) breaks installed pkg `libressl-2.9.2_1'
# libssl47-3.0.2_2 (update) breaks installed pkg `libtls19-2.9.2_1'
# Transaction aborted due to unresolved dependencies.
# make: *** [Makefile:31: rootfs] Error 19

BASE_URL=http://alpha.de.repo.voidlinux.org/live/20190526/void-x86_64-ROOTFS-20190526.tar.xz
LNCR_ZIP_URL=https://github.com/yuk7/wsldl/releases/download/19022600/icons.zip

all: Void.zip

zip: Void.zip

Void.zip: Void.exe rootfs.tar.gz
	@echo -e '\e[1;31mBuilding Void.zip\e[m'
	$(TAR) -caf Void.zip Void.exe rootfs.tar.gz

Void.exe: icons.zip
	@echo -e '\e[1;31mExtracting Void.exe...\e[m'
	$(TAR) -xf icons.zip Void.exe

icons.zip:
	@echo -e '\e[1;31mDownloading icons.zip...\e[m'
	curl -LSfs -o icons.zip $(LNCR_ZIP_URL)

rootfs.tar.gz: rootfs
	@echo -e '\e[1;31mBuilding rootfs.tar.gz...\e[m'
	sudo $(TAR) -czpf - > rootfs.tar.gz -C rootfs .

rootfs: base.tar.xz
	@echo -e '\e[1;31mBuilding rootfs...\e[m'
	mkdir rootfs
	sudo $(TAR) -xpmf base.tar.xz -C rootfs
	sudo cp -f /etc/resolv.conf rootfs/etc/resolv.conf
	sudo chroot rootfs /sbin/xbps-install --sync --update --yes xbps
	sudo chroot rootfs /sbin/xbps-install --update --yes
	sudo find rootfs/var/cache/xbps/ -type f -delete
	sudo rm rootfs/etc/resolv.conf
	sudo chmod +x rootfs

base.tar.xz:
	@echo -e '\e[1;31mDownloading base.tar.xz...\e[m'
	curl -LSfs -o base.tar.xz $(BASE_URL)

clean:
	@echo -e '\e[1;31mCleaning files...\e[m'
	rm -f Void.zip
	rm -f Void.exe
	rm -f icons.zip
	rm -f rootfs.tar.gz
	sudo rm -fr rootfs
	rm -f base.tar.xz
