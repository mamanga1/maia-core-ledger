# MaIA Core Ledger

**Private EVM Blockchain Node – Chain ID: 3713**

[![License](https://img.shields.io/badge/License-MIT%2BAnti--Corporate-blue?style=flat-square)](LICENSE-TRINCHERA)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.20-darkgreen?style=flat-square)](https://soliditylang.org/)
[![Go](https://img.shields.io/badge/Go-1.20+-00ADD8?style=flat-square&logo=go)](https://golang.org/)
[![Chain ID](https://img.shields.io/badge/Chain%20ID-3713-orange?style=flat-square)]()
[![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen?style=flat-square)]()

---

## Overview

**MaIA Core Ledger** is a production-ready private EVM blockchain node designed for the MaIA ecosystem. It provides a public mining service, an ERC-20 token contract with a built‑in 1% bridge fee, and a monitoring script for operational visibility.

**Chain ID:** `3713`  
**Miner Account:** `0xf1680b5d57f03db61687af5a96348f432f29274e`

---

## Architecture

─────────────────┐ ┌─────────────────┐
│ Geth Node │ ◄─────► │ Web3 Client │
│ (Mining) │ RPC │ (Node.js/Py) │
└─────────────────┘ └─────────────────┘
│ │
▼ ▼
┌─────────────────┐ ┌─────────────────┐
│ TokenMaia │ ◄─────► │ Monitoring │
│ (ERC-20) │ │ Script │
└─────────────────┘ └─────────────────┘


---

## Repository Structure

maia-core-ledger/
├── config/
│ └── maia.service # Systemd service for Geth miner
├── contracts/
│ └── TokenMaia.sol # ERC-20 token with 1% bridge fee
├── scripts/
│ └── check_miner.js # Node.js monitoring script
└── README.md # This file


---

## Quick Start

### Prerequisites

| Requirement | Minimum Version |
|-------------|-----------------|
| **Go** | 1.20+ |
| **Node.js** | 18.0+ |
| **Geth** | Latest stable |
| **Linux** | Ubuntu 20.04+ / Debian 10+ |

### Installation

```bash
# Clone the repository
git clone https://github.com/mamanga1/maia-core-ledger.git
cd maia-core-ledger

# Install the systemd service
sudo cp config/maia.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now maia.service

# Verify the service is running
systemctl status maia.service

Monitoring

# Install web3 dependency
npm install web3

# Run the monitoring script
node scripts/check_miner.js

# Continuous monitoring (every 12 seconds)
watch -n 12 'node scripts/check_miner.js'

Token Contract

Token                  Parameters
Parameter	            Value
Name	             MaIA Token
Symbol	                MAIA
Standard	          ERC-20
Bridge Fee	           1%
Fee Cap	Configurable (default: 2 ETH)
Initial Supply	    1,000,000,000 MAIA

Fee Mechanism
The bridge() function applies a 1% fee to each transaction. The fee cap is configurable by the contract owner.

function bridge(uint256 amount) public nonReentrant returns (bool);
function calculateFee(uint256 amount) public view returns (uint256);
function updateFeeCap(uint256 newCap_) public onlyOwner;

Contract Interaction Example

const Web3 = require('web3');
const web3 = new Web3('http://localhost:8545');

const contractAddress = '0x...'; // Deployed contract address
const abi = [ /* ABI from compilation */ ];
const token = new web3.eth.Contract(abi, contractAddress);

// Check fee configuration
const config = await token.methods.getFeeConfig().call();
console.log(`Fee cap: ${web3.utils.fromWei(config.cap, 'ether')} ETH`);

// Get accrued fees for an account
const fees = await token.methods.getFeeAccrued('0x...').call();

Service Management

Action	                   Command
View logs	    sudo journalctl -u maia.service -f
Restart	       sudo systemctl restart maia.service
Stop	       sudo systemctl stop maia.service
Start	       sudo systemctl start maia.service
Status	       systemctl status maia.service

Monitoring Script Output
████████████████████████████████████████████████████████████
  🚀 MAIA CORE LEDGER - MINER STATUS REPORT
     Chain ID: 3713 | 5/22/2026, 10:30:45 AM
████████████████████████████████████████████████████████████

📦 BLOCK PRODUCTION
   Number:        12345
   Timestamp:     5/22/2026, 10:30:45 AM
   Miner:         0xf168...74e
   Gas Used:      21000 Gwei

🔧 MINER ACCOUNT
   Address:       0xf1...74e
   Balance:       42.5 ETH

🌐 NETWORK STATUS
   Chain ID:      3713
   Type:          private

⛏️ MINING STATE
   Active:        ✓ YES
   Gas Price:     1.0 Gwei

████████████████████████████████████████████████████████████

Security & Compliance

License
MIT with Anti-Corporate Appropriation Clause. See LICENSE-TRINCHERA.

Corporations (>50 employees) using this protocol must:

Open‑source their implementation within 30 days

Contribute ≥10% of net revenue to the maintenance fund

Offer patent cross‑licensing

Notice
Protocol core owner: mamanga1 (IberaAON)
Negligent use does not exempt third parties from contractual liability.

Support

Channel                Link
Issues	          GitHub Issues
Email	       IberaAON@proton.me
Telegram	       @IberaAON

Built in the bunker of Corrientes, Argentina.
Made with pride and endurance – without asking for permission.


