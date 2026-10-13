part of 'category_picker_cubit.dart';

enum CategoryPickerStatus { loading, loaded, failure }

class CategoryPickerState extends Equatable {
  const CategoryPickerState({
    this.status = CategoryPickerStatus.loading,
    this.categories = const [],
    this.sortAscending = true,
    this.selectedId,
    this.isCreating = false,
    this.errorMessage,
    this.createdCategory,
  });

  final CategoryPickerStatus status;
  final List<TransactionCategory> categories;
  final bool sortAscending;
  final String? selectedId;
  final bool isCreating;
  final String? errorMessage;

  /// Set once a new category is created — the page pops with it.
  final TransactionCategory? createdCategory;

  List<TransactionCategory> get sorted {
    final list = [...categories]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sortAscending ? list : list.reversed.toList();
  }

  CategoryPickerState copyWith({
    CategoryPickerStatus? status,
    List<TransactionCategory>? categories,
    bool? sortAscending,
    String? selectedId,
    bool? isCreating,
    String? errorMessage,
    TransactionCategory? createdCategory,
  }) {
    return CategoryPickerState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      sortAscending: sortAscending ?? this.sortAscending,
      selectedId: selectedId ?? this.selectedId,
      isCreating: isCreating ?? this.isCreating,
      errorMessage: errorMessage,
      createdCategory: createdCategory,
    );
  }

  @override
  List<Object?> get props =>
      [status, categories, sortAscending, selectedId, isCreating, errorMessage, createdCategory];
}
