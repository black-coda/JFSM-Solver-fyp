/// Abstract class representing a solver for linear multistep numerical methods.
///
/// Linear multistep methods are used for solving ordinary differential equations
/// (ODEs) numerically by considering a sequence of previously computed points.
/// This abstract class defines methods for both explicit and implicit linear
/// multistep solvers.
abstract class LinearMultistepSolver {
  /// Computes the solution using an explicit linear multistep method.
  ///
  /// An explicit linear multistep method uses only previously computed points
  /// to approximate the solution at the next step. This method provides a
  /// numerical solution for the given ordinary differential equation (ODE)
  /// using the specified parameters.
  ///
  /// - [stepNumber]: The number of steps in the method (e.g., 1 for single-step,
  ///                 2 for two-step method).
  /// - [alpha]: Coefficients of the terms involving previous function values.
  /// - [beta]: Coefficients of the terms involving function values at the current
  ///            and previous steps.
  /// - [func]: A function representing the ordinary differential equation (ODE)
  ///           to be solved. It takes the initial values of the independent
  ///           variables as input and returns the derivative at that point.
  /// - [y0]: Initial value of the dependent variable (e.g., y(x0)).
  /// - [x0]: Initial value of the independent variable.
  /// - [stepSize]: Size of the step used in the method.
  /// - [N]: Number of points to be computed.
  ///
  /// Returns a list of computed values representing the approximate solution
  /// at each step.
  List<double> explicitLinearMultistepMethod({
    required int stepNumber,
    required List<double> alpha,
    required List<double> beta,
    required double Function(double initialValueX, double initialValueY) func,
    required double y0,
    required double x0,
    required double stepSize,
    required int N,
  });

  /// Computes the solution using an implicit linear multistep method.
  ///
  /// An implicit linear multistep method involves solving equations at each
  /// step, which may require iteration or numerical methods. This method
  /// provides a numerical solution for the given ordinary differential
  /// equation (ODE) using the specified parameters.
  ///
  /// Returns a list of computed values representing the approximate solution
  /// at each step.
  List<double> implicitLinearMultistepMethod({
    required int stepNumber,
    required List<double> alpha,
    required List<double> beta,
    required double Function(double initialValueX, double initialValueY) func,
    required double y0,
    required double x0,
    required double stepSize,
    required int N,
  });
}
