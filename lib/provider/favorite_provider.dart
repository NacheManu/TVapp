import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteShowsNotifier extends StateNotifier<List<String>> {
  FavoriteShowsNotifier(this.userId) : super([]);
  final String userId;

  void toggleFavorite(String showTitle) {
    if (state.contains(showTitle)) {
      state = List.from(state)..remove(showTitle);
    } else {
      state = List.from(state)..add(showTitle);
    }
  }
}

final favoriteShowsProvider = StateNotifierProviderFamily<FavoriteShowsNotifier, List<String>, String>((ref, userId) {
  return FavoriteShowsNotifier(userId); 
});