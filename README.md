# Simple DEX Project

## 🚀 Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/palaashjain/Blockchain-Assignment-3.git
cd Blockchain-Assignment-3
```

---

### 2. Install dependencies

```bash
npm install
```

---

### 3. Start local blockchain

```bash
npm run node
```

---

### 4. Deploy contracts

Open a new terminal:

```bash
npm run deploy
```

You will get output like:

```
TokenA: 0x...
TokenB: 0x...
DEX:    0x...
```

---

### 5. Open UI

Open `index.html` in browser
(or use Live Server)

---

### 6. Connect Wallet

* Open MetaMask
* Select **Hardhat Local network**
* Click **Connect Wallet**

---

## 🧪 How to Use the DEX

---

### 🔹 Step 1: Enter Contract Addresses

Paste:

* DEX address
* TokenA address
* TokenB address

(from deployment output)

---

### 🔹 Step 2: Add Liquidity

Enter:

```
TokenA: 100
TokenB: 100
```

Click **Add**

👉 This adds liquidity to the pool.

---

### 🔹 Step 3: Receive LP Tokens

* Liquidity providers receive LP tokens (handled internally in contract)
* These represent ownership in the pool

---

### 🔹 Step 4: Perform Swap

Enter amount:

```
Example: 50
```

Click:

* Swap A → B
  or
* Swap B → A

---

### 🔹 Step 5: View Pool Info

Click **Refresh**

You will see:

* Reserves of TokenA and TokenB
* Spot Price

---