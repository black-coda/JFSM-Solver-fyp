extension IntValidator on String {
  bool isInt() {
    return int.tryParse(this) != null;
  }

   Function isInteger({String ? errorText}) => () => this == ""
      ? null
      : int.tryParse(this) == null
          ? errorText ?? "invalid integer"
          : null;

  Function isAnInteger({String ? errorText}){
    return () => this == ""
      ? "Value cannot be empty"
      : int.tryParse(this);
  }
}