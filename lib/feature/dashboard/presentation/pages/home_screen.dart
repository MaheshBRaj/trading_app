import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:paywize_task/feature/dashboard/presentation/pages/payment_history_screen.dart';
import 'package:paywize_task/feature/dashboard/presentation/pages/payout_form_screen.dart';
import 'package:paywize_task/feature/dashboard/presentation/pages/transaction_dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paywize Dashboard'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to Fintech Dashboard',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(20),
            _buildMenuCard(
              context,
              'Transaction Dashboard',

              Icons.account_balance_wallet,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TransactionDashboardScreen()),
              ),
            ),
            Gap(15),
            _buildMenuCard(
              context,
              'Create Payout',

              Icons.send,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PayoutFormScreen()),
              ),
            ),
            Gap(15),
            _buildMenuCard(
              context,
              'Payout History',

              Icons.history,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PayoutHistoryScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,

    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 22, color: Colors.blue.shade400),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),

        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
