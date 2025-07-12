import 'package:paywize_task/feature/dashboard/data/models/transaction_model.dart';

class ApiService {
  Future<List<Transaction>> fetchTransactions() async {
    try {
      // Giving this show the  dummy data after  few secons seconds
      await Future.delayed(Duration(seconds: 2));

      final mockData = [
        {
          'id': '1',
          'amount': 1500.00,
          'date': '2024-07-10T10:30:00Z',
          'type': 'Credit',
          'status': 'Completed',
          'description': 'Salary payment',
          'reference': 'REF001',
        },
        {
          'id': '2',
          'amount': 250.50,
          'date': '2024-07-09T14:15:00Z',
          'type': 'Debit',
          'status': 'Pending',
          'description': 'Online purchase',
          'reference': 'REF002',
        },
        {
          'id': '3',
          'amount': 3200.00,
          'date': '2024-07-08T09:45:00Z',
          'type': 'Credit',
          'status': 'Completed',
          'description': 'Freelance payment',
          'reference': 'REF003',
        },
      ];

      return mockData.map((json) => Transaction.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }
}
