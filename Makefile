OUT_ZIP=Void.zip

BASE_URL=http://alpha.de.repo.voidlinux.org/live/20190526/void-x86_64-ROOTFS-20190526.tar.xz
LNCR_ZIP_URL=https://github.com/yuk7/wsldl/releases/download/19022600/icons.zip

all: $(OUT_ZIP)

zip: $(OUT_ZIP)

$(OUT_ZIP): Void.exe rootfs.tar.gz
	@echo -e '\e[1;31mBuilding $(OUT_ZIP)\e[m'
	zip $(OUT_ZIP) Void.exe rootfs.tar.gz

Void.exe: icons.zip
	@echo -e '\e[1;31mExtracting Void.exe...\e[m'
	unzip icons.zip Void.exe

icons.zip:
	@echo -e '\e[1;31mDownloading icons.zip...\e[m'
	curl -LSfs $(LNCR_ZIP_URL) -o icons.zip

rootfs.tar.gz: rootfs
	@echo -e '\e[1;31mBuilding rootfs.tar.gz...\e[m'
	sudo tar -zcp > rootfs.tar.gz -C rootfs .

rootfs: base.tar.xz
	@echo -e '\e[1;31mBuilding rootfs...\e[m'
	mkdir rootfs
	sudo tar -xpf base.tar.xz -C rootfs
	sudo cp -f /etc/resolv.conf rootfs/etc/resolv.conf
	sudo chroot rootfs /sbin/xbps-install --sync --update --yes
	sudo find rootfs/var/cache/xbps/ -type f -delete
	sudo rm rootfs/etc/resolv.conf
	sudo chmod +x rootfs

base.tar.xz:
	@echo -e '\e[1;31mDownloading base.tar.xz...\e[m'
	curl -LSfs $(BASE_URL) -o base.tar.xz

clean:
	@echo -e '\e[1;31mCleaning files...\e[m'
	rm -f ${OUT_ZIP}
	rm -f Void.exe
	rm -f icons.zip
	rm -f rootfs.tar.gz
	sudo rm -fr rootfs
	rm -f base.tar.xz
