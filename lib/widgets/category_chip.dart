import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String categoryName;
  final bool isSelected;
  final Function() onSelected;

  CategoryChip({
    required this.categoryName,
    this.isSelected = false,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          categoryName,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
