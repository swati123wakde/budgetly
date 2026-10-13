import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/transaction_category.dart';
import '../../domain/usecases/create_category.dart';
import '../../domain/usecases/get_categories.dart';

part 'category_picker_state.dart';

class CategoryPickerCubit extends Cubit<CategoryPickerState> {
  CategoryPickerCubit({
    required GetCategories getCategories,
    required CreateCategory createCategory,
  })  : _getCategories = getCategories,
        _createCategory = createCategory,
        super(const CategoryPickerState());

  final GetCategories _getCategories;
  final CreateCategory _createCategory;

  /// [selectedId] is the category already chosen on the previous screen, if any.
  Future<void> load({String? selectedId}) async {
    emit(CategoryPickerState(selectedId: selectedId, sortAscending: state.sortAscending));
    final result = await _getCategories(const NoParams());
    if (isClosed) return;
    result.fold(
          (failure) => emit(state.copyWith(
        status: CategoryPickerStatus.failure,
        errorMessage: failure.message,
      )),
          (categories) => emit(state.copyWith(
        status: CategoryPickerStatus.loaded,
        categories: categories,
      )),
    );
  }

  void toggleSort() => emit(state.copyWith(sortAscending: !state.sortAscending));

  Future<void> create(String name) async {
    if (name.trim().isEmpty || state.isCreating) return;
    emit(state.copyWith(isCreating: true));
    final result = await _createCategory(name);
    if (isClosed) return;
    result.fold(
          (failure) => emit(state.copyWith(isCreating: false, errorMessage: failure.message)),
          (category) => emit(state.copyWith(
        isCreating: false,
        categories: state.categories.contains(category)
            ? state.categories
            : [...state.categories, category],
        selectedId: category.id,
        createdCategory: category,
      )),
    );
  }
}
