
export const createArena = (packageId: string, heroId: string) => {
  // Parametreler kullanılıyor, geçici string döndürülüyor
  // TODO: Gerçek moveCall eklenmeli
  return `${packageId}::arena::create_arena(${heroId})`;
};
