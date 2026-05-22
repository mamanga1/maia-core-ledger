const Web3 = require('web3');

class MaiaMinerMonitor {
    constructor(rpcUrl) {
        this.rpcUrl = rpcUrl || "http://localhost:8545";
        this.web3 = new Web3(new Web3.providers.HttpProvider(this.rpcUrl));
        this.coinbase = "0xf1680b5d57f03db61687af5a96348f432f29274e";
    }

    async getStatus() {
        console.log("\n" + "█".repeat(64));
        console.log("  🚀 MAIA CORE LEDGER - MINER STATUS REPORT");
        console.log(`     Chain ID: 3713 | ${new Date().toLocaleString()}`);
        console.log("█".repeat(64) + "\n");

        try {
            const latestBlock = await this.web3.eth.getBlock('latest');
            
            console.log("📦 BLOCK PRODUCTION");
            console.log(`   Number:    ${this.pad(latestBlock.number.toString(), 10)}`);
            console.log(`   Timestamp: ${new Date(latestBlock.timestamp * 1000).toLocaleString()}`);
            console.log(`   Miner:     ${latestBlock.miner || "N/A"}`);
            console.log(`   Gas Used:  ${this.formatEther(latestBlock.gasUsed)} Gwei`);

            const coinbaseBalance = await this.web3.eth.getBalance(this.coinbase);
            
            console.log("\n🔧 MINER ACCOUNT");
            console.log(`   Address:   ${this.coinbase.substring(0, 4)}...${this.coinbase.substring(this.coinbase.length - 4)}`);
            console.log(`   Balance:   ${this.formatEther(coinbaseBalance)} ETH`);

            const chainId = await this.web3.eth.getChainId();
            
            console.log("\n🌐 NETWORK STATUS");
            console.log(`   Chain ID:  ${chainId}`);

            try {
                const mining = await this.web3.eth.isMining();
                console.log(`\n⛏️ MINING STATE`);
                console.log(`   Active:    ${mining ? "✓ YES" : "✗ NO/IDLE"}`);
                
                if (mining) {
                    const gasPrice = await this.web3.eth.getGasPrice();
                    console.log(`   Gas Price: ${this.formatEther(gasPrice)} Gwei`);
                }
            } catch(e) {
                console.log(`\n⛏️ MINING STATE`);
                console.log(`   Query failed (may not be supported)`);
            }

        } catch (error) {
            console.error("\n❌ ERROR:", error.message);
            try {
                const isAlive = await this.web3.eth.getBlockNumber();
                console.log(`\n⚠️ Connection slow but alive. Block: ${isAlive}`);
            } catch(e) {
                console.error("❌ Cannot reach node:", this.rpcUrl);
            }
        }

        console.log("\n" + "█".repeat(64) + "\n");
    }

    pad(str, len) {
        return str.toString().padStart(len, ' ');
    }

    formatEther(value) {
        const wei = parseInt(value);
        if (wei < 1e9) return `${this.pad((wei / 1e9).toFixed(6), 8)} Gwei`;
        return `${this.pad((wei / 1e12).toFixed(4), 8)} ETH`;
    }
}

(async () => {
    const monitor = new MaiaMinerMonitor();
    await monitor.getStatus();
})();
