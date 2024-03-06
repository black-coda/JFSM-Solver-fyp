abstract class LinearMultistepSolver {
  List<double> explicitLinearMultistepMethod(
    int stepNumber,
    List<double> alpha,
    List<double> beta,
    double Function(double initialValueX, double initialValueY) func,
    double y0,
    double x0,
    double stepSize,
    int N,
  );
  List<double> implicitLinearMultistepMethod();
}
