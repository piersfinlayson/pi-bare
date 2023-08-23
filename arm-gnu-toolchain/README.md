# ARM GNU Toolchain

Find these [here](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads).

For bare metal you typically want either the x86_64 to arm-none-eabi (32-bit ARM) or aarch64-none-elf (64-bit ARM).

While a limited number of older releases are shown lower down this page, you can often find even older ones by googling "ARM GNU toolchain 8.3" (replace 8.3 with the version of choice).  I've found 10.3, 10.2, 9.2, 8.3, 7, 6.2 and 5.4 this way.

I typically install this to my standard build directory and then pass the correct path/prefix to the build script for whatever code I'm building.

Alternatively, currently Ubuntu (22.04) is shipping the 10.3 version, installed with
```
sudo apt install gcc-arm-none-eabi
```
I haven't been able to find an aarch64 version.
