import 'dart:math';

class CompoundInterest {
  static double _getSimpleRateMultiplier(
      {double interestRate: 0,
      double compoundsPerPeriod: 1,
      double periods: 1}) {
    if (interestRate == 0 || compoundsPerPeriod == 0 || periods == 0) {
      return 1;
    }

    double rate = (1 + interestRate / compoundsPerPeriod);
    double simpleMultiplier = pow(rate, compoundsPerPeriod * periods);
    return simpleMultiplier;
  }

  static double _getContributionMultiplier(
      {double interestRate: 0,
      double compoundsPerPeriod: 1,
      double periods: 1}) {
    if (interestRate == 0 || compoundsPerPeriod == 0 || periods == 0) {
      return 1;
    }

    double simpleMultiplier = _getSimpleRateMultiplier(
        interestRate: interestRate,
        compoundsPerPeriod: compoundsPerPeriod,
        periods: periods);
    double effectiveMultiplier =
        (simpleMultiplier - 1) / (interestRate / compoundsPerPeriod);

    return effectiveMultiplier;
  }

  static double _interestRatePrincipalOnly(
      {double principal: 0,
      double futureValue: 0,
      double compoundsPerPeriod: 1,
      double periods: 1}) {
    if (interestRate == 0 || compoundsPerPeriod == 0 || periods == 0) {
      return principal;
    }

    double div = futureValue / principal;
    double root = pow(div, 1 / (compoundsPerPeriod * periods));
    double sub = root - 1;
    return sub * compoundsPerPeriod;
  }

  /// Calculates the future value of a principal balance without any additional
  /// contributions.
  static double _principalFutureValue({
    double principal: 0,
    double interestRate: 0,
    double compoundsPerPeriod: 1,
    double periods: 1,
  }) {
    // If any of these are 0, the reuslt will be the principal balance.
    // This also saves a divide by 0 error.
    // And it's prudent to double check your input.
    if (compoundsPerPeriod == 0 || periods == 0 || interestRate == 0) {
      return principal;
    } else {
      double simpleMultiplier = _getSimpleRateMultiplier(
          interestRate: interestRate,
          compoundsPerPeriod: compoundsPerPeriod,
          periods: periods);
      return principal * simpleMultiplier;
    }
  }

  /// Calculates the future value of contributions made over time.
  static double _contributionFutureValue({
    double contribution: 0,
    double interestRate: 0,
    double compoundsPerPeriod: 1,
    double periods: 1,
  }) {
    // If there are no compounding periods, the result is simply the contribution.
    if (periods == 0) {
      return contribution;
    }

    // If compoundsPerPeriod is 0, or the rate is 0, then interest does not
    // apply to the contributions and the result is just contributions saved
    // over time.
    if (compoundsPerPeriod == 0 || interestRate == 0) {
      return contribution * periods;
    }

    double effectiveMultiplier = _getContributionMultiplier(
        interestRate: interestRate,
        compoundsPerPeriod: compoundsPerPeriod,
        periods: periods);
    return contribution * effectiveMultiplier;
  }

  /// Rounds the given [value] to [places] decimal places
  static double _roundToDecimalPlaces(value, places) {
    var multipler = pow(10, places);
    double multipliedValue = value * multipler;
    double rounded = multipliedValue.roundToDouble();
    return rounded / multipler;
  }

  /// Calculates the future value given the principal balance, contributions,
  /// interest rate, compoundings per period, and number of periods.
  static double futureValue(
      {double principal: 0,
      double contribution: 0,
      double interestRate: 0,
      double compoundsPerPeriod: 1,
      double periods: 1}) {
    double principalGains = _principalFutureValue(
        principal: principal,
        interestRate: interestRate,
        compoundsPerPeriod: compoundsPerPeriod,
        periods: periods);

    double contributionGains = _contributionFutureValue(
        contribution: contribution,
        interestRate: interestRate,
        compoundsPerPeriod: compoundsPerPeriod,
        periods: periods);

    var result = principalGains + contributionGains;
    return _roundToDecimalPlaces(result, 2);
  }

  static double contributions(
      {double principal: 0,
      double futureValue: 0,
      double interestRate: 0,
      double compoundsPerPeriod: 1,
      double periods: 1}) {
    double principalGains = _principalFutureValue(
        principal: principal,
        interestRate: interestRate,
        compoundsPerPeriod: compoundsPerPeriod,
        periods: periods);
    double numerator = futureValue - principalGains;
    double denominator = _getContributionMultiplier(
        interestRate: interestRate,
        compoundsPerPeriod: compoundsPerPeriod,
        periods: periods);
    double result = numerator / denominator;

    return _roundToDecimalPlaces(result, 2);
  }

