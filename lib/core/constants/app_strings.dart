abstract final class AppStrings {
  static const String appName = 'Budgetly';
  static const String appVersion = 'v1.0.0';

  // Splash
  static const String splashTagline = 'Every dollar, accounted for.';

  // Welcome
  static const String welcomeOverline = 'PERSONAL FINANCE';
  static const String welcomeTitleLine1 = 'Spend smart.';
  static const String welcomeTitleLine2 = 'Save sharper.';
  static const String welcomeSubtitle =
      'Budgeting that stays out of your way — track, plan and grow without the spreadsheets.';
  static const String getStarted = "Let's get started";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String logIn = 'Log in';

  // Get started
  static const String getStartedTitle = 'How would you like\nto get started?';
  static const String getStartedSubtitle = 'Pick one for now — you can switch any time in settings.';
  static const String continueText = 'Continue';

  // Budget cycle
  static const String budgetCycleTitle = 'How would you like\nto budget?';
  static const String budgetCycleSubtitle = 'Most people match this to their pay cycle.';

  // Budget setup loader
  static String setupLoadingTitle(String cycleLabel) =>
      'Setting up your ${cycleLabel.toLowerCase()} budget';
  static const String setupLoadingSubtitle = 'Creating your categories…';

  // First transaction
  static const String firstTransactionTitle = 'Log your first\ntransaction';
  static const String firstTransactionSubtitle = 'Anything recent. Coffee, groceries, petrol.';
  static const String earnXp = 'Earn 45 XP';
  static const String amount = 'Amount';
  static const String category = 'Category';
  static const String chooseCategory = 'Choose a category';
  static const String save = 'Save';
  static const String skip = 'Skip';
  static const String transactionSaved = 'Transaction saved · +45 XP';

  // Category picker
  static const String categoryHint = "Can't find a category that fits?\nCreate a new one.";
  static const String newCategory = 'New category';
  static const String categoryName = 'Category name';
  static const String categoryNameHint = 'e.g. Pet care';
  static const String addCategory = 'Add category';
  static const String sortAtoZ = 'Sort A to Z';
  static const String sortZtoA = 'Sort Z to A';

  // Payday (fortnightly / weekly)
  static const String paydayLabel = 'PAYDAY';
  static const String fortnightlyPaydayTitle = 'When did you last get paid?';
  static const String fortnightlyPaydaySubtitle = 'Pick a recent payday or your preferred start date.';
  static const String fortnightlyPaydayNote =
      'Your budget will follow a two-week cycle starting from this date.';
  static const String paydayPickerHelp = 'Last payday';
  static const String weeklyPaydayTitle = 'Which day do you usually get paid?';
  static const String weeklyPaydaySubtitle = 'This sets the start of your weekly budget.';
  static String weeklyPaydayNote(String weekday) => 'Each week runs from $weekday to the day before.';
  static const String payWeekdaySheetTitle = 'Pay day';

  // Home
  static const String tabHome = 'Home';
  static const String tabCalendar = 'Calendar';
  static const String tabBudget = 'Budget';
  static const String tabReports = 'Reports';
  static const String comingSoon = 'Coming soon.';
  static const String rangePickerHelp = 'Choose a date range';
  static const String apply = 'Apply';
  static const String backToCurrentPeriod = 'Back to current period';
  static const String challengeTitle = 'Your first challenge is complete!';
  static const String challengeBody =
      'Tap the profile icon to view badges, challenges, and notifications.';
  static const String forecast = 'Forecast';
  static const String expenses = 'Expenses';
  static const String income = 'Income';
  static const String viewAll = 'View all';
  static const String noExpensesYet = 'No expenses in this period yet.';
  static String transactionCount(int n) => n == 1 ? '1 transaction' : '$n transactions';

  // All expenses
  static const String allExpenses = 'All expenses';
  static const String totalSpent = 'Total spent';

  // Profile
  static const String profile = 'Profile';
  static const String upgradeToPro = 'Upgrade to Pro';
  static const String profileName = 'Budget Rookie';
  static const String anonymous = 'Anonymous';
  static const String createLoginToPersonalise = 'Create login to personalise';
  static String levelLabel(int level, String name) => 'Level $level · $name';
  static const String viewJourney = 'View journey';
  static const String weeklyBonus = 'Weekly bonus';
  static const String bonusNotStarted = 'Not started';
  static const String bonusInProgress = 'In progress';
  static const String bonusComplete = 'Complete';
  static String daysLeftThisWeek(int days) =>
      'This week · ${days == 1 ? '1 day' : '$days days'} left';
  static String weeklyBonusGoal(int days) => 'Log a transaction on $days separate days';
  static String weeklyBonusReward(int xp) => 'Secure this week to earn a $xp XP weekly bonus.';
  static const String dailyStreak = 'Daily streak';
  static String streakDays(int days) => days == 1 ? '1 day streak' : '$days day streak';
  static const String streakKeepGoing = 'Log something every day to keep it going.';
  static const String noStreak = 'No streak yet';
  static const String streakStart = 'Log a transaction today to start one.';

  // Create login
  static const String createLogin = 'Create login';
  static const String registerSubtitle = 'Create a login using your social account or email';
  static const String newPasswordHint = 'At least 6 characters';
  static const String confirmPassword = 'Confirm password';
  static const String confirmPasswordHint = 'Re-enter your password';
  static const String showPassword = 'Show password';
  static const String hidePassword = 'Hide password';
  static const String loginCreated = 'Login created. Your progress is saved.';

  // Login
  static const String loginTitle = 'Welcome back';
  static const String loginSubtitle = 'Log in with your social account or email.';
  static const String continueWithGoogle = 'Continue with Google';
  static const String or = 'or';
  static const String email = 'Email';
  static const String emailHint = 'you@example.com';
  static const String password = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String forgotPassword = 'Forgot password?';
  static const String noAccount = "Don't have an account?";
  static const String signUp = 'Sign up';

  // Home
  static const String homeGreeting = 'Good to see you';
  static const String totalBalance = 'Total balance';
}