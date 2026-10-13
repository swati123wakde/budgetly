/// How often the user's budget resets. Most people match it to their pay cycle.
enum BudgetCycle {
  monthly,
  fortnightly,
  weekly;

  String get label => switch (this) {
    BudgetCycle.monthly => 'Monthly',
    BudgetCycle.fortnightly => 'Fortnightly',
    BudgetCycle.weekly => 'Weekly',
  };

  String get description => switch (this) {
    BudgetCycle.monthly => 'Resets on the same date every month',
    BudgetCycle.fortnightly => 'Resets every two weeks',
    BudgetCycle.weekly => 'Resets every Monday',
  };
}
