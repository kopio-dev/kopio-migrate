# sol/ts base

Lightweight repository for kresko work.

Solidity:

- Includes a regular script + connected test in `KreskoScript/KredScript`.
- Includes a forking script + connected test in `KreskoScriptFork/KredScriptFork`.
- Includes a multisig script + connected test in `KreskoScriptSafe/KredScriptSafe`.

- Includes Pyth/Diamond helpers in `KrBase.s.sol` that are included in above scripts.

Typescript:

- Includes premade Viem configuration and pyth helpers for interacting with the contracts.

## Setup

```shell
just setup && cp .env.example > .env
```

The string network correspond to `foundry.toml` names.

```shell
KRESKO_NETWORK= # Used for KreskoScript.s.sol / KreskoScript.t.sol
KRESKO_FORK= # Used for KreskoScriptFork.s.sol / KreskoScriptFork.t.sol
RPC_KRESKO_FORK= # RPC url for the "kresko-fork"

KREDITS_NETWORK= # Used for KredScript.s.sol / KredScript.t.sol
KREDITS_FORK= # Used for KredScriptFork.s.sol / KredScriptFork.t.sol
RPC_KREDITS_FORK= # RPC url for the "kredits-fork"

SAFE_NETWORK= # Use for *Safe.s.sol / *Safe.t.sol
SAFE_CHAIN_ID= # Matches the above network.
MNEMONIC_PATH= # Derivation path for directly using trezor/ledger.
SIGNER_TYPE= # 0 = Trezor, 1 = Frame, 2 = Ledger
SAFE_ADDRESS= # Address of your safe.
```

## Requirements

- **foundry**: required, obvious

```shell
curl -L https://foundry.paradigm.xyz | bash
```

- **bun**: required, for ffi-scripts

```shell
curl -fsSL https://bun.sh/install | bash
```

- **frame**: optional, required for pk/mnemonic

https://frame.sh/

- **just**: optional, buut better just use it

https://github.com/casey/just

## Regular Usage

Copy `justfile.example` into projects parent folder as `justfile` to use it from any project.

Run test:

```shell
just t TEST_NAME
```

Run script:

```shell
just s SCRIPT_NAME FUNC_SIG
```

Run script broadcast:

```shell
just ss SCRIPT_NAME FUNC_SIG
```

Run script broadcast to fork:

```shell
just sf SCRIPT_NAME FUNC_SIG
```

Deploy:

```shell
just d SCRIPT_NAME FUNC_SIG
```

Resume Deploy:

```shell
just r SCRIPT_NAME FUNC_SIG
```

## Safe Send Usage

### Setup

### Propose a script as batch

This thing relies on using scripts with unique `--sig "myFunc()"` so do not use `run()`.

Use current nonce

```shell
just safe-run Send safeTx
```

or

```shell
forge script Send --sig "safeTx()" && forge script SafeScript --sig "sendBatch(string)" safeTx --ffi -vvv
```

Use custom nonce

```shell
just safe-run-nonce Send safeTx 111
```

or

```shell
forge script Send --sig "safeTx()" && forge script SafeScript --sig "sendBatch(string,uint256)" safeTx 111 --ffi -vvv
```

### Delete a proposed transaction batch

```shell
just safe-del 0xSAFE_TX_HASH
```

or

```shell
bun utils/ffi.ts deleteBatch 0xSAFE_TX_HASH
```

## Misc

- Look into `utils/ffi.ts` for other available commands using `bun utils/ffi.ts command ...args`
