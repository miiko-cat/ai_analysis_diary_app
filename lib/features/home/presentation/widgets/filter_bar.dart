import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final String? selectedSentiment;
  final ValueChanged<String?> onChanged;

  const FilterBar({
    super.key,
    required this.selectedSentiment,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 8,
          children: [
            _chip('😊 ポジティブ', 'positive'),
            _chip('😐 ニュートラル', 'neutral'),
            _chip('😞 ネガティブ', 'negative'),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: selectedSentiment == value,
      onSelected: (selected) {
        onChanged(selected ? value : null);
      },
    );
  }
}
