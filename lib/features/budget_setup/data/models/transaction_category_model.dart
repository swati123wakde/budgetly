import '../../domain/entities/transaction_category.dart';

class TransactionCategoryModel extends TransactionCategory {
  const TransactionCategoryModel({
    required super.id,
    required super.name,
    required super.iconKey,
    super.isCustom,
  });

  factory TransactionCategoryModel.fromJson(Map<String, dynamic> json) {
    return TransactionCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconKey: json['iconKey'] as String,
      isCustom: json['isCustom'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'iconKey': iconKey,
    'isCustom': isCustom,
  };
}
