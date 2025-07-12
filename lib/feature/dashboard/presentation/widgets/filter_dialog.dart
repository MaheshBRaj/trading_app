import 'package:flutter/material.dart';
import 'package:paywize_task/feature/dashboard/presentation/providers/transaction_provider.dart';
import 'package:provider/provider.dart';


class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String _selectedStatus = 'All';
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    _selectedStatus = provider.selectedStatus;
    _selectedDateRange = provider.selectedDateRange;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Transactions'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: _selectedStatus,
            isExpanded: true,
            items:
                ['All', 'Completed', 'Pending', 'Failed'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
              });
            },
          ),
          SizedBox(height: 16),
          Text('Date Range:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final dateRange = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDateRange: _selectedDateRange,
                    );
                    if (dateRange != null) {
                      setState(() {
                        _selectedDateRange = dateRange;
                      });
                    }
                  },
                  child: Text(
                    _selectedDateRange == null
                        ? 'Select Date Range'
                        : 'Date Range Selected',
                  ),
                ),
              ),
              if (_selectedDateRange != null)
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _selectedDateRange = null;
                    });
                  },
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final provider = Provider.of<TransactionProvider>(
              context,
              listen: false,
            );
            provider.filterByStatus(_selectedStatus);
            provider.filterByDateRange(_selectedDateRange);
            Navigator.pop(context);
          },
          child: Text('Apply'),
        ),
      ],
    );
  }
}
