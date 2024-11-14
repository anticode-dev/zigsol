const std = @import("std");
const builtin = @import("builtin");
const state = @import("state.zig");
const instruction = @import("instruction.zig");
const errors = @import("errors.zig");

// Compile time check for target environment
const is_bpf = builtin.cpu.arch == .bpfel;

pub fn panic(msg: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    solana.log("Program panic: ");
    solana.log(msg);
    unreachable;
}

// Export entrypoint with proper section
pub export fn entrypoint(param: *const state.SolanaParameters) u64 {
    return process_instruction(param);
}

// Solana system calls
pub const solana = if (is_bpf) struct {
    pub extern fn sol_log_(message: [*]const u8, length: u64) void;
    pub extern fn sol_log_64_(arg1: u64, arg2: u64, arg3: u64, arg4: u64, arg5: u64) void;

    pub fn log(message: []const u8) void {
        sol_log_(message.ptr, message.len);
    }
} else struct {
    pub fn log(message: []const u8) void {
        std.debug.print("{s}\n", .{message});
    }
};

fn process_instruction(param: *const state.SolanaParameters) u64 {
    if (param.ka_num < 1) {
        solana.log("Not enough accounts");
        return @intFromEnum(errors.SolanaError.InvalidAccount);
    }

    const data = param.data[0..param.data_len];

    var inst: instruction.InstructionData = undefined;
    instruction.InstructionData.decode(&inst, data) catch {
        solana.log("Failed to decode instruction");
        return @intFromEnum(errors.SolanaError.InvalidInstruction);
    };

    return switch (inst.tag) {
        0 => instruction.process_initialize(param),
        1 => instruction.process_transfer(param),
        else => {
            solana.log("Invalid instruction tag");
            return @intFromEnum(errors.SolanaError.InvalidInstruction);
        },
    };
}
