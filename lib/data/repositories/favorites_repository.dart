import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  static const _key = 'shoply_favorite_ids';

  Future<Set<String>> loadIds() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_key) ?? const <String>[];
    return stored.toSet();
  }

  Future<void> saveIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
  }
}
