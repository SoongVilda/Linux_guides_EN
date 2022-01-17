#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Prosím, spusť script se sudo"
  exit 1
fi

#Installation NVIDIA drivers
pacman -S --needed nvidia-dkms nvidia-settings nvidia-utils lib32-nvidia-utils vulkan-icd-loader lib32-vulkan-icd-loader libvdpau lib32-libvdpau libxnvctrl opencl-nvidia lib32-opencl-nvidia cuda lib32-libvdpau

#Hardware accelerated video encoding with NVENC
echo 'ACTION=="add", DEVPATH=="/bus/pci/drivers/nvidia", RUN+="/usr/bin/nvidia-modprobe -c0 -u"' > /etc/udev/rules.d/70-nvidia.rules

#PCI-Express Runtime D3 (RTD3) Power Management
echo '# Remove NVIDIA USB xHCI Host Controller devices, if present
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{remove}="1"

# Remove NVIDIA USB Type-C UCSI devices, if present
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{remove}="1"

# Remove NVIDIA Audio devices, if present
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{remove}="1"

# Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"

# Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="on"
ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="on"' > /etc/udev/rules.d/80-nvidia-pm.rules

#Dynamic power management
echo 'options nvidia "NVreg_DynamicPowerManagement=0x02"' > /etc/modprobe.d/nvidia-pm.conf

#Enable the nvidia-persistenced service to not make the kernel tear down the device state whenever the NVIDIA device resources are no longer in use.
systemctl enable nvidia-persistenced
systemctl start nvidia-persistenced

#Rebuild initramfs
mkinitcpio -P

#Loading new rules
udevadm control --reload
udevadm trigger
