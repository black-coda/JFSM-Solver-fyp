class Validator{
  static String? stepNumberValidator(String ? val){
    
    if (val == null || val.isEmpty) {
      return 'Value cannot be empty';
    }

    // Check if the string can be parsed as a number
    try {
      double.parse(val);
    } catch (e) {
      return 'Value must be a number';
    }

    if (int.tryParse(val) == null) return "step must must be a number";

    return null;    
  }

  
}

