import 'package:flutter/material.dart';

enum Sentiment {
  positive,
  negative,
  neutral;

  static Sentiment? fromString(String? value) {
    switch (value) {
      case 'positive':
        return Sentiment.positive;
      case 'negative':
        return Sentiment.negative;
      case 'neutral':
        return Sentiment.neutral;
      default:
        return null;
    }
  }
}

extension SentimentUI on Sentiment? {
  // 感情によって絵文字を使い分ける
  IconData get icon {
    switch (this) {
      case Sentiment.positive:
        return Icons.sentiment_satisfied;
      case Sentiment.negative:
        return Icons.sentiment_dissatisfied;
      case Sentiment.neutral:
        return Icons.sentiment_neutral;
      default:
        return Icons.help_outline;
    }
  }

  // 感情によって色を使い分ける
  Color get color {
    switch (this) {
      case Sentiment.positive:
        return Colors.green;
      case Sentiment.negative:
        return Colors.red;
      case Sentiment.neutral:
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  // Chip化
  Widget get chip {
    final text = this?.name ?? '-';
    final c = color;
    return Chip(
      label: Text(text),
      backgroundColor: c.withValues(alpha: 0.15),
      labelStyle: TextStyle(color: c),
    );
  }
}