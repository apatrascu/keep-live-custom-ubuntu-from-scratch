#!/bin/bash

. constants.sh
check_is_root

# Unbind mount points
umount $LIVECD_HOME_DIR/chroot/dev
umount $LIVECD_HOME_DIR/chroot/run

# Create the CD image directory and populate it
cd $LIVECD_HOME_DIR
mkdir -p image/{casper,isolinux,install}
cp chroot/boot/vmlinuz-**-**-generic image/casper/vmlinuz
cp chroot/boot/initrd.img-**-**-generic image/casper/initrd
cp chroot/boot/memtest86+.bin image/install/memtest86+

wget --progress=dot https://www.memtest86.com/downloads/memtest86-usb.zip -O image/install/memtest86-usb.zip
unzip -p image/install/memtest86-usb.zip memtest86-usb.img > image/install/memtest86
rm image/install/memtest86-usb.zip

# Grub configuration
cd $LIVECD_HOME_DIR
touch image/ubuntu
cat <<EOF > image/isolinux/grub.cfg

search --set=root --file /ubuntu

insmod all_video

set default="0"
set timeout=30

menuentry "Try UFS $TIMESTAMP without installing" {
   linux /casper/vmlinuz boot=casper quiet splash noapic ---
   initrd /casper/initrd
}

menuentry "Install UFS $TIMESTAMP" {
   linux /casper/vmlinuz boot=casper only-ubiquity quiet splash noapic ---
   initrd /casper/initrd
}

menuentry "Check disc for defects" {
   linux /casper/vmlinuz boot=casper integrity-check quiet splash noapic ---
   initrd /casper/initrd
}

menuentry "Test memory Memtest86+ (BIOS)" {
   linux16 /install/memtest86+
}

menuentry "Test memory Memtest86 (UEFI, long load time)" {
   insmod part_gpt
   insmod search_fs_uuid
   insmod chain
   loopback loop /install/memtest86
   chainloader (loop,gpt1)/efi/boot/BOOTX64.efi
}
EOF

# Create manifest
cd $LIVECD_HOME_DIR
chroot chroot dpkg-query -W --showformat='${Package} ${Version}\n' | tee image/casper/filesystem.manifest
cp -v image/casper/filesystem.manifest image/casper/filesystem.manifest-desktop
sed -i '/ubiquity/d' image/casper/filesystem.manifest-desktop
sed -i '/casper/d' image/casper/filesystem.manifest-desktop
sed -i '/discover/d' image/casper/filesystem.manifest-desktop
sed -i '/laptop-detect/d' image/casper/filesystem.manifest-desktop
sed -i '/os-prober/d' image/casper/filesystem.manifest-desktop

# Compress the chroot
cd $LIVECD_HOME_DIR
mksquashfs chroot image/casper/filesystem.squashfs
printf $(sudo du -sx --block-size=1 chroot | cut -f1) > image/casper/filesystem.size

# Create diskdefines
cd $LIVECD_HOME_DIR
cat <<EOF > image/README.diskdefines
#define DISKNAME  Ubuntu from scratch $TIMESTAMP
#define TYPE  binary
#define TYPEbinary  1
#define ARCH  amd64
#define ARCHamd64  1
#define DISKNUM  1
#define DISKNUM1  1
#define TOTALNUM  0
#define TOTALNUM0  1
EOF

# Create ISO Image for a LiveCD (BIOS + UEFI)
cd $LIVECD_HOME_DIR/image
grub-mkstandalone \
   --format=x86_64-efi \
   --output=isolinux/bootx64.efi \
   --locales="" \
   --fonts="" \
   "boot/grub/grub.cfg=isolinux/grub.cfg"
(
   cd isolinux && \
   dd if=/dev/zero of=efiboot.img bs=1M count=10 && \
   sudo mkfs.vfat efiboot.img && \
   mmd -i efiboot.img efi efi/boot && \
   mcopy -i efiboot.img ./bootx64.efi ::efi/boot/
)
grub-mkstandalone \
   --format=i386-pc \
   --output=isolinux/core.img \
   --install-modules="linux16 linux normal iso9660 biosdisk memdisk search tar ls" \
   --modules="linux16 linux normal iso9660 biosdisk search" \
   --locales="" \
   --fonts="" \
   "boot/grub/grub.cfg=isolinux/grub.cfg"
cat /usr/lib/grub/i386-pc/cdboot.img isolinux/core.img > isolinux/bios.img
/bin/bash -c "(find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" > md5sum.txt)"
xorriso \
   -as mkisofs \
   -iso-level 3 \
   -full-iso9660-filenames \
   -volid "UFS $TIMESTAMP" \
   -eltorito-boot boot/grub/bios.img \
   -no-emul-boot \
   -boot-load-size 4 \
   -boot-info-table \
   --eltorito-catalog boot/grub/boot.cat \
   --grub2-boot-info \
   --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
   -eltorito-alt-boot \
   -e EFI/efiboot.img \
   -no-emul-boot \
   -append_partition 2 0xef isolinux/efiboot.img \
   -output "../$ISO_NAME" \
   -graft-points \
      "." \
      /boot/grub/bios.img=isolinux/bios.img \
      /EFI/efiboot.img=isolinux/efiboot.img

# Done
echo ""
echo "Done. Use ../$LIVECD_DIR_NAME/$ISO_NAME"
