# what is this?
it is an attempt at compiling a zig ebpf program and deploying it to solana blockchain

# does it compile?
yes, but...

# does it upload to sol?
no :(

# how to test?
1. zig build bpf
2. then solana program deploy zig-out/bin/target/program.so
3. -> currently getting: Error: ELF error: ELF error: Failed to parse ELF file: invalid file header
