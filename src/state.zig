pub const AccountInfo = extern struct {
    key: [*]const u8 align(8),
    lamports: *u64 align(8),
    data_len: u64 align(8),
    data: [*]u8 align(8),
    owner: [*]const u8 align(8),
    rent_epoch: u64 align(8),
    is_signer: bool align(1),
    is_writable: bool align(1),
    executable: bool align(1),

    comptime {
        if (@sizeOf(@This()) % 8 != 0) {
            @compileError("AccountInfo must be 8-byte aligned");
        }
    }
};

pub const SolanaParameters = extern struct {
    ka: [*]const AccountInfo align(8),
    ka_num: u64 align(8),
    data: [*]const u8 align(8),
    data_len: u64 align(8),
    program_id: [*]const u8 align(8),
};
