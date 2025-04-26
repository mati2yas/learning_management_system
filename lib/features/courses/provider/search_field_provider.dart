import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchFieldProvider =
    StateNotifierProvider<SearchFieldNotifier, String>((ref) => SearchFieldNotifier());

class SearchFieldNotifier extends StateNotifier<String> {
  SearchFieldNotifier() : super("");

  void changeFieldText(String newText) {
    state = newText;
  }
}
