import '../../../../core/utils/result.dart';
import '../entities/tracking_option.dart';

abstract interface class TrackingOptionRepository {
  Future<Result<List<TrackingOption>>> getOptions();
  Future<Result<void>> saveSelectedMode(TrackingMode mode);
}