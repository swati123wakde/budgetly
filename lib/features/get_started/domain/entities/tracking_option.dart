import 'package:equatable/equatable.dart';

enum TrackingMode { spendingOnly, spendingAndAccounts }

/// One choice on the "How would you like to get started?" screen.
class TrackingOption extends Equatable {
  const TrackingOption({
    required this.mode,
    required this.title,
    required this.description,
    required this.highlights,
    this.recommended = false,
  });

  final TrackingMode mode;
  final String title;
  final String description;
  final List<String> highlights;
  final bool recommended;

  @override
  List<Object?> get props => [mode, title, description, highlights, recommended];
}