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
    fn get_heap(self: @TContractState) -> felt252;
    /// Retrieve latest stack.
    fn get_stack(self: @TContractState) -> Array<felt252>;
    /// Retrieve actual vec.
    fn get_vec(self: @TContractState) -> Array<felt252>;
    /// Retrieve program counter.
    fn get_pc(self: @TContractState) -> felt252;
    /// Get length of the full Vec.
    fn get_len(self: @TContractState) -> felt252;
}

/// A simple provable VM.
#[starknet::contract]
pub mod ProvableVM {
    use super::IProvableVM;
    /// Traits needed to manipulate storage and to use and modify Vec.
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess, Vec, VecTrait, MutableVecTrait};

    #[storage]
    struct Storage {
        pc: felt252,
        stack: Vec<felt252>, // Check Storage Vecs in Cairo Book!
        stack_len: u32, // What is a u32 under the hood  in Cairo?
        heap: felt252,
    }

    #[abi(embed_v0)]
    impl ProvableVMImpl of super::IProvableVM<ContractState> {
        fn get_len(self: @ContractState) -> felt252 {
            let mut stack: Array<felt252> = array![];

            for i in 0..self.get_stack().len() {
                stack.append(self.stack.at(i.try_into().unwrap()).read());
            };

            stack.len().into()
        }

        fn get_stack(self: @ContractState) -> Array<felt252> {
            // TODO declare an empty array. How to make sure we can add items to it?
            let mut stack: Array<felt252> = array![];

            // TODO loop through the stack Vec in storage and append to the array.
            for i in 0..self.stack_len.read() {
                stack.append(self.stack.at(i.try_into().unwrap()).read());
            };

            // Now the compiler says the VecTrait is unused, but what happens if we
            // add the code? 
            stack
        }

        fn get_vec(self: @ContractState) -> Array<felt252> {
            let mut vec: Array<felt252> = array![];

            for i in 0..self.stack.len() {
                vec.append(self.stack.at(i.try_into().unwrap()).read());
            };

            vec
        }
        
        fn get_pc(self: @ContractState) -> felt252 {
            self.pc.read()
        }

        fn write_heap(ref self: ContractState, value: felt252) {
            self.heap.write(value);
        }

        fn get_heap(self: @ContractState) -> felt252 {
            self.heap.read()
        }

        fn execute_instruction(ref self: ContractState, opcode: felt252, operand: felt252) {
                match opcode {
                    // PUSH
                    0 => { 
                        // Check if we need to overwrite a "deleted" slot or append
                        if self.stack_len.read().into() < self.stack.len() {
                            // If there's room in the pre-allocated stack (deleted slot), overwrite the slot
                            let mut storage_ptr = self.stack.at(self.stack_len.read().try_into().unwrap());
                            storage_ptr.write(operand);
                        } else {
                            // Append a new value if no deleted slots exist
                            self.stack.append().write(operand);
                        }
                        // Update the stack length to reflect the added element
                        self.stack_len.write(self.stack_len.read() + 1);
                    },
                
                    // POP
                    1 => { 
                        if self.stack_len.read() > 0 {
                            let mut storage_ptr = self.stack.at(
                                self.stack_len.read().try_into().unwrap() - 1_u64
                            );
                            storage_ptr.write('Deleted value'); // Mark the value as deleted
                            self.stack_len.write(self.stack_len.read() - 1); // Decrease the logical stack length
                        } else {
                            // Optional: Handle underflow case for popping from an empty stack
                            panic!("Attempted to pop from an empty stack");
                        }
                    }, 

                    // ADD
                    2 => { 
                        let _stack = self.get_stack();
                        let _sum = 1 + 2;
                        // TODO: read the last two elements and add them
                        // the last from the one before

                        // TODO: write sum to stack
                        // TODO: update stack length
                    }, 
                    // SUB
                    3 => { 
                        let _stack = self.get_stack();
                        let _diff = 2 - 1; 
                        // TODO: read the last two elements and substract
                        // the last from the one before
                        
                        // TODO: write diff to stack
                        // TODO: update stack length
                    }, 
                    4 => {  }, // JMP
                    5 => {  }, // JZ
                    // LOAD
                    6 => { 
                        let heap_element = self.heap.read();
                        self.stack.append().write(heap_element); 
                        // TODO: update stack length
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
            while let Option::Some(_instruction) = program.pop_front() {
                // TODO: unpack the tuple to get the opcode and operand!
                self.execute_instruction(0, 0);
                // Increment counter
                // TODO: increment counter
            };
            return Result::Ok(true);
        }
    }    
}
