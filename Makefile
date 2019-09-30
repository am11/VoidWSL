OUT_ZIP=Void.zip
LNCR_EXE=Void.exe

DLR=curl
DLR_FLAGS=-L
BASE_URL=http://alpha.de.repo.voidlinux.org/live/20190526/void-x86_64-ROOTFS-20190526.tar.xz
LNCR_ZIP_URL=https://github.com/yuk7/wsldl/releases/download/19022600/icons.zip
LNCR_ZIP_EXE=Void.exe

all: $(OUT_ZIP)

zip: $(OUT_ZIP)
$(OUT_ZIP): ziproot
	@echo -e '\e[1;31mBuilding $(OUT_ZIP)\e[m'
	cd ziproot; zip ../$(OUT_ZIP) *

ziproot: Launcher.exe rootfs.tar.gz
	@echo -e '\e[1;31mBuilding ziproot...\e[m'
	mkdir ziproot
	cp Launcher.exe ziproot/${LNCR_EXE}
	cp rootfs.tar.gz ziproot/

exe: Launcher.exe
Launcher.exe: icons.zip
	@echo -e '\e[1;31mExtracting Launcher.exe...\e[m'
	unzip icons.zip $(LNCR_ZIP_EXE)
	mv $(LNCR_ZIP_EXE) Launcher.exe

icons.zip:
	@echo -e '\e[1;31mDownloading icons.zip...\e[m'
	$(DLR) $(DLR_FLAGS) $(LNCR_ZIP_URL) -o icons.zip

rootfs.tar.gz: rootfs
	@echo -e '\e[1;31mBuilding rootfs.tar.gz...\e[m'
	cd rootfs; sudo tar -zcpf ../rootfs.tar.gz `sudo ls`
	sudo chown `id -un` rootfs.tar.gz

rootfs: base.tar.xz
	@echo -e '\e[1;31mBuilding rootfs...\e[m'
	mkdir rootfs
	sudo tar -xpf base.tar.xz -C rootfs
	sudo cp -f /etc/resolv.conf rootfs/etc/resolv.conf
	sudo chroot rootfs /sbin/xbps-install --sync --update --yes
	sudo rm -rf `sudo find rootfs/var/cache/xbps/ -type f`
	sudo rm rootfs/etc/resolv.conf
	sudo chmod +x rootfs

base.tar.xz:
	@echo -e '\e[1;31mDownloading base.tar.xz...\e[m'
	$(DLR) $(DLR_FLAGS) $(BASE_URL) -o base.tar.xz

clean:
	@echo -e '\e[1;31mCleaning files...\e[m'
	-rm ${OUT_ZIP}
	-rm -r ziproot
	-rm Launcher.exe
	-rm icons.zip
	-rm rootfs.tar.gz
	-sudo rm -r rootfs
	-rm base.tar.gz
