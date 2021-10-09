# Compound Interest Calculator Functions
This package allows you to easily perform financial computations related
to compound interest. This package will help you determine future value,
principle value, interest rates, compounding periods, and additional
contributions.

## Usage
```dart
  double principal = 15;
  double contributions = 15000;
  double interestRate = 0.08;
  double compoundingsPerYear = 1;
  double years = 30;
  // 1699248.17
  double fv = CompoundInterest.futureValue(
      contribution: contributions,
      interestRate: interestRate,
      compoundsPerPeriod: compoundingsPerYear,
      periods: years);

  // 15000
  double contributionsRequired = CompoundInterest.contributions(
      compoundsPerPeriod: compoundingsPerYear,
      futureValue: fv,
      interestRate: interestRate,
      periods: years,
      principal: 0);

  // 0.07998
  double overallRate = CompoundInterest.interestRate(
      contributions: contributions,
      futureValue: fv,
      compoundsPerPeriod: compoundingsPerYear,
      periods: years);


  double fvWithPrincipal = CompoundInterest.futureValue(
      compoundsPerPeriod: compoundingsPerYear,
      contribution: contributions,
      interestRate: interestRate,
      periods: years,
      principal: principal);

  // 15
  double calculatedPrincipal = CompoundInterest.principal(
      compoundsPerPeriod: compoundingsPerYear,
      contribution: contributions,
      futureValue: fvWithPrincipal,
      interestRate: interestRate,
      periods: years);

  // 30
  double calculatedPeriods = CompoundInterest.periods(
      compoundsPerPeriod: compoundingsPerYear,
      contribution: contributions,
      futureValue: fv,
      interestRate: interestRate);
```