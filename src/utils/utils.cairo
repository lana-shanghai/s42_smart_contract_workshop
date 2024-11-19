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
        Opcode::PUSH => 1,
        Opcode::POP => 2,
        Opcode::ADD => 3,
        Opcode::SUB => 4,
        Opcode::JMP => 5,
        Opcode::JZ => 6,
        Opcode::LOAD => 7,
        Opcode::STORE => 8,
        Opcode::HALT => 9,
    }
}