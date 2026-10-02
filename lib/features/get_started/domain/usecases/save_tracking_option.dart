import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/tracking_option.dart';
import '../repositories/tracking_option_repository.dart';

class SaveTrackingMode implements UseCase<void, TrackingMode> {
  const SaveTrackingMode(this._repository);
  final TrackingOptionRepository _repository;

  @override
  Future<Result<void>> call(TrackingMode mode) => _repository.saveSelectedMode(mode);
}