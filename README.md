# MaIA Core Ledger - Chain ID: 3713

**Private EVM blockchain node with public mining service for the MaIA ecosystem.**

[![License](https://img.shields.io/badge/license-MIT%2BAnti--Corporate-blue?style=for-the-badge)](LICENSE-TRINCHERA)
[![Solidity](https://img.shields.io/badge/solidity-^0.8.20-darkgreen?style=for-the-badge)](https://soliditylang.org/)
[![Go Version](https://img.shields.io/badge/go-1.20+-brightgreen?style=for-the-badge)](https://golang.org/)
[![Chain ID](https://img.shields.io/badge/chain--id-3713-orange?style=for-the-badge)]()
[![Status](https://img.shields.io/badge/status-Production%20Ready-brightgreen?style=for-the-badge)]()

> **EVM compatible | 1% bridge fee | Configurable fee cap | Public miner account**

---

## 🏗️ Architecture Overview

─────────────┐ RPC ┌──────────────────┐
│ Geth Node │◄────────────►│ Web3 Client │
│ (Mining) │ │ (Node.js/Python)│
└─────────────┘ └──────────────────┘
│ │
▼ ▼
┌─────────────┐ ┌──────────────────┐
│ TokenMaia │◄────────────►│ Monitoring UI │
│ (ERC-20) │ │ & Dashboard │
└─────────────┘ └──────────────────┘


**Chain ID:** `3713`  
**Miner Account:** `0xf1680b5d57f03db61687af5a96348f432f29274e`

---

## 🚀 Installation & Configuration

### System Requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| CPU | 2 cores | 4+ cores |
| RAM | 4 GB | 8+ GB |
| Storage | 50 GB | 100+ GB SSD |
| OS | Ubuntu 20.04+ / Debian 10+ | Same |

### Step 1: Install Dependencies

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Go
wget https://golang.org/dl/go1.20.6.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.20.6.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

# Install Node.js (for monitoring script)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install Geth (Ethereum client)
wget https://gethstore.ethdev.io/golang/ethereum-client/linux/amd64/geth-latest-linux-amd64.tar.gz
sudo tar -C /usr/local/bin -xzf geth-latest-linux-amd64.tar.gz

Step 2: Clone and Deploy

git clone https://github.com/mamanga1/maia-core-ledger.git
cd maia-core-ledger

# Install systemd service
sudo cp config/maia.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now maia.service

# Verify service is running
systemctl status maia.service

Step 3: Start Monitoring

# Install web3 dependency for the monitoring script
npm install web3

# Run the checker
node scripts/check_miner.js

# Continuous monitoring (every 12 seconds)
watch -n 12 'node scripts/check_miner.js'

💰 Token Contract Details

MaIA Token (MAIA)
Parameter	Value
Name	MaIA Token
Symbol	MAIA
Standard	ERC-20
Bridge Fee	1% of transaction amount
Fee Cap	Configurable (default: 2 ETH)
Initial Supply	1,000,000,000 MAIA

Contract Usage Examples

const Web3 = require('web3');
const web3 = new Web3('http://localhost:8545');

// Contract ABI (minimal for fee operations)
const abi = [
    "function bridge(uint256 amount) returns (bool)",
    "function calculateFee(uint256 amount) view returns (uint256)",
    "function getFeeAccrued(address account) view returns (uint256)",
    "function updateFeeCap(uint256 newCap_)",
    "function feeConfig() view returns (uint256 cap, address recipient, bool enabled)"
];

const tokenContract = new web3.eth.Contract(abi, '0x[CONTRACT_ADDRESS]');

// Check fee configuration
const config = await tokenContract.methods.feeConfig().call();
console.log(`Fee cap: ${web3.utils.fromWei(config.cap, 'ether')} ETH`);

// Get user's accrued fees
const fees = await tokenContract.methods.getFeeAccrued('0xUSER_ADDRESS').call();
console.log(`Accrued fees: ${web3.utils.fromWei(fees, 'ether')} MAIA`);

🔧 Service Management Commands

Action	                          Command
View logs	         sudo journalctl -u maia.service --follow
Restart service	   sudo systemctl restart maia.service
Stop service	     sudo systemctl stop maia.service
Check status	     systemctl status maia.service
Enable debug mode	 sudo systemctl edit maia.service → add Environment="LOG_LEVEL=debug"

📊 Monitoring & Observability
Key Metrics

Metric                       Description
Block                  Production Time	~12 seconds target
Miner Balance Growth	 Indicates successful transactions
Bridge Fee Collection	 Protocol revenue tracking
Gas Price Trends	     Network congestion indicator

Recommended Tools

Tool	                     Purpose
Grafana + Prometheus	  Real-time dashboards
Fluent Bit	Lightweight  log shipper
Node Exporter	         Hardware metrics

🔐 Security Considerations

Aspect	          Recommendation
Private Keys	Never expose in code
RPC Access	Use firewall rules to restrict
Network Isolation	Keep RPC on internal subnet
Regular Audits	Implement periodic contract audits

📞 Support & Community

Channel	                    Link
GitHub Issues	  github.com/mamanga1/maia-core-ledger/issues
Secure Email	         IberaAON@proton.me
Telegram	               @IberaAON

⚠️ NOTICE

Protocol core owner: mamanga1 (IberaAON)
Negligent use of this implementation does not exempt third parties from contractual liability with fund holders.

🧉 Credits
Built in the bunker of Corrientes, Argentina.
Made with pride and endurance – without asking for permission.

La blockchain donde los nodos son dueños de sus propias reglas.
Hecho con orgullo y aguante desde Corrientes, Argentina.



