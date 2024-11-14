const state = @import("state.zig");
const errors = @import("errors.zig");

pub const InstructionData = struct {
    tag: u8,
    data: []const u8,

    // Return values through a pointer instead of struct return
    pub fn decode(dest: *InstructionData, buffer: []const u8) !void {
        if (buffer.len < 1) return error.InvalidInstruction;
        dest.* = .{
            .tag = buffer[0],
            .data = buffer[1..],
        };
    }
};

pub fn process_initialize(param: *const state.SolanaParameters) u64 {
    // Implementation for initialization
    _ = param;
    return 0;
}

pub fn process_transfer(param: *const state.SolanaParameters) u64 {
    // Implementation for transfer
    _ = param;
    return 0;
}
