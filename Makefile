DLR=curl
DLR_FLAGS=-L

VOID_REVISION=20221001
BASE_URL=https://repo-default.voidlinux.org/live/$(VOID_REVISION)
VOID_GLIBC_ROOTFS=void-x86_64-ROOTFS-$(VOID_REVISION).tar.xz
VOID_MUSL_ROOTFS=void-x86_64-musl-ROOTFS-$(VOID_REVISION).tar.xz
VOID_GLIBC_URL=$(BASE_URL)/$(VOID_GLIBC_ROOTFS)
VOID_MUSL_URL=$(BASE_URL)/$(VOID_MUSL_ROOTFS)

LNCR_ZIP_URL=https://github.com/yuk7/wsldl/releases/download/22020900/icons.zip
LNCR_ZIP_EXE=Void.exe

define prepare-rootfs =
@echo -e '\e[1;31mPreparing $@...\e[m'
mkdir $@
sudo tar -xpf $< -C $@
sudo cp -f /etc/resolv.conf $@/etc/resolv.conf
sudo chroot $@ /sbin/xbps-install --sync --update --yes
sudo rm -rf `sudo find $@/var/cache/xbps/ -type f`
sudo rm $@/etc/resolv.conf
sudo chmod +x $@
endef

define pack-rootfs-tarball =
@echo -e '\e[1;31mPacking $@...\e[m'
cd $<; sudo tar -zcpf ../$@ `sudo ls`
sudo chown `id -un` $@
endef

define prepare-ziproot =
@echo -e '\e[1;31mPreparing $@...\e[m'
mkdir $@
cp $(word 2,$^) $@/
cp $< $@/rootfs.tar.gz
endef

define pack-zip =
@echo -e '\e[1;31mPacking $@\e[m'
cd $<; zip ../$@ *
endef

all: zip

.PHONY: all zip exe clean
zip: VoidGlibc.zip VoidMusl.zip

VoidGlibc.zip: ziproot-glibc
	$(pack-zip)

VoidMusl.zip: ziproot-musl
	$(pack-zip)

ziproot-glibc: rootfs-glibc.tar.gz void-glibc.exe
	$(prepare-ziproot)

ziproot-musl: rootfs-musl.tar.gz void-musl.exe
	$(prepare-ziproot)

rootfs-glibc.tar.gz: rootfs-glibc
	$(pack-rootfs-tarball)

rootfs-musl.tar.gz: rootfs-musl
	$(pack-rootfs-tarball)

rootfs-glibc: base-glibc.tar.xz
	$(prepare-rootfs)

rootfs-musl: base-musl.tar.xz
	$(prepare-rootfs)

base-glibc.tar.xz:
	@echo -e '\e[1;31mDownloading $@...\e[m'
	$(DLR) $(DLR_FLAGS) $(VOID_GLIBC_URL) -o $@

base-musl.tar.xz:
	@echo -e '\e[1;31mDownloading $@...\e[m'
	$(DLR) $(DLR_FLAGS) $(VOID_MUSL_URL) -o $@

exe: void-glibc.exe void-musl.exe
$(LNCR_ZIP_EXE): icons.zip
	@echo -e '\e[1;31mExtracting $@...\e[m'
	unzip $< $@

void-glibc.exe: $(LNCR_ZIP_EXE)
	@cp $(LNCR_ZIP_EXE) $@

void-musl.exe: $(LNCR_ZIP_EXE)
	@cp $(LNCR_ZIP_EXE) $@

icons.zip:
	@echo -e '\e[1;31mDownloading $@...\e[m'
	$(DLR) $(DLR_FLAGS) $(LNCR_ZIP_URL) -o $@

clean:
	@echo -e '\e[1;31mCleaning files...\e[m'
	-rm VoidGlibc.zip VoidMusl.zip
	-rm -r ziproot-glibc ziproot-musl
	-rm rootfs-glibc.tar.gz rootfs-musl.tar.gz
	-sudo rm -r rootfs-glibc rootfs-musl
	-rm base-glibc.tar.xz base-musl.tar.xz
	-rm void-glibc.exe void-musl.exe
	-rm $(LNCR_ZIP_EXE)
	-rm icons.zip
