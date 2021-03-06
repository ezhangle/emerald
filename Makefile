KERNEL_HDD = build/disk.hdd
JOBS := $(shell nproc)
.PHONY: all clean
all:
	CC=clang meson setup kernel/ build/ && ninja -j$(JOBS) -C build/
disk: $(KERNEL_HDD)
run: $(KERNEL_HDD)
	@qemu-system-x86_64 -vga std -drive file=$(KERNEL_HDD),format=raw -enable-kvm -serial stdio -rtc base=localtime -m 256
debug: $(KERNEL_HDD)
	@qemu-system-x86_64 -d int -vga std -drive file=$(KERNEL_HDD),format=raw -serial stdio -rtc base=localtime -m 256

limine/limine-install:
	$(MAKE) -C thirdparty/limine limine-install

echfs/echfs-utils:
	$(MAKE) -C thirdparty/echfs echfs-utils
$(KERNEL_HDD): build/kernel.elf limine/limine-install echfs/echfs-utils
	@echo [ LIMINE ] build/kernel.elf
	@rm -f $(KERNEL_HDD)
	@dd if=/dev/zero bs=1M count=0 seek=64 of=$(KERNEL_HDD)
	@parted -s $(KERNEL_HDD) mklabel msdos
	@parted -s $(KERNEL_HDD) mkpart primary 1 100%
	@thirdparty/echfs/echfs-utils -m -p0 $(KERNEL_HDD) quick-format 32768
	@thirdparty/echfs/echfs-utils -m -p0 $(KERNEL_HDD) import build/kernel.elf build/kernel.elf
	@thirdparty/echfs/echfs-utils -m -p0 $(KERNEL_HDD) import limine.cfg limine.cfg
	@thirdparty/limine/limine-install limine/limine.bin $(KERNEL_HDD)

clean:
	ninja -C build/ clean
	@rm -f $(KERNEL_HDD) kernel.elf build/kernel.elf 
