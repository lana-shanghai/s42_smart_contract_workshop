/// Utils for parsing a program

pub struct Instruction {
    pub opcode: Opcode,
    pub operand: Option<u32>,
}


#[derive(Drop)]
pub enum Opcode {
    PUSH,
    POP,
    ADD,
    SUB,
    JMP,
    JZ,
    LOAD,
    STORE,
    HALT,
}

pub fn opcode_to_felt(opcode: Opcode) -> felt252 {
    match opcode {
        Opcode::PUSH => 0,
        Opcode::POP => 1,
        Opcode::ADD => 2,
        Opcode::SUB => 3,
        Opcode::JMP => 4,
        Opcode::JZ => 5,
        Opcode::LOAD => 6,
        Opcode::STORE => 7,
        Opcode::HALT => 8,
    }
}