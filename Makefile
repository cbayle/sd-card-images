
#PASSWORD_OVERRIDE:=$(shell pwgen -B -A 6 1)
PASSWORD_OVERRIDE:=root
DIST=bookworm
DIST=trixie

sd-card.img: boot-banana_pi_cm4io.bin.gz debian-$(DIST)-arm64-$(PASSWORD_OVERRIDE).bin.gz
	zcat boot-banana_pi_cm4io.bin.gz debian-$(DIST)-arm64-$(PASSWORD_OVERRIDE).bin.gz > $@

debian-$(DIST)-arm64-$(PASSWORD_OVERRIDE).bin.gz: /tmp/sd-images/debian-$(DIST)-arm64-$(PASSWORD_OVERRIDE).bin.gz
	cp /tmp/sd-images/$@ $@

/tmp/sd-images/debian-$(DIST)-arm64-$(PASSWORD_OVERRIDE).bin.gz: /tmp/sd-images
	docker run --rm -e PASSWORD_OVERRIDE='$(PASSWORD_OVERRIDE)' -v /tmp/sd-images:/artifacts sd-images build-debian debian arm64 $(DIST)

boot-banana_pi_cm4io.bin.gz: /tmp/sd-images/boot-banana_pi_cm4io.bin.gz
	cp /tmp/sd-images/$@ $@

/tmp/sd-images/boot-banana_pi_cm4io.bin.gz: /tmp/sd-images
	docker run --rm -v /tmp/sd-images:/artifacts sd-images build-boot banana_pi_cm4io meson-g12b bananapi-cm4-cm4io_defconfig aarch64-linux-gnu

/tmp/sd-images:
	[ -d $@ ] || mkdir $@

dockerbuild:
	docker build -t sd-images .

