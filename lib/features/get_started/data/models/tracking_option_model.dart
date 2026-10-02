import '../../domain/entities/tracking_option.dart';

/// Data-layer model; knows how to parse itself from JSON (e.g. remote config).
class TrackingOptionModel extends TrackingOption {
  const TrackingOptionModel({
    required super.mode,
    required super.title,
    required super.description,
    required super.highlights,
    super.recommended,
  });

  factory TrackingOptionModel.fromJson(Map<String, dynamic> json) {
    return TrackingOptionModel(
      mode: TrackingMode.values.byName(json['mode'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      highlights: List<String>.from(json['highlights'] as List),
      recommended: json['recommended'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'mode': mode.name,
    'title': title,
    'description': description,
    'highlights': highlights,
    'recommended': recommended,
  };
}