use starknet::ContractAddress;

use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};

use s42_smart_contract_workshop::vm::vm::IProvableVMSafeDispatcher;
use s42_smart_contract_workshop::vm::vm::IProvableVMSafeDispatcherTrait;
use s42_smart_contract_workshop::vm::vm::IProvableVMDispatcher;
use s42_smart_contract_workshop::vm::vm::IProvableVMDispatcherTrait;

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

/// TEST PROGRAM
/// PUSH 10
// PUSH 20
// ADD
// STORE 0
// LOAD 0
// PUSH 5
// ADD
// HALT

/// Inside the test, we will pass the value backwards, because of pop_front()
/// PUSH 10 will be a tuple (0, 10) 


#[test]
fn test_push_opcode_operand() {
    let contract_address = deploy_contract("ProvableVM");

    let dispatcher = IProvableVMDispatcher { contract_address };

    let len_before = dispatcher.get_len();
    // Execute push opcode with operand 10
    dispatcher.execute_instruction(0, 10);
    let len_after = dispatcher.get_len();
    assert(len_before == 0, 'Len before is wrong');
    assert(len_after == 1, 'Len after is wrong');

    let stack_after = dispatcher.get_stack();
    assert(stack_after == array![10], 'Incorrect stack');
}

#[test]
fn test_pop_opcode_operand() {
    let contract_address = deploy_contract("ProvableVM");

    let dispatcher = IProvableVMDispatcher { contract_address };
    dispatcher.execute_instruction(0, 10); // PUSH 10
    assert(dispatcher.get_vec().len() == 1, 'Vec len is wrong');

    dispatcher.execute_instruction(0, 11); // PUSH 11
    assert(dispatcher.get_vec().len() == 2, 'Vec len is wrong');

    dispatcher.execute_instruction(1, 0); // POP
    assert(dispatcher.get_vec().len() == 2, 'Vec len is wrong');

    dispatcher.execute_instruction(1, 0); // POP
    assert(dispatcher.get_vec().len() == 2, 'Vec len is wrong');

    let del_val: felt252 = 'Deleted value'.into();  // 5418904080056592270825848862053
    assert(dispatcher.get_vec() == array![del_val, del_val], 'Incorrect vec');

    dispatcher.execute_instruction(0, 12); // PUSH 12
    assert(dispatcher.get_vec().len() == 2, 'Vec len is wrong');

    dispatcher.execute_instruction(0, 13); // PUSH 13
    assert(dispatcher.get_vec().len() == 2, 'Vec len is wrong');


    assert(dispatcher.get_stack() == array![12, 13], 'Incorrect stack');
    assert(dispatcher.get_vec() == array![12, 13], 'Incorrect vec');

    assert(dispatcher.get_len() == 2, 'Stack len after is wrong');
}

// #[test]
// fn test_add_opcode_operand() {
//     let contract_address = deploy_contract("ProvableVM");

//     let dispatcher = IProvableVMDispatcher { contract_address };

//     // TODO test the add opcode
// }

// #[test]
// fn test_sub_opcode_operand() {
//     let contract_address = deploy_contract("ProvableVM");

//     let dispatcher = IProvableVMDispatcher { contract_address };

//     // TODO test the sub opcode
// }

// #[test]
// fn test_store_opcode_operand() {
//     let contract_address = deploy_contract("ProvableVM");

//     let dispatcher = IProvableVMDispatcher { contract_address };

//     // TODO test the store opcode
// }

// #[test]
// fn test_load_opcode_operand() {
//     let contract_address = deploy_contract("ProvableVM");

//     let dispatcher = IProvableVMDispatcher { contract_address };

//     // TODO test the load opcode
// }

// #[test]
// fn test_halt_opcode_operand() {
//     let contract_address = deploy_contract("ProvableVM");

//     let dispatcher = IProvableVMDispatcher { contract_address };

//     // TODO test the halt opcode
// }

// #[test]
// fn test_pc() {
//     let contract_address = deploy_contract("ProvableVM");

//     let dispatcher = IProvableVMDispatcher { contract_address };

//     // TODO test the program counter when running a program
// }