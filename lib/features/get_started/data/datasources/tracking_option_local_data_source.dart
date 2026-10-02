import '../../domain/entities/tracking_option.dart';
import '../models/tracking_option_model.dart';

abstract interface class TrackingOptionLocalDataSource {
  Future<List<TrackingOptionModel>> getOptions();
  Future<void> saveSelectedMode(TrackingMode mode);
}

/// In-memory implementation. Swap for SharedPreferences / remote config later
/// without touching domain or presentation code.
class TrackingOptionLocalDataSourceImpl implements TrackingOptionLocalDataSource {
  TrackingMode? _savedMode;

  static const _rawOptions = <Map<String, dynamic>>[
    {
      'mode': 'spendingOnly',
      'title': 'Just my spending',
      'description': 'Log what you spend in seconds. No bank accounts required.',
      'highlights': ['Quick entry', 'Category budgets'],
      'recommended': true,
    },
    {
      'mode': 'spendingAndAccounts',
      'title': 'Spending + accounts',
      'description': 'Add your accounts and see exactly where every dollar sits.',
      'highlights': ['Balances', 'Net worth', 'Transfers'],
    },
  ];

  @override
  Future<List<TrackingOptionModel>> getOptions() async {
    // Simulated latency so the shimmer skeleton is visible.
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    return _rawOptions.map(TrackingOptionModel.fromJson).toList();
  }

  @override
  Future<void> saveSelectedMode(TrackingMode mode) async {
    _savedMode = mode;
  }

  TrackingMode? get savedMode => _savedMode;
}