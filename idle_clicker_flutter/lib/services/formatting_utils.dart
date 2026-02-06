class FormattingUtils {
  static String formatNumber(double value) {
    if (value < 0) return '-${formatNumber(-value)}';

    if (value < 1000) {
      if (value == value.floorToDouble()) {
        return value.toInt().toString();
      }
      return value.toStringAsFixed(1);
    }

    final suffixes = [
      (1e24, 'Sep'),
      (1e21, 'Sxt'),
      (1e18, 'Qnt'),
      (1e15, 'Qdr'),
      (1e12, 'T'),
      (1e9, 'B'),
      (1e6, 'M'),
      (1e3, 'K'),
    ];

    for (final (threshold, suffix) in suffixes) {
      if (value >= threshold) {
        final formatted = value / threshold;
        if (formatted >= 100) return '${formatted.toInt()}$suffix';
        if (formatted >= 10) return '${formatted.toStringAsFixed(1)}$suffix';
        return '${formatted.toStringAsFixed(2)}$suffix';
      }
    }

    return value.toInt().toString();
  }

  static String formatTime(int seconds) {
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      return '${minutes}m ${secs}s';
    }
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }
}
