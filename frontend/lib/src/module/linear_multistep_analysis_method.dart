/// Abstract class representing an analysis method for linear multistep numerical methods.
///
/// Linear multistep analysis methods are used to evaluate the properties of
/// numerical methods for solving ordinary differential equations (ODEs). This
/// abstract class defines methods for analyzing the consistency, stability,
/// convergence, order of convergence, and error constant of linear multistep
/// methods.
abstract class LinearMultiStepAnalysisMethod {
  /// Checks whether the linear multistep method is consistent.
  ///
  /// Consistency refers to the property of a numerical method where the
  /// truncation error approaches zero as the step size tends to zero.
  bool isConsistent() {
    // TODO: Implement the consistency check for the linear multi-step method.
    throw UnimplementedError();
  }

  /// Checks whether the linear multistep method is zero-stable.
  ///
  /// Zero stability refers to the property of a numerical method where small
  /// errors in the initial conditions do not lead to significant amplification
  /// of errors in the computed solution.
  bool isZeroStable() {
    // TODO: Implement the zero stability check for the linear multi-step method.
    throw UnimplementedError();
  }

  /// Calculates the order of convergence and error constant of the method.
  ///
  /// The order of convergence represents the rate at which the numerical
  /// solution converges to the exact solution as the step size decreases. The
  /// error constant quantifies the magnitude of the error in the numerical
  /// solution.
  ///
  /// Returns a tuple containing the order of convergence and the error constant.
  (int, double) orderAndErrorConstant() {
    // TODO: Calculate and return the order of convergence and error constant for the linear multi-step method.
    throw UnimplementedError();
  }

  /// Checks whether the linear multistep method is convergent.
  ///
  /// Convergence refers to the property of a numerical method where the
  /// numerical solution approaches the exact solution as the step size tends to zero.
  bool isConvergent() {
    // TODO: Implement the convergence check for the linear multi-step method.
    throw UnimplementedError();
  }
}
