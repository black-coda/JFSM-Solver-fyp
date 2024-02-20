extension Factorial on int{
  double factorial() {
    double result = 1;
    for (int i = 2; i <= this; i++) {
      result *= i;
    }
    return result;
  }
}