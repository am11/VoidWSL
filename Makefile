VOID_REVISION=20230628
VOID_BASE_URL=https://repo-default.voidlinux.org/live/$(VOID_REVISION)
LNCR_ZIP_BASE_URL=https://github.com/yuk7/wsldl/releases/download/23072600

.PHONY: all clean

all: all-x86_64 all-aarch64

all-x86_64: icons.zip void-x86_64 void-x86_64-musl
all-aarch64: icons_arm64.zip void-aarch64 void-aarch64-musl

void-x86_64 void-x86_64-musl void-aarch64 void-aarch64-musl:
	@echo -e '\e[1;31mDownloading $(VOID_BASE_URL)/$@-ROOTFS-$(VOID_REVISION).tar.xz...\e[m'
	curl -LO $(VOID_BASE_URL)/$@-ROOTFS-$(VOID_REVISION).tar.xz

	@echo -e '\e[1;31mPreparing $@.zip...\e[m'
	@mkdir $@-zip
	@cp Void.exe $@-zip/$@.exe

	@echo -e '\e[1;31mPreparing $@.tar.gz...\e[m'
	@mkdir $@
	tar -xpf $@-ROOTFS-$(VOID_REVISION).tar.xz -C $@
	cp -f /etc/resolv.conf $@/etc/resolv.conf
	chroot $@ /sbin/xbps-install --sync --update --yes
	rm -rf `find $@/var/cache/xbps/ -type f`
	rm $@/etc/resolv.conf
	chmod +x $@

	@echo -e '\e[1;31mPacking rootfs.tar.gz...\e[m'
	@cd $@; tar -zcpf ../$@-zip/rootfs.tar.gz `ls`
	chown `id -un` $@-zip/rootfs.tar.gz

	@echo -e '\e[1;31mPacking $@.zip\e[m'
	@cd $@-zip; zip ../$@.zip *

icons.zip icons_arm64.zip:
	@echo -e '\e[1;31mDownloading $(LNCR_ZIP_BASE_URL)/$@...\e[m'
	curl -LO $(LNCR_ZIP_BASE_URL)/$@
	@echo -e '\e[1;31mExtracting $@...\e[m'
	yes | unzip $@ Void.exe

clean:
	@echo -e '\e[1;31mCleaning files...\e[m'
	rm -rf void-* Void.exe icons*.zip
