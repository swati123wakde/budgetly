import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/tracking_option.dart';
import '../repositories/tracking_option_repository.dart';

class GetTrackingOptions implements UseCase<List<TrackingOption>, NoParams> {
  const GetTrackingOptions(this._repository);
  final TrackingOptionRepository _repository;

  @override
  Future<Result<List<TrackingOption>>> call(NoParams params) => _repository.getOptions();
}