import 'package:flutter/material.dart';

class SortBottomSheet extends StatelessWidget {
  final Function(String) onSort;
  final String? currentSortOption;

  const SortBottomSheet({Key? key, required this.onSort, this.currentSortOption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Sort By:'),
            dense: true,
          ),
          RadioListTile(
            title: Text('Low Price to High'),
            value: 'low_to_high',
            groupValue: currentSortOption ?? '', // Provide a default value if currentSortOption is null
            onChanged: (value) {
              onSort(value.toString());
              Navigator.pop(context);
            },
          ),
          RadioListTile(
            title: Text('High Price to Low'),
            value: 'high_to_low',
            groupValue: currentSortOption ?? '', // Provide a default value if currentSortOption is null
            onChanged: (value) {
              onSort(value.toString());
              Navigator.pop(context);
            },
          ),
          RadioListTile(
            title: Text('Clear Sorting'),
            value: 'clear_sorting',
            groupValue: currentSortOption ?? '', // Provide a default value if currentSortOption is null
            onChanged: (value) {
              onSort(value.toString()); // Notify the parent widget about the selection
              Navigator.pop(context); // Close the bottom sheet
            },
          ),
        ],
      ),
    );
  }
}
