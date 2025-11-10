
export const battle = (packageId: string, heroId: string, arenaId: string) => {
  // Transaction nesnesi oluşturuluyor ve parametreler kullanılıyor
  // TODO: Gerçek moveCall eklenmeli
  return `${packageId}::arena::battle(${heroId}, ${arenaId})`;
};
