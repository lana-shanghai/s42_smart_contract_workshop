/// Interface representing `ProvableVM`.
/// This interface allows execution of programs inside the VM.
#[starknet::interface]
pub trait IProvableVM<TContractState> {
    /// Run a program.
    fn run_program(ref self: TContractState, program: Array<(felt252, felt252)>) -> Result<bool, felt252>;
    /// Execute instruction.
    fn execute_instruction(ref self: TContractState, opcode: felt252, operand: felt252);
    /// Write a new element to the heap.
    fn write_heap(ref self: TContractState, value: felt252) {}
    /// Read from the heap.
    fn get_heap(ref self: TContractState) -> felt252;
    /// Retrieve latest stack.
    fn get_stack(self: @TContractState) -> Array<felt252>;
    /// Retrieve program counter.
    fn get_pc(self: @TContractState) -> felt252;
}

/// A simple provable VM.
#[starknet::contract]
pub mod ProvableVM {
    use super::IProvableVM;
use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess, Vec, VecTrait, MutableVecTrait};

    #[storage]
    struct Storage {
        pc: felt252,
        stack: Vec<felt252>,
        stack_len: u32,
        heap: felt252,
        flags: u8,
    }

    #[abi(embed_v0)]
    impl ProvableVMImpl of super::IProvableVM<ContractState> {
        fn get_stack(self: @ContractState) -> Array<felt252> {
            let mut stack = array![];
            for i in 0..self.stack.len() {
                stack.append(self.stack.at(i).read());
            };
            stack
        }
        
        fn get_pc(self: @ContractState) -> felt252 {
            self.pc.read()
        }

        fn write_heap(ref self: ContractState, value: felt252) {
            self.heap.write(value);
        }

        fn get_heap(ref self: ContractState) -> felt252 {
            self.heap.read()
        }

        fn execute_instruction(ref self: ContractState, opcode: felt252, operand: felt252) {
                match opcode {
                    // PUSH
                    0 => { 
                        self.stack.append().write(operand);
                        self.stack_len.write(self.stack_len.read() + 1);
                    },
                    // POP
                    1 => { 
                        let mut storage_ptr = self.stack.at(
                            self.stack_len.read().try_into().unwrap() - 1_u64
                        );
                        storage_ptr.write('Deleted value');
                        self.stack_len.write(self.stack_len.read() - 1);
                    }, 
                    // ADD
                    2 => { 
                        let stack = self.get_stack();
                        let sum = *stack.at(
                            self.stack_len.read() - 1_u32
                        ) + *stack.at(
                            self.stack_len.read() - 2_u32
                        );

                        self.stack.append().write(sum);
                        self.stack_len.write(self.stack_len.read() + 1);
                    }, 
                    // SUB
                    3 => { 
                        let stack = self.get_stack();
                        let diff = *stack.at(
                            self.stack_len.read() - 2_u32
                        ) - *stack.at(
                            self.stack_len.read() - 1_u32
                        );
                        
                        self.stack.append().write(diff);
                        self.stack_len.write(self.stack_len.read() + 1);
                    }, 
                    4 => {  }, // JMP
                    5 => {  }, // JZ
                    // LOAD
                    6 => { 
                        let heap_element = self.heap.read();
                        self.stack.append().write(heap_element); 
                        self.stack_len.write(self.stack_len.read() + 1);
                    }, 
                    // STORE
                    7 => { 
                        let stack = self.get_stack();
                        let element_to_store = *stack.at(self.stack_len.read() - 1_u32);
                        self.heap.write(element_to_store);
                    }, 
                    // HALT
                    8 => { panic!("Halt execution") },
                    _ => panic!("Unsupported opcode"),
                };
        }
        
        fn run_program(ref self: ContractState, mut program: Array<(felt252, felt252)>) -> Result<bool, felt252> {
            while let Option::Some(instruction) = program.pop_front() {
                let (opcode, operand) = instruction;
                self.execute_instruction(opcode, operand);
                // Increment counter
                self.pc.write(self.pc.read() + 1);
            };
            return Result::Ok(true);
        }
    }    
}
