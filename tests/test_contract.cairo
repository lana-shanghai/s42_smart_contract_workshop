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

// #[test]
// #[feature("safe_dispatcher")]
// fn test_cannot_increase_balance_with_zero_value() {
//     let contract_address = deploy_contract("HelloStarknet");

//     let safe_dispatcher = IHelloStarknetSafeDispatcher { contract_address };

//     let balance_before = safe_dispatcher.get_balance().unwrap();
//     assert(balance_before == 0, 'Invalid balance');

//     match safe_dispatcher.increase_balance(0) {
//         Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
//         Result::Err(panic_data) => {
//             assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0));
//         }
//     };
// }
