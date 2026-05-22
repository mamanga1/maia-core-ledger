// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TokenMaia is ERC20, Ownable, ReentrancyGuard {
    uint8 public constant BRIDGE_FEE_PERCENT = 1;
    
    struct FeeConfig {
        uint256 capPerTx;
        address feeRecipient;
        bool enabled;
    }
    
    FeeConfig public feeConfig;
    
    mapping(address => uint256) private userFees;
    mapping(address => uint256) private bridgeCount;
    
    event BridgeFeeCollected(uint256 indexed amount, address indexed from, uint8 feePercent);
    event FeeConfigUpdated(FeeConfig newConfig);
    event BridgeTransaction(address indexed sender, uint256 indexed txHash, uint256 amount, uint256 fee);

    constructor() ERC20("MaIA Token", "MAIA") {
        _mint(msg.sender, 1_000_000_000 * 10**decimals());
        
        feeConfig = FeeConfig({
            capPerTx: 2 ether,
            feeRecipient: payable(msg.sender),
            enabled: true
        });
    }

    function bridge(uint256 amount) public nonReentrant returns (bool) {
        if (amount == 0 || !feeConfig.enabled) return true;
        
        uint256 fee = calculateFee(amount);
        require(fee <= feeConfig.capPerTx, "Fee exceeds cap");
        
        bool success = super.transfer(msg.sender, amount - fee);
        
        if (success) {
            userFees[msg.sender] += fee;
            bridgeCount[msg.sender]++;
            
            emit BridgeFeeCollected(fee, msg.sender, BRIDGE_FEE_PERCENT);
            emit BridgeTransaction(msg.sender, tx.origin, amount, fee);
        }
        
        return success;
    }

    function calculateFee(uint256 amount) public view returns (uint256) {
        if (amount <= 10**decimals()) return 0;
        
        uint256 fee = (amount * uint256(BRIDGE_FEE_PERCENT)) / 100;
        
        if (feeConfig.capPerTx > 0 && fee > feeConfig.capPerTx) {
            return feeConfig.capPerTx;
        }
        
        return fee;
    }

    function getFeeAccrued(address account) public view returns (uint256) {
        return userFees[account];
    }

    function getBridgeCount(address account) public view returns (uint256) {
        return bridgeCount[account];
    }

    function updateFeeCap(uint256 newCap_) public onlyOwner {
        feeConfig.capPerTx = newCap_;
        emit FeeConfigUpdated(feeConfig);
    }

    function setFeeRecipient(address recipient) public onlyOwner {
        require(recipient != address(0));
        feeConfig.feeRecipient = payable(recipient);
        emit FeeConfigUpdated(feeConfig);
    }

    function toggleBridgeFees(bool enable_) public onlyOwner {
        feeConfig.enabled = enable_;
        emit FeeConfigUpdated(feeConfig);
    }

    function getFeeConfig() public view returns (uint256 cap, address recipient, bool enabled) {
        return (feeConfig.capPerTx, feeConfig.feeRecipient, feeConfig.enabled);
    }
}
