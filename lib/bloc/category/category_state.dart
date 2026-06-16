import 'package:e_comm_user/models/category_model.dart';

abstract class CategoryState   {
  const CategoryState();

  List<Object?> get props => [];
}

class CategoryInitialState extends CategoryState {
  const CategoryInitialState();
}

class CategoryLoadingState extends CategoryState {
  const CategoryLoadingState();
}

class CategorySuccessState extends CategoryState {
  final List<Category> categories;
  final int? selectedCategoryId;
  final String selectedCategoryName;

  const CategorySuccessState({
    required this.categories,
    this.selectedCategoryId,
    required this.selectedCategoryName,
  });

  @override
  List<Object?> get props => [categories, selectedCategoryId, selectedCategoryName];
}

class CategoryErrorState extends CategoryState {
  final String error;

  const CategoryErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
class CategoriesSuccessState extends CategoryState {
  final CategoriesResponseModel categoriesResponseModel;
  final CategoryData? selectedCategory;
  final int selectedIndex;
  final bool hasMore;
  final bool isLoadingDetails;
  final String? detailsError;

  CategoriesSuccessState(
      this.categoriesResponseModel, {
        this.selectedCategory,
        this.selectedIndex = 0,
        this.hasMore = true,
        this.isLoadingDetails = false,
        this.detailsError,
      });

  @override
  List<Object?> get props => [
    categoriesResponseModel,
    selectedCategory,
    selectedIndex,
    hasMore,
    isLoadingDetails,
    detailsError,
  ];
}
class CategoryDetailsLoadingState extends CategoryState {}

class CategoryDetailsSuccessState extends CategoryState {
  final CategoryData categoryData;
  CategoryDetailsSuccessState(this.categoryData);
}

class CategoryDetailsErrorState extends CategoryState {
  final String error;
  CategoryDetailsErrorState(this.error);
}
