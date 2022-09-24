#!/bin/bash

#Intel drivers packages
pacman -S --needed intel-ucode vulkan-intel intel-compute-runtime intel-gmmlib intel-gpu-tools intel-graphics-compiler intel-media-driver intel-media-sdk libmfx libva-utils lib32-vulkan-intel glu libva-mesa-driver mesa mesa-demos mesa-utils mesa-vdpau vulkan-mesa-layers lib32-glu lib32-libva-mesa-driver lib32-mesa lib32-mesa-demos lib32-mesa-utils lib32-mesa-vdpau lib32-vulkan-mesa-layers vulkan-icd-loader vulkan-extra-layers vulkan-extra-tools vulkan-headers

#Adding modules i915 a intel_agp
grep -i -q "MODULES=" /etc/mkinitcpio.conf
if [ "$?" -eq 0 ]; then
    sed -i 's/MODULES=()/MODULES=(i915 intel_agp)/g' /etc/mkinitcpio.conf
else
    sed -i 's/MODULES=""/MODULES="i915 intel_agp"/g' /etc/mkinitcpio.conf
fi

#Enable GuC / HuC firmware loading
echo "options i915 enable_guc=2" > /etc/modprobe.d/i915.conf
#Enable framebuffer compression
echo "options i915 enable_fbc=1" >> /etc/modprobe.d/i915.conf
#Intel fastboot
echo "options i915 fastboot=1" >> /etc/modprobe.d/i915.conf

#Mesa enable performance support
echo "dev.i915.perf_stream_paranoid=0" > /etc/sysctl.d/99-i915.conf

#To load all configuration files manually
sysctl --system

#(re-)generate the preset provided by a kernel package
mkinitcpio -P
