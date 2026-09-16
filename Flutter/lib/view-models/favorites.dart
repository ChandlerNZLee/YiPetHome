// lib/view-models/favorites.dart

enum FavoriteCategory {
  all,
  petFood,
  snacks,
  toyBowl,
  clothesNook,
  dailyNecessities,
  healthMedicine,
}

extension FavoriteCategoryExtension on FavoriteCategory {
  String get label {
    switch (this) {
      case FavoriteCategory.all:
        return 'All';
      case FavoriteCategory.petFood:
        return 'Pet Food';
      case FavoriteCategory.snacks:
        return 'Snacks';
      case FavoriteCategory.toyBowl:
        return 'Toy & Bowl';
      case FavoriteCategory.clothesNook:
        return 'Clothes & Nook';
      case FavoriteCategory.dailyNecessities:
        return 'Daily Necessities';
      case FavoriteCategory.healthMedicine:
        return 'Health & Medicine';
    }
  }
}

enum FavoriteSort { newest, oldest, priceLow, priceHigh }

extension FavoriteSortExtension on FavoriteSort {
  String get label {
    switch (this) {
      case FavoriteSort.newest:
        return 'Newest first';
      case FavoriteSort.oldest:
        return 'Oldest first';
      case FavoriteSort.priceLow:
        return 'Price low to high';
      case FavoriteSort.priceHigh:
        return 'Price high to low';
    }
  }
}

enum FavoriteViewMode { grid, list }
