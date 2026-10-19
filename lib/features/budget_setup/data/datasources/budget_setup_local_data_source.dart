import '../../../../core/error/exceptions.dart';
import '../../domain/entities/budget_plan.dart';
import '../../domain/entities/new_transaction.dart';
import '../models/transaction_category_model.dart';

abstract interface class BudgetSetupLocalDataSource {
  Future<void> saveBudgetPlan(BudgetPlan plan);

  /// Falls back to a monthly plan if onboarding was skipped.
  Future<BudgetPlan> getBudgetPlan();
  Future<List<NewTransaction>> getTransactions();
  Future<List<TransactionCategoryModel>> getCategories();
  Future<TransactionCategoryModel> createCategory(String name);
  Future<void> saveTransaction(NewTransaction transaction);
}

/// In-memory implementation shared by onboarding, home and profile.
/// Swap for SharedPreferences / a database later without touching
/// domain or presentation code.
class BudgetSetupLocalDataSourceImpl implements BudgetSetupLocalDataSource {
  BudgetPlan? _plan;
  final List<NewTransaction> _transactions = [];

  final List<TransactionCategoryModel> _categories = _defaults
      .map(TransactionCategoryModel.fromJson)
      .toList();

  static const _defaults = <Map<String, dynamic>>[
    {'id': 'dining_out', 'name': 'Dining Out', 'iconKey': 'dining'},
    {'id': 'entertainment', 'name': 'Entertainment', 'iconKey': 'entertainment'},
    {'id': 'groceries', 'name': 'Groceries', 'iconKey': 'groceries'},
    {'id': 'healthcare', 'name': 'Healthcare', 'iconKey': 'healthcare'},
    {'id': 'housing', 'name': 'Housing', 'iconKey': 'housing'},
    {'id': 'transportation', 'name': 'Transportation', 'iconKey': 'transport'},
    {'id': 'utilities', 'name': 'Utilities', 'iconKey': 'utilities'},
  ];

  BudgetPlan? get budgetPlan => _plan;
  List<NewTransaction> get transactions => List.unmodifiable(_transactions);

  @override
  Future<void> saveBudgetPlan(BudgetPlan plan) async {
    _plan = plan;
  }

  @override
  Future<BudgetPlan> getBudgetPlan() async => _plan ?? BudgetPlan.monthly();

  @override
  Future<List<NewTransaction>> getTransactions() async => List.of(_transactions);

  @override
  Future<List<TransactionCategoryModel>> getCategories() async {
    // Simulated latency so the shimmer skeleton is visible.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return List.of(_categories);
  }

  @override
  Future<TransactionCategoryModel> createCategory(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw const CacheException('Name is empty');

    final existing = _categories.where((c) => c.name.toLowerCase() == trimmed.toLowerCase());
    if (existing.isNotEmpty) return existing.first;

    final created = TransactionCategoryModel(
      id: 'custom_${DateTime.now().microsecondsSinceEpoch}',
      name: trimmed,
      iconKey: 'custom',
      isCustom: true,
    );
    _categories.add(created);
    return created;
  }

  @override
  Future<void> saveTransaction(NewTransaction transaction) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _transactions.add(transaction);
  }
}
