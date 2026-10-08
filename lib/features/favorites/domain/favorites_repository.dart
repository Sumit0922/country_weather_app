abstract interface class FavoritesRepository {
  Set<String> readFavorites();
  Future<void> saveFavorites(Set<String> countryCodes);
}