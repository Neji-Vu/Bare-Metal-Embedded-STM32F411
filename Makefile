CC=arm-none-eabi-gcc
MACH=cortex-m4
CFLAGS= -c -mcpu=$(MACH) -mthumb -mfloat-abi=soft -std=gnu11 -Wall -o0
LDFLAGS= -mcpu=$(MACH) -mthumb -mfloat-abi=soft --specs=nano.specs -T stm32_ls.ld -Wl,-Map=final.map
LDFLAGS_SH= -mcpu=$(MACH) -mthumb -mfloat-abi=soft --specs=rdimon.specs -lc -lrdimon -T stm32_ls.ld -Wl,-Map=final.map # use for semihosting

all: main.o led.o stm32_startup.o syscalls.o final.elf

sh: main.o led.o stm32_startup.o final_sh.elf

main.o: main.c
	$(CC) $(CFLAGS) -o $@ $^

led.o: led.c
	$(CC) $(CFLAGS) -o $@ $^

stm32_startup.o: stm32_startup.c
	$(CC) $(CFLAGS) -o $@ $^

syscalls.o: syscalls.c
	$(CC) $(CFLAGS) -o $@ $^

final.elf: main.o led.o stm32_startup.o syscalls.o
	$(CC) $(LDFLAGS) -o $@ $^

final_sh.elf: main.o led.o stm32_startup.o
	$(CC) $(LDFLAGS_SH) -o $@ $^

clean:
	rm -rf *.o *.elf

load:
	openocd -f board/stm32f4discovery.cfg