  static double _abs(value) {
    if (value < 0) {
      return value * -1;
    }
    return value;
  }

  static double _absErrorRate(result, base) {
    double errorPercent = (result - base) / base;
    return _abs(errorPercent);
  }

  /// Calculates the interest rate required for the given principal, contributions,
  /// and future value. Note: This is computationally heavy if principal and
  /// contributions are both non-zero.
  static double interestRate(
      {double principal: 0,
      double contributions: 0,
      double futureValue: 0,
      double compoundsPerPeriod: 1,
      double periods: 1}) {
    // I apparently don't know enough algebra to solve for the interest rate
    // in the formula: fv = P*(1 + (r/n)^(nt)) + PMT*(((1 + (r/n)^(nt)-1)/(r/n))
    // If you are reading this and you can solve for r, please let me know.

    // If there are no contributions, this is easy to solve algebraically.
    if (contributions == 0 && principal != 0) {
      return _interestRatePrincipalOnly(
          principal: principal,
          futureValue: futureValue,
          compoundsPerPeriod: compoundsPerPeriod,
          periods: periods);
    }

    // If principal and all contributions is greater than the future value,
    // then the rate is negative.
    bool interestAccrued =
        ((principal + (contributions * periods)) - futureValue) < 0;

    // Otherwise, perform a computational search on the interest rate to find it.
    double rate = interestAccrued ? .10 : -.10; // Start with 10% rate.
    // Set min and max rates. If interest is accrued, then the rate is between 0 and 100%
    // if interest was not accrued, then rate is negative, so rate is -100 to 0
    double maxRate = interestAccrued ? 1 : 0;
    double minRate = interestAccrued ? 0 : -1;
    double calculatedFutureValue = 0;
    double errorRate = .0005; // Get within 1% error rate to ensure accuracy
    while (true) {
      calculatedFutureValue = CompoundInterest.futureValue(
          principal: principal,
          compoundsPerPeriod: compoundsPerPeriod,
          periods: periods,
          contribution: contributions,
          interestRate: rate);
      if (_absErrorRate(calculatedFutureValue, futureValue) < errorRate) {
        return rate;
      }
      // if rate is too high, then reduce it.
      if (calculatedFutureValue > futureValue) {
        maxRate = rate;
        rate = (minRate + rate) / 2;
      } else {
        // if rate is too low, then raise it.
        minRate = rate;
        rate = (maxRate + rate) / 2;
      }
    }
  }

  static double principal(
      {double futureValue: 0,
      double contribution: 0,
      double interestRate: 0,
      double compoundsPerPeriod: 1,
      double periods: 1}) {
    double contributionGains = _contributionFutureValue(
        contribution: contribution,
        compoundsPerPeriod: compoundsPerPeriod,
        interestRate: interestRate,
        periods: periods);
    double remaining = futureValue - contributionGains;
    double simpleMultiplier = _getSimpleRateMultiplier(
        compoundsPerPeriod: compoundsPerPeriod,
        interestRate: interestRate,
        periods: periods);
    double result = remaining / simpleMultiplier;
    return _roundToDecimalPlaces(result, 2);
  }

  static double periods(
      {double principal: 0,
      double contribution: 0,
      double interestRate: 0,
      double compoundsPerPeriod: 1,
      double futureValue: 1}) {
    // This is another calculation one. though there is really no upper
    // bound on time so to make a binary search work we'll set an upper limit
    // of 1,000,000 periods.
    // We'll start with 40 periods. Assuming that most use cases will assume
    // that a period is 1 year, and most of these use cases are around retirement,
    // which is about 20-40 years out for most people that care.
    double periods = 40;
    double maxPeriods = 1000000;
    double minPeriods = 0;
    double calculatedFutureValue = 0;
    double errorRate = .0005; // Get within 1% error rate to ensure accuracy
    while (true) {
      calculatedFutureValue = CompoundInterest.futureValue(
          principal: principal,
          compoundsPerPeriod: compoundsPerPeriod,
          periods: periods,
          contribution: contribution,
          interestRate: interestRate);
      if (_absErrorRate(calculatedFutureValue, futureValue) < errorRate) {
        return periods;
      }
      // if rate is too high, then reduce it.
      if (calculatedFutureValue > futureValue) {
        maxPeriods = periods;
        periods = (minPeriods + periods) / 2;
      } else {
        // if rate is too low, then raise it.
        minPeriods = periods;
        periods = (maxPeriods + periods) / 2;
      }
    }
  }
}
