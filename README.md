# s42_smart_contract_workshop
An end to end implementation and deployment of a Cairo smart contract on Starknet with 
TODOs on the way. A toy example of a VM. 

## Prerequisites 

#### Rust 
`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

#### Scarb 

Scarb is a Cairo package and compiler toolchain manager.
`curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh`

#### Foundry

Starknet Foundry is a toolchain for developing smart contracts for Starknet.
`curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh` 

And then run `snfoundryup`

#### Universal Sierra Compiler
`curl -L https://raw.githubusercontent.com/software-mansion/universal-sierra-compiler/master/scripts/install.sh | sh`

## Installation

Clone this repository `https://github.com/lana-shanghai/s42_smart_contract_workshop.git`

## A small example of a VM 

The VM will have a stack and a heap. Each program that can be executed by the VM is a set
of `(opcode, operand)` that update the stack either by pushing items, removing items, or
doing some operation them. Items can come from the stack directly or be passed from the 
heap. 

Some opcodes must have an operand. Available opcodes are 

`PUSH` 10 -> push the number 10 onto the stack
`POP` -> remove the last element from the stack 
`ADD` -> add the last two elements on the stack and push to stack
`SUB` -> subtract the last element on the stack from the previous and push to stack
`JMP` -> jump to a specific number of instruction
`JZ` -> jump to a specific number of instruction if a condition is met
`LOAD` -> take an element from the heap and push it onto the stack
`STORE` -> take an element from the stack and push it onto the heap
`HALT` -> stop program execution

Follow the `TODO`s in the `src/vm/vm.cairo` and `tests/test_contract.cairo`!

## Useful and helpful docs

Head over to the [Cairo Book](https://book.cairo-lang.org/ch02-00-common-programming-concepts.html)

Scarb [cheatsheet](https://docs.swmansion.com/scarb/docs/cheatsheet.html)

Software Mansion documentation of all available [Modules and Traits](https://docs.swmansion.com/scarb/corelib/index.html) 

Tooling docs, such as `foundry` and `sncast` [guides](https://foundry-rs.github.io/starknet-foundry/starknet/index.html)

[StarkNet by Example](https://github.com/NethermindEth/StarknetByExample/tree/main) from Nethermind 

## Build and test the contracts

`scarb build` and `scarb test`

The final program we would like to test is:

`PUSH 10`
`PUSH 20`
`ADD`
`STORE 0`
`LOAD 0`
`PUSH 5`
`ADD`
`HALT`

Don't forget that Cairo can only pop items from the front, so we will have to write
the program backwards! 

## Setup account for interacting with the blockchain

Add [Braavos](https://chromewebstore.google.com/detail/braavos-starknet-wallet/jnlgamecbpmbajjfhmmmlhejkemejdma?hl=en&pli=1) wallet to extentions and create a new account. Export the private key, 
public key, and address. Save them securely in 1Password or discard after
tests. Never use the same wallets for coding and for storing funds!

Prefund your account with some Sepolia testnet ETH using a [faucet](https://starknet-faucet.vercel.app/). 

To add the Braavos account to `sncast` run:

```bash
sncast account import \               
    --url https://starknet-sepolia.public.blastapi.io/rpc/v0_7 \                      
    --name YOUR_ACCOUNT \
    --address YOUR_ADDRESS \
    --private-key 0xabc \
    --type braavos \
    --add-profile YOUR_ACCOUNT
```

## Deploying your contract 

Once your account has been setup these commands will help you to declare, deploy, 
and call your contract 

```bash
sncast --account YOUR_ACCOUNT \
    declare \
    --url https://starknet-sepolia.public.blastapi.io/rpc/v0_7 \
    --fee-token eth \
    --contract-name ProvableVM
```

## Deploy a contract with the declared class hash and receive the contract address

```bash
sncast --account YOUR_ACCOUNT \
    deploy \
    --url https://starknet-sepolia.public.blastapi.io/rpc/v0_7 \
    --fee-token eth \
    --class-hash CLASS_HASH
```

## Set the heap to 5 by calling the `write_heap_element()` function

```bash
sncast --account YOUR_ACCOUNT \
  invoke \
  --url https://starknet-sepolia.public.blastapi.io/rpc/v0_7 \
  --fee-token eth \
  --contract-address CONTRACT_ADDRESS \
  --function "write_heap" \
  --calldata 5
```

## Read the heap and check that the invoking of the function worked

```bash
sncast \
  call \
  --url https://starknet-sepolia.public.blastapi.io/rpc/v0_7 \
  --contract-address CONTRACT_ADDRESS \
  --function "get_heap"
```