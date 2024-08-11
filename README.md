## Upgradeable Contracts

This is a learning project based on Cyfrin Updraft foundry tutorial

## Key Concepts

### Transparent Proxy vs. UUPS

- Transparent Proxy: Separates admin and user roles clearly, with the proxy itself handling upgrades and admin functions.
- UUPS: Places more responsibility on the implementation contract for managing upgrades, offering more flexibility but requiring careful management.

### Proxy and Implementation

- proxy contract
  - the contract user interact with
  - stores the contract's state and delegates calls to the implementation
  - does not have the logic itself; it forwards requests to the implementation contract.
- Implementation Contract
  - contains actual logics
  - it does not store state, except for possibly some adminitrative variabels.

### Initializable and initializer

'initializer' is a modifier defined in 'Initializable' interface, it works as a 'contructor' for implementation contracts. Since the 'proxy' and 'implementation' are created separetly, the 'initializer' function can be used to set up the state of implementation contract, such as ownership.

The 'initializer' can be executed both manually or automatically.

```
bytes memory data = abi.encodeWithSignature("initialize(uint256)", 42);
ERC1967Proxy proxy = new ERC1967Proxy(address(box), data);
```

### delegatecall

1. Execution Context: The delegatecall operation causes the implementation contract's code to run in the context of the proxy contract. This means that:
   - The proxy’s storage is accessed.
   - The proxy’s msg.sender and msg.value are used.
2. Shared Storage Layout: In Solidity, state variables are stored in specific storage slots. When delegatecall is used, the implementation contract's logic reads from and writes to the storage slots of the proxy contract.

### Storage Slots

- Storage Slot Assignment: In Solidity, state variables are assigned to storage slots in the order they are declared:

  - The first declared variable is stored in slot 0.
  - The second in slot 1, and so on.
    ```solidity
    contract MyImplementation {
        uint256 public value;  // Stored in slot 0
    }
    ```

- Proxy Contract Storage: Even though the proxy contract doesn’t explicitly declare a value variable, its storage layout is still accessible to the implementation contract when delegatecall is used.

When delegatecall is invoked:

- The value variable in MyImplementation refers to storage slot 0.
- This slot 0 is located in the proxy contract's storage.

Thus, when MyImplementation’s setValue function is called through the proxy:

- The value in slot 0 of the proxy’s storage is updated.
