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
  static const String getStartedOverline = 'STEP 1 OF 3';
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