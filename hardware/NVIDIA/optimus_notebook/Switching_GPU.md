## Switching graphics card (iGPU and dGPU), without any additional software. Functional on all GNU/Linux distributions.
We will try switching between integrated GPU and discrete.

## Verifications if the NVIDIA GPU really works.
We'll install a packages to help us find out. If you don't have vanilla Arch Linux, you can skip installing these packages, you probably already have them installed.

1. Use following command ```sudo pacman -S mesa-demos lib32-mesa-demos```
2. Use following command ```glxinfo | grep "OpenGL renderer"``` my terminal output looks like this.
```
[vilda@arch-dell ~]$ glxinfo | grep "OpenGL renderer"
OpenGL renderer string: Mesa Intel(R) Xe Graphics (TGL GT2)
```
3. This is a command that initializes the NVIDIA GPU via PRIME Render Offload.
```
__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia
```
4. Full command can looks like this. 
```
__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia glxinfo | grep "OpenGL renderer"
```
5. If the NVIDIA card showed up, everything works!
## Usage of NVIDIA GPU.
If you need to run anything with an NVIDIA GPU, just use the command below. Remember, after ```program``` just type any package.

```
__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia program
```
Example 1: Runs Xonotic game with NVIDIA GPU.
```
__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia xonotic-sdl
```
Example 2: Runs darktable - photo editor with NVIDIA GPU.
```
__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia darktable
```
### Steam
If you want to run games with the NVIDIA GPU on Steam.
```
__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
```
That's all, so you verifed NVIDIA GPU works and know how to use that.
<dd> Source: </dd>
https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/primerenderoffload.html
