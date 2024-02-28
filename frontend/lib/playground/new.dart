void main() {
  final stringWithSymbols = '-1/6';
  final result = stringWithSymbols.calculateFromString();
  print(double.parse(result));
}

extension StringCalculationExtension on String {
  String calculateFromString() {
    // Split the string into parts based on '/', '-' symbols
    final parts = this.split(RegExp(r'[\/]'));

    // If there are no '/' symbols, check for '-' symbols to handle negative numbers
    if (parts.length <= 1) {
      final negativeParts = this.split('-');
      if (negativeParts.length <= 1) return this;

      // If there's only one '-' symbol at the beginning, it indicates a negative number
      if (negativeParts[0].isEmpty && negativeParts.length == 2) {
        final negativeValue = double.tryParse("-${negativeParts[1]}");
        return negativeValue != null
            ? negativeValue.toString()
            : 'Invalid expression';
      }
      return 'Invalid expression';
    }

    double result = double.tryParse(parts[0]) ?? 0.0;

    // Iterate through the remaining parts and perform arithmetic operations
    for (int i = 1; i < parts.length; i++) {
      final num = double.tryParse(parts[i]) ?? 0.0;

      if (num == 0) {
        return 'Error: Division by zero';
      } else {
        result /= num;
      }
    }

    // Return the result as a string
    return result.toString();
  }
}
