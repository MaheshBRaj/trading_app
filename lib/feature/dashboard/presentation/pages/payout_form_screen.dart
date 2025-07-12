import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:paywize_task/feature/dashboard/data/models/payment_model.dart';
import 'package:paywize_task/feature/dashboard/presentation/providers/payout_provider.dart';
import 'package:paywize_task/feature/dashboard/presentation/widgets/success_dialog.dart';
import 'package:provider/provider.dart';

class PayoutFormScreen extends StatefulWidget {
  const PayoutFormScreen({super.key});

  @override
  _PayoutFormScreenState createState() => _PayoutFormScreenState();
}

class _PayoutFormScreenState extends State<PayoutFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _beneficiaryNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _beneficiaryNameController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Payout'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Payout Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Gap(24),
              _buildTextField(
                controller: _beneficiaryNameController,
                label: 'Beneficiary Name',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter beneficiary name';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              Gap(16),
              _buildTextField(
                controller: _accountNumberController,
                label: 'Account Number',
                icon: Icons.account_balance,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter account number';
                  }
                  if (value.trim().length < 9 || value.trim().length > 18) {
                    return 'Account number must be between 9-18 digits';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                    return 'Account number must contain only digits';
                  }
                  return null;
                },
              ),
              Gap(16),
              _buildTextField(
                controller: _ifscController,
                label: 'IFSC Code',
                icon: Icons.code,
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter IFSC code';
                  }
                  if (!RegExp(
                    r'^[A-Z]{4}0[A-Z0-9]{6}$',
                  ).hasMatch(value.trim())) {
                    return 'Please enter valid IFSC code (e.g., SBIN0123456)';
                  }
                  return null;
                },
              ),
              Gap(15),
              _buildTextField(
                controller: _amountController,
                label: 'Amount (₹)',
                icon: Icons.currency_rupee,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter amount';
                  }
                  final amount = double.tryParse(value.trim());
                  if (amount == null) {
                    return 'Please enter valid amount';
                  }
                  if (amount <= 10) {
                    return 'Amount must be greater than ₹10';
                  }
                  if (amount >= 100000) {
                    return 'Amount must be less than ₹1,00,000';
                  }
                  return null;
                },
              ),
              Gap(25),
              Consumer<PayoutProvider>(
                builder: (context, provider, child) {
                  return ElevatedButton(
                    onPressed: provider.isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        provider.isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Submit ', style: TextStyle(fontSize: 16)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
        errorMaxLines: 2,
      ),
      validator: validator,
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final payout = Payout(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          beneficiaryName: _beneficiaryNameController.text.trim(),
          accountNumber: _accountNumberController.text.trim(),
          ifsc: _ifscController.text.trim().toUpperCase(),
          amount: double.parse(_amountController.text.trim()),
          createdAt: DateTime.now(),
        );

        await Provider.of<PayoutProvider>(
          context,
          listen: false,
        ).savePayout(payout);

        //Showing Success Dialog

        showDialog(context: context, builder: (context) => SuccessDialog());

        // Clear form
        _formKey.currentState!.reset();
        _beneficiaryNameController.clear();
        _accountNumberController.clear();
        _ifscController.clear();
        _amountController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting payout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
