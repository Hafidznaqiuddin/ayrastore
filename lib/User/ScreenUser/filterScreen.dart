import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> categories;
  final List<String> brands;
  final String selectedCategory;
  final String selectedBrand;
  final String minPrice;
  final String maxPrice;
  final Function(String, String, String, String) onApplyFilter;

  FilterBottomSheet({
    required this.categories,
    required this.brands,
    required this.selectedCategory,
    required this.selectedBrand,
    required this.minPrice,
    required this.maxPrice,
    required this.onApplyFilter,
  });

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String selectedCategory;
  late String selectedBrand;
  late String minPrice;
  late String maxPrice;
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(symbol: '');
  late TextEditingController controller;
  late TextEditingController controller1;


  @override
  void initState() {
    super.initState();
    // Initialize state variables with props
    selectedCategory = widget.selectedCategory;
    selectedBrand = widget.selectedBrand;
    minPrice = widget.minPrice;
    maxPrice = widget.maxPrice;
    controller1 = TextEditingController(text: maxPrice);
    controller = TextEditingController(text: minPrice);

  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = kToolbarHeight;
    return Container(
      height: screenHeight * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filter Options',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Category',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.deepPurple,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(8.0),
              menuMaxHeight: 200,
              isExpanded: true,
              value: selectedCategory,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                }
              },
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              items: widget.categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Brand',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.deepPurple,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(8.0),
              menuMaxHeight: 200,
              isExpanded: true,
              value: selectedBrand,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedBrand = newValue;
                  });
                }
              },
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              items: widget.brands.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Price Range',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [_formatter],
                  onChanged: (value) {
                    setState(() {
                      minPrice = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Min Price',
                    border: OutlineInputBorder(),
                  ),
                  // Initialize text field value with prop value
                  controller: controller, // Use the controller here
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [_formatter],
                  onChanged: (value) {
                    setState(() {
                      maxPrice = value; // Update the text of the controller
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Max Price',
                    border: OutlineInputBorder(),
                  ),
                  controller: controller1, // Use the controller here
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.onApplyFilter(selectedCategory, selectedBrand, minPrice, maxPrice);
                }, // Apply filter
                child: Text('Filter'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = 'All';
                    selectedBrand = 'All';
                    minPrice = '';
                    maxPrice = '';
                    controller.clear(); // Clear minPrice TextField
                    controller1.clear(); // Clear maxPrice TextField
                  });
                },
                // Reset filter
                child: Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
