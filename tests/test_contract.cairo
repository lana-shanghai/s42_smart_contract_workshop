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

    // Execute push opcode with operand 10
    dispatcher.execute_instruction(0, 10);

    let stack_after = dispatcher.get_stack();
    assert(stack_after == array![10], 'Incorrect stack');
}

#[test]
fn test_pop_opcode_operand() {
    let contract_address = deploy_contract("ProvableVM");

    let dispatcher = IProvableVMDispatcher { contract_address };

    // TODO test the pop opcode
}

#[test]
fn test_add_opcode_operand() {
    let contract_address = deploy_contract("ProvableVM");

    let dispatcher = IProvableVMDispatcher { contract_address };

    // TODO test the add opcode
}

#[test]
fn test_sub_opcode_operand() {
    let contract_address = deploy_contract("ProvableVM");

    let dispatcher = IProvableVMDispatcher { contract_address };

    // TODO test the sub opcode
}

#[test]
fn test_store_opcode_operand() {
    let contract_address = deploy_contract("ProvableVM");

    let dispatcher = IProvableVMDispatcher { contract_address };

    // TODO test the store opcode
}

#[test]
fn test_load_opcode_operand() {
    let contract_address = deploy_contract("ProvableVM");

    let dispatcher = IProvableVMDispatcher { contract_address };

    // TODO test the load opcode
}

#[test]
fn test_halt_opcode_operand() {
    let contract_address = deploy_contract("ProvableVM");

    let dispatcher = IProvableVMDispatcher { contract_address };

    // TODO test the halt opcode
}

#[test]
fn test_pc() {
    let contract_address = deploy_contract("ProvableVM");

    let dispatcher = IProvableVMDispatcher { contract_address };

    // TODO test the program counter when running a program
}