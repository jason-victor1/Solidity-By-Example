// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title MultiSigWallet — A shared vault requiring multiple approvals
/// @notice A smart contract that emulates a jointly-owned safe: funds can only be withdrawn with multiple owner approvals.
/// @dev Straightforward multi-signature wallet implementation with event logging for all critical actions.
contract MultiSigWallet {
    /// @notice Emitted when Ether is deposited into the wallet
    /// @param sender The address that sent Ether
    /// @param amount The deposited amount in wei
    /// @param balance The new wallet balance
    event Deposit(address indexed sender, uint256 amount, uint256 balance);

    /// @notice Emitted when a new transaction is proposed
    /// @param owner The owner who proposed the transaction
    /// @param txIndex The identifier of the transaction
    /// @param to Recipient address of proposed transfer
    /// @param value Amount of wei to transfer
    /// @param data Attached data for the transaction
    event SubmitTransaction(
        address indexed owner,
        uint256 indexed txIndex,
        address indexed to,
        uint256 value,
        bytes data
    );

    /// @notice Emitted when an owner confirms a transaction
    /// @param owner The confirming owner’s address
    /// @param txIndex The identifier of the confirmed transaction
    event ConfirmTransaction(address indexed owner, uint256 indexed txIndex);

    /// @notice Emitted when an owner revokes their confirmation
    /// @param owner The revoking owner’s address
    /// @param txIndex The identifier of the transaction they revoked
    event RevokeConfirmation(address indexed owner, uint256 indexed txIndex);

    /// @notice Emitted when a transaction is successfully executed
    /// @param owner The owner who executed the transaction
    /// @param txIndex The identifier of the executed transaction
    event ExecuteTransaction(address indexed owner, uint256 indexed txIndex);

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public numConfirmationsRequired;

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 numConfirmations;
    }

    mapping(uint256 => mapping(address => bool)) public isConfirmed;
    Transaction[] public transactions;

    /// @dev Restricts functions to only wallet owners
    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    /// @dev Validates transaction index exists
    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transactions.length, "tx does not exist");
        _;
    }

    /// @dev Ensures transaction has not already been executed
    modifier notExecuted(uint256 _txIndex) {
        require(!transactions[_txIndex].executed, "tx already executed");
        _;
    }

    /// @dev Ensures the caller has not already confirmed this transaction
    modifier notConfirmed(uint256 _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "tx already confirmed");
        _;
    }

    /// @notice Deploys the wallet with specified owners and required confirmations
    /// @dev Each owner must be unique and non-zero. `numConfirmationsRequired` must be <= number of owners.
    /// @param _owners Initial list of owner addresses
    /// @param _numConfirmationsRequired Number of approvals required to execute a transaction
    constructor(address[] memory _owners, uint256 _numConfirmationsRequired) {
        require(_owners.length > 0, "owners required");
        require(
            _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
            "invalid number of required confirmations"
        );

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner not unique");
            isOwner[owner] = true;
            owners.push(owner);
        }

        numConfirmationsRequired = _numConfirmationsRequired;
    }

    /// @notice Accepts incoming Ether transfers
    /// @dev Automatically logs deposit events — like putting cash into a shared safe
    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    /// @notice Propose a new transaction to withdraw funds
    /// @dev Only wallet owners can submit. Once submitted, others can confirm.
    /// @param _to Recipient address
    /// @param _value Amount of wei to send
    /// @param _data Optional data payload for contract calls
    function submitTransaction(address _to, uint256 _value, bytes memory _data)
        public
        onlyOwner
    {
        uint256 txIndex = transactions.length;
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            numConfirmations: 0
        }));
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }

    /// @notice Confirm a proposed transaction
    /// @dev Owners affirm their approval; like co-signing a bank withdrawal slip
    /// @param _txIndex Identifier of the transaction to confirm
    function confirmTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
        notConfirmed(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        transaction.numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;
        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    /// @notice Execute a confirmed transaction
    /// @dev Requires enough confirmations. Ether/data is sent to the recipient, and event is logged.
    /// @param _txIndex Identifier of the transaction to execute
    function executeTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(
            transaction.numConfirmations >= numConfirmationsRequired,
            "cannot execute tx"
        );

        transaction.executed = true;
        (bool success,) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "tx failed");
        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    /// @notice Revoke your confirmation for a transaction
    /// @dev Useful if you change your mind before execution — like removing your signature
    /// @param _txIndex Identifier of the transaction to revoke confirmation on
    function revokeConfirmation(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        require(isConfirmed[_txIndex][msg.sender], "tx not confirmed");
        transaction.numConfirmations -= 1;
        isConfirmed[_txIndex][msg.sender] = false;
        emit RevokeConfirmation(msg.sender, _txIndex);
    }

    /// @notice Returns the list of wallet owners
    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    /// @notice Returns total number of transactions proposed
    function getTransactionCount() public view returns (uint256) {
        return transactions.length;
    }

    /// @notice Fetch detailed transaction data by index
    /// @param _txIndex Identifier of the transaction to query
    /// @return to Recipient address of the transaction
    /// @return value Amount in wei proposed to send
    /// @return data Optional data payload
    /// @return executed Flag indicating execution status
    /// @return numConfirmations Current number of approvals
    function getTransaction(uint256 _txIndex)
        public
        view
        returns (
            address to,
            uint256 value,
            bytes memory data,
            bool executed,
            uint256 numConfirmations
        )
    {
        Transaction storage transaction = transactions[_txIndex];
        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }
}
