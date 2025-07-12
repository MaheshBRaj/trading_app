import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:paywize_task/feature/dashboard/data/models/payment_model.dart';
import 'package:paywize_task/feature/dashboard/presentation/providers/payout_provider.dart';
import 'package:provider/provider.dart';

class PayoutHistoryScreen extends StatefulWidget {
  const PayoutHistoryScreen({super.key});

  @override
  _PayoutHistoryScreenState createState() => _PayoutHistoryScreenState();
}

class _PayoutHistoryScreenState extends State<PayoutHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PayoutProvider>(context, listen: false).loadPayouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payout History'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Consumer<PayoutProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.payouts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  Gap(15),
                  Text(
                    'No payout history found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Gap(8),
                  Text(
                    'Your payout requests will appear here',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: provider.payouts.length,
            itemBuilder: (context, index) {
              final payout = provider.payouts[index];
              return _buildPayoutCard(payout);
            },
          );
        },
      ),
    );
  }

  Widget _buildPayoutCard(Payout payout) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade800,
          child: Icon(Icons.send, color: Colors.white),
        ),
        title: Text(
          payout.beneficiaryName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatter.format(payout.amount),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
            Gap(4),
            Text(
              dateFormatter.format(payout.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Account Number', payout.accountNumber),
                _buildDetailRow('IFSC Code', payout.ifsc),
                _buildDetailRow('Amount', formatter.format(payout.amount)),
                _buildDetailRow(
                  'Created At',
                  dateFormatter.format(payout.createdAt),
                ),
                _buildDetailRow('Payout ID', payout.id),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
