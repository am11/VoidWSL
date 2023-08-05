void_revision := '20221001'
void_base_url := 'https://repo-default.voidlinux.org/live' / void_revision
void_glibc_rootfs := 'void-x86_64-ROOTFS-' + void_revision + '.tar.xz'
void_musl_rootfs := 'void-x86_64-musl-ROOTFS-' + void_revision + '.tar.xz'
void_glibc_url := void_base_url / void_glibc_rootfs
void_musl_url := void_base_url / void_musl_rootfs

wsldl_revision := '22020900'
wsldl_url := 'https://github.com/yuk7/wsldl/releases/download' / wsldl_revision / 'wsldl.exe'

default: zip

zip: _pack_zip_glibc _pack_zip_musl

_fetch url output:
    @echo '\033[1;31mDownloading {{ output }}...\033[m'
    curl -L {{ url }} -o {{ output }}

_prepare_launcher libc: (_fetch wsldl_url 'wsldl.exe')
    cp wsldl.exe 'void-{{ libc }}.exe'

_prepare_base_glibc: (_fetch void_glibc_url 'base-glibc.tar.xz')
_prepare_base_musl: (_fetch void_musl_url 'base-musl.tar.xz')

_prepare_rootfs libc:
    @echo '\033[1;31mPreparing rootfs-{{ libc }}.tar.gz...\033[m'
    mkdir 'rootfs-{{ libc }}'
    sudo tar -xpf 'base-{{ libc }}.tar.xz' -C 'rootfs-{{ libc }}'
    sudo cp -f /etc/resolv.conf 'rootfs-{{ libc }}/etc/resolv.conf'
    sudo chroot 'rootfs-{{ libc }}' /sbin/xbps-install --sync --update --yes
    sudo rm -rf $(sudo find rootfs-{{ libc }}/var/cache/xbps/ -type f)
    sudo rm 'rootfs-{{ libc }}/etc/resolv.conf'
    sudo chmod +x rootfs-{{ libc }}
    cd rootfs-{{ libc }}; sudo tar -zcpf '../rootfs-{{ libc }}.tar.gz' $(sudo ls)
    sudo chown $(id -un) 'rootfs-{{ libc }}.tar.gz'

_prepare_rootfs_glibc: _prepare_base_glibc (_prepare_rootfs 'glibc')
_prepare_rootfs_musl: _prepare_base_musl (_prepare_rootfs 'musl')

_prepare_ziproot libc:
    @echo '\033[1;31mPreparing ziproot-{{ libc }}...\033[m'
    mkdir 'ziproot-{{ libc }}'
    cp rootfs-{{ libc }}.tar.gz 'ziproot-{{ libc }}/rootfs.tar.gz'
    cp 'void-{{ libc }}.exe' 'ziproot-{{ libc }}/'

_prepare_ziproot_glibc: _prepare_rootfs_glibc (_prepare_launcher 'glibc') (_prepare_ziproot 'glibc')
_prepare_ziproot_musl: _prepare_rootfs_musl (_prepare_launcher 'musl') (_prepare_ziproot 'musl')

_pack_zip libc output:
    @echo '\033[1;31mPacking {{ output }}...\033[m'
    cd 'ziproot-{{ libc }}'; zip ../{{ output }} *

_pack_zip_glibc: _prepare_ziproot_glibc (_pack_zip 'glibc' 'VoidGlibc.zip')
_pack_zip_musl: _prepare_ziproot_musl (_pack_zip 'musl' 'VoidMusl.zip')
