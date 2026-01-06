import 'package:flutter/material.dart';

class SortBar extends StatelessWidget {
  final bool isDesc;
  final VoidCallback onToggle;

  const SortBar({super.key, required this.isDesc, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        TextButton.icon(
          label: Text(isDesc ? '新しい順' : '古い順'),
          icon: Icon(isDesc ? Icons.arrow_downward : Icons.arrow_upward),
          onPressed: onToggle,
        ),
      ],
    );
  }
}
