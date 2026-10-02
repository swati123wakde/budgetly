import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/tracking_option.dart';
import '../../domain/repositories/tracking_option_repository.dart';
import '../datasources/tracking_option_local_data_source.dart';

class TrackingOptionRepositoryImpl implements TrackingOptionRepository {
  const TrackingOptionRepositoryImpl(this._local);
  final TrackingOptionLocalDataSource _local;

  @override
  Future<Result<List<TrackingOption>>> getOptions() async {
    try {
      return Ok<List<TrackingOption>>(await _local.getOptions());
    } catch (_) {
      return const Err<List<TrackingOption>>(CacheFailure());
    }
  }

  @override
  Future<Result<void>> saveSelectedMode(TrackingMode mode) async {
    try {
      await _local.saveSelectedMode(mode);
      return const Ok<void>(null);
    } catch (_) {
      return const Err<void>(CacheFailure('Could not save your choice.'));
    }
  }
}