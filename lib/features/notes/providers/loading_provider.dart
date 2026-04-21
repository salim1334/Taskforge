import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> runWithLoading(Future<void> Function() task) async {
    _isLoading = true;
    notifyListeners();

    await task();

    _isLoading = false;
    notifyListeners();
  }
}