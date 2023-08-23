# Circle

A bare metal programming environment for the Raspberry Pi.

First, decide where you want the toolchains and Circle to live:
```
export PREFIX="/home/pdf/container-data/builds"
```

Download latest ARM 32-bit GNU toolchain
```
wget "https://developer.arm.com/-/media/Files/downloads/gnu/12.3.rel1/binrel/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz?rev=dccb66bb394240a98b87f0f24e70e87d&hash=B788763BE143D9396B59AA91DBA056B6" -O /tmp/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz
unxz /tmp/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz
tar xf /tmp/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar -C $PREFIX
rm /tmp/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar
```

Download latest ARM 64-bit GNU toolchain
```
wget "https://developer.arm.com/-/media/Files/downloads/gnu/12.3.rel1/binrel/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-elf.tar.xz?rev=a8bbb76353aa44a69ce6b11fd560142d&hash=20124930455F791137DDEA1F0AF79B10" -O /tmp/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-elf.tar.xz
unxz /tmp/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-elf.tar.xz
tar xf /tmp/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-elf.tar -C $PREFIX
rm /tmp/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-elf.tar
```

Get Circle
```
cd $PREFIX
git clone https://github.com/rsta2/circle
```

Now get this repo and put the script in the circle directory
```
cd $PREFIX
git clone https://github.com/piersfinlayson/pi-bare
cp $PREFIX/pi-bare/circle/makesd.sh $PREFIX/circle/
```

You can now build one of the samples and write it to an SD card.  Install the SD card and get the device e.g. /dev/sdh.  Then:
```
cd $PREFIX/circle
./makesd.sh 64 /dev/sdh 17-fractal
```
(This builds a 64-bit version, for a PI 3.)

See the list of samples:
```
ls $PREFIX/circle/sample/
```

