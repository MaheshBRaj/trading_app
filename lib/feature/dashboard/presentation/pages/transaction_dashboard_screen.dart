import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:paywize_task/feature/dashboard/data/models/transaction_model.dart';
import 'package:paywize_task/feature/dashboard/presentation/pages/transaction_detail_screen.dart';
import 'package:paywize_task/feature/dashboard/presentation/providers/transaction_provider.dart';
import 'package:paywize_task/feature/dashboard/presentation/widgets/filter_dialog.dart';
import 'package:provider/provider.dart';

class TransactionDashboardScreen extends StatefulWidget {
  const TransactionDashboardScreen({super.key});

  @override
  _TransactionDashboardScreenState createState() =>
      _TransactionDashboardScreenState();
}

class _TransactionDashboardScreenState
    extends State<TransactionDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Dashboard'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  Gap(15),
                  Text(provider.error),
                  Gap(15),
                  ElevatedButton(
                    onPressed: () => provider.fetchTransactions(),
                    child: Text(
                      'Retry',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            );
          }

          if (provider.transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
             
                  Text(
                    'No transactions found',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildFilterChips(provider),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = provider.transactions[index];
                    return _buildTransactionCard(context, transaction);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(TransactionProvider provider) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        children: [
          if (provider.selectedStatus != 'All')
            Chip(
              label: Text('Status: ${provider.selectedStatus}'),
              deleteIcon: Icon(Icons.close),
              onDeleted: () => provider.filterByStatus('All'),
            ),
          if (provider.selectedDateRange != null)
            Chip(
              label: Text('Date Range'),
              deleteIcon: Icon(Icons.close),
              onDeleted: () => provider.filterByDateRange(null),
            ),
          if (provider.selectedStatus != 'All' ||
              provider.selectedDateRange != null)
            ActionChip(
              label: Text('Clear All'),
              onPressed: () => provider.clearFilters(),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, Transaction transaction) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          transaction.type == 'Credit' ? Icons.add : Icons.remove,
          color: Colors.black,
        ),
        title: Text(
          formatter.format(transaction.amount),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: transaction.type == 'Credit' ? Colors.green : Colors.red,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.description),
            Gap(5),
            Text(
              dateFormatter.format(transaction.date),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(transaction.status),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                transaction.status,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            Gap(5),
            Text(
              transaction.type,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TransactionDetailScreen(transaction: transaction),
            ),
          );
        },
      ),
    );
  }

  //For getting different color based on the transaction type

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => FilterDialog());
  }
}
