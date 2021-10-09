import 'package:ProjectName/src/compound_interest.dart';

main(List<String> args) {
  double principal = 15;
  double contributions = 15000;
  double interestRate = 0.08;
  double compoundingsPerYear = 1;
  double years = 30;
  double fv = CompoundInterest.futureValue(
      contribution: contributions,
      interestRate: interestRate,
      compoundsPerPeriod: compoundingsPerYear,
      periods: years);

  double contributionsRequired = CompoundInterest.contributions(
      compoundsPerPeriod: compoundingsPerYear,
      futureValue: fv,
      interestRate: interestRate,
      periods: years,
      principal: 0);

  double fvPrincipalOnly = CompoundInterest.futureValue(
      principal: contributions,
      compoundsPerPeriod: compoundingsPerYear,
      interestRate: interestRate,
      periods: years);

  double principalRate = CompoundInterest.interestRate(
      principal: contributions,
      futureValue: fvPrincipalOnly,
      compoundsPerPeriod: compoundingsPerYear,
      periods: years);

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

  double calculatedPrincipal = CompoundInterest.principal(
      compoundsPerPeriod: compoundingsPerYear,
      contribution: contributions,
      futureValue: fvWithPrincipal,
      interestRate: interestRate,
      periods: years);

  double calculatedPeriods = CompoundInterest.periods(
      compoundsPerPeriod: compoundingsPerYear,
      contribution: contributions,
      futureValue: fv,
      interestRate: interestRate);

  print("Contributions per period:$contributions");
  print("Interest rate: $interestRate");
  print("Compoundings per year: $compoundingsPerYear");
  print("Number of years: $years");
  print("Calculated future value: $fv");
  print("Calculated contributions: $contributionsRequired");
  print("Calculated rate (no contributions): $principalRate");
  print("Calculated rate: $overallRate");
  print("Calculated principal: $calculatedPrincipal");
  print("Calculated periods: $calculatedPeriods");
}
