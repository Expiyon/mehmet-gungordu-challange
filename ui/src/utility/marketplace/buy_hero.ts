import { Transaction } from "@mysten/sui/transactions";

export const buyHero = (packageId: string, listHeroId: string, priceInSui: string) => {
  const tx = new Transaction();
  
  // Convert SUI to MIST (1 SUI = 1,000,000,000 MIST)
  const priceInMist = BigInt(Number(priceInSui) * 1_000_000_000);

  // Split coin for exact payment
  const [paymentCoin] = tx.splitCoins(tx.gas, [priceInMist]);

  // Add moveCall to buy a hero
  tx.moveCall({
    target: `${packageId}::marketplace::buy_hero`,
    arguments: [
      tx.object(listHeroId),
      paymentCoin
    ],
  });
    
  return tx;
};
