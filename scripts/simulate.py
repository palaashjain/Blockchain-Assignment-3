import random
import matplotlib.pyplot as plt
import numpy as np

N = 80

reserveA = 1000
reserveB = 1000

price_history = []
tvl_history = []
slippage_history = []
fees_collected = 0

print("Starting simulation...\n")

for i in range(N):
    action = random.choice(["swap", "deposit", "withdraw"])

    if action == "swap":
        dx = random.uniform(1, reserveA * 0.1)

        expected_price = reserveB / reserveA

        dx_after_fee = dx * 0.997
        dy = (dx_after_fee * reserveB) / (reserveA + dx_after_fee)

        actual_price = dy / dx

        slippage = (actual_price - expected_price) / expected_price * 100
        slippage_history.append(slippage)

        fees_collected += dx * 0.003

        reserveA += dx
        reserveB -= dy

        print(f"[Swap] A in: {dx:.2f}, B out: {dy:.2f}")

    elif action == "deposit":
        ratio = reserveB / reserveA
        dx = random.uniform(10, 50)
        dy = dx * ratio

        reserveA += dx
        reserveB += dy

        print(f"[Deposit] A: {dx:.2f}, B: {dy:.2f}")

    elif action == "withdraw":
        dx = random.uniform(10, 50)
        dy = dx * (reserveB / reserveA)

        reserveA -= dx
        reserveB -= dy

        print(f"[Withdraw] A: {dx:.2f}, B: {dy:.2f}")

    price = reserveB / reserveA
    tvl = reserveA + reserveB

    price_history.append(price)
    tvl_history.append(tvl)

# =========================
# PLOTS
# =========================

plt.plot(price_history)
plt.title("Price vs Time")
plt.xlabel("Steps")
plt.ylabel("Price")
plt.show()

plt.plot(tvl_history)
plt.title("TVL vs Time")
plt.xlabel("Steps")
plt.ylabel("Total Value")
plt.show()

plt.plot(slippage_history)
plt.title("Slippage vs Time")
plt.xlabel("Swap Events")
plt.ylabel("Slippage (%)")
plt.show()

fractions = np.linspace(0.01, 0.5, 50)
slippage_vals = []

reserveA = 1000
reserveB = 1000

for f in fractions:
    dx = f * reserveA

    expected_price = reserveB / reserveA

    dx_fee = dx * 0.997
    dy = (dx_fee * reserveB) / (reserveA + dx_fee)

    actual_price = dy / dx

    slippage = (actual_price - expected_price) / expected_price * 100
    slippage_vals.append(slippage)

plt.plot(fractions, slippage_vals)
plt.title("Slippage vs Trade Lot Fraction")
plt.xlabel("Trade Fraction")
plt.ylabel("Slippage (%)")
plt.show()

print("\n--- Simulation Summary ---")
print(f"Final Reserves: A={reserveA:.2f}, B={reserveB:.2f}")
print(f"Total Fees Collected: {fees_collected:.2f}")