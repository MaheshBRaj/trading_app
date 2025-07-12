import 'package:flutter/material.dart';
import 'package:paywize_task/feature/dashboard/data/models/transaction_model.dart';
import 'package:paywize_task/feature/dashboard/domain/services/services.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];
  bool _isLoading = false;
  String _error = '';

  String _selectedStatus = 'All';
  DateTimeRange? _selectedDateRange;

  final ApiService _apiService = ApiService();

  List<Transaction> get transactions => _filteredTransactions;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get selectedStatus => _selectedStatus;
  DateTimeRange? get selectedDateRange => _selectedDateRange;

  Future<void> fetchTransactions() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _transactions = await _apiService.fetchTransactions();
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// for filtering  data by status 
  void filterByStatus(String status) {
    _selectedStatus = status;
    _applyFilters();
  }

// For Filtering the data Daterange
  void filterByDateRange(DateTimeRange? dateRange) {
    _selectedDateRange = dateRange;
    _applyFilters();
  }


//Applying filter  
  void _applyFilters() {
    _filteredTransactions =
        _transactions.where((transaction) {
    
          if (_selectedStatus != 'All' &&
              transaction.status != _selectedStatus) {
            return false;
          }

        
          if (_selectedDateRange != null) {
            final transactionDate = DateTime(
              transaction.date.year,
              transaction.date.month,
              transaction.date.day,
            );
            final startDate = DateTime(
              _selectedDateRange!.start.year,
              _selectedDateRange!.start.month,
              _selectedDateRange!.start.day,
            );
            final endDate = DateTime(
              _selectedDateRange!.end.year,
              _selectedDateRange!.end.month,
              _selectedDateRange!.end.day,
            );

            if (transactionDate.isBefore(startDate) ||
                transactionDate.isAfter(endDate)) {
              return false;
            }
          }

          return true;
        }).toList();

    notifyListeners();
  }

  void clearFilters() {
    _selectedStatus = 'All';
    _selectedDateRange = null;
    _applyFilters();
  }
}
