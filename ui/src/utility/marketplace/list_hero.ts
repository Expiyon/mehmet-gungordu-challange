import { Transaction } from "@mysten/sui/transactions";

export const listHero = (
  packageId: string,
  heroId: string,
  priceInSui: string,
) => {
  const tx = new Transaction();

  // Convert SUI to MIST (1 SUI = 1,000,000,000 MIST)
  const priceInMist = BigInt(Number(priceInSui) * 1_000_000_000);

  // Add moveCall to list a hero for sale
  tx.moveCall({
    target: `${packageId}::marketplace::list_hero`,
    arguments: [
      tx.object(heroId),
      tx.pure.u64(priceInMist)
    ],
  });

  return tx;
};
