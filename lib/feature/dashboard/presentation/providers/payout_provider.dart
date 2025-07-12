import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:paywize_task/feature/dashboard/data/models/payment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayoutProvider extends ChangeNotifier {
  List<Payout> _payouts = [];
  bool _isLoading = false;

  List<Payout> get payouts => _payouts;
  bool get isLoading => _isLoading;

  Future<void> savePayout(Payout payout) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _payouts.add(payout);
      
      final payoutJsonList = _payouts.map((p) => p.toJson()).toList();
      await prefs.setString('payouts', jsonEncode(payoutJsonList));
    } catch (e) {
      throw Exception('Failed to save payout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPayouts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final payoutString = prefs.getString('payouts');
      
      if (payoutString != null) {
        final payoutJsonList = jsonDecode(payoutString) as List;
        _payouts = payoutJsonList.map((json) => Payout.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading payouts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
