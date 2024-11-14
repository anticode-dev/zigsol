pub const SolanaError = enum(u64) {
    Success = 0,
    InvalidInstruction = 1,
    InvalidAccount = 2,
    InsufficientFunds = 3,
    AccountDataTooSmall = 4,
    MissingRequiredSignature = 5,
    Custom = 6,
    _,
};
