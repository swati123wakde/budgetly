import 'package:equatable/equatable.dart';

/// A spending / income bucket the user files transactions under.
class TransactionCategory extends Equatable {
  const TransactionCategory({
    required this.id,
    required this.name,
    required this.iconKey,
    this.isCustom = false,
  });

  final String id;
  final String name;

  /// Stable key the presentation layer maps to an icon (keeps Flutter out of domain).
  final String iconKey;

  /// True for categories the user created themselves.
  final bool isCustom;

  @override
  List<Object?> get props => [id, name, iconKey, isCustom];
}
