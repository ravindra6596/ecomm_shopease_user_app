import 'package:e_comm_user/bloc/category/category_event.dart';
import 'package:e_comm_user/bloc/category/category_state.dart';
import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/category_model.dart';
import 'package:e_comm_user/repository/category_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository? categoryRepository;
  List<Categories> allCategories = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int? selectedCategoryId;
  int selectedCategoryIndex = 0;
  int pageNo = 0;
   CategoryBloc()
      : categoryRepository = getIt<CategoryRepository>(),
        super(const CategoryInitialState()) {
    on<CategoryEvent>(categoryEventHandler);
    on<CategoryLoadEvent>(categoryListMethod);
    on<CategorySelectEvent>(selectListCategory);
    on<CategoryDetailsEvent>(categoryDetailsMethod);
  }

  categoryEventHandler(CategoryEvent event, emit) async {
    if (event is TopCategoryLoadEvent) {
      await loadTopCategories(event, emit);
    } else if (event is TopCategorySelectEvent) {
      await selectCategory(event, emit);
    }
  }

  loadTopCategories(TopCategoryLoadEvent event, emit) async {
    emit(const CategoryLoadingState());
    final categoriesResult = await categoryRepository!.getTopCategories();

    switch (categoriesResult) {
      case Success<TopCategoryResponseModel, Exception>():
        final categories = categoriesResult.data.data ?? [];
        final allCategories = [
          Category(category_id: null, category_name: 'For You'),
          ...categories,
        ];
        emit(CategorySuccessState(
          categories: allCategories,
          selectedCategoryId: null,
          selectedCategoryName: 'For You',
        ));
        break;

      case Failure<TopCategoryResponseModel, Exception>():
        emit(CategoryErrorState(categoriesResult.error.toString()));
        break;
    }
  }

  selectCategory(TopCategorySelectEvent event, emit) async {
    if (state is CategorySuccessState) {
      final currentState = state as CategorySuccessState;
      emit(CategorySuccessState(
        categories: currentState.categories,
        selectedCategoryId: event.categoryId,
        selectedCategoryName: event.categoryName,
      ));
    }
  }

  // ─── SELECT CATEGORY ────────────────────────────────────────────────────────
  selectListCategory(CategorySelectEvent event, Emitter<CategoryState> emit) async {
    if (state is! CategoriesSuccessState) return;

    final currentState = state as CategoriesSuccessState;

    selectedCategoryId = event.categoryId;
    selectedCategoryIndex = event.selectedIndex;

    // Immediately reflect the selected index + show loading on right panel
    emit(CategoriesSuccessState(
      currentState.categoriesResponseModel,
      hasMore: hasMoreData,
      selectedCategory: null,
      selectedIndex: event.selectedIndex,
      isLoadingDetails: true,
      detailsError: null,
    ));

    final categoryDetails = await categoryRepository!
        .getCategoryDetails(selectedCategoryId ?? 0);

    switch (categoryDetails) {
      case Success<CategoryDetailsResponseModel, Exception>():
        emit(CategoriesSuccessState(
          currentState.categoriesResponseModel,
          hasMore: hasMoreData,
          selectedCategory: categoryDetails.data.data,
          selectedIndex: event.selectedIndex,
          isLoadingDetails: false,
          detailsError: null,
        ));
        break;

      case Failure<CategoryDetailsResponseModel, Exception>():
      // Keep the list visible — do NOT emit CategoryErrorState here
        emit(CategoriesSuccessState(
          currentState.categoriesResponseModel,
          hasMore: hasMoreData,
          selectedCategory: null,
          selectedIndex: event.selectedIndex,
          isLoadingDetails: false,
          detailsError: categoryDetails.error.toString(),
        ));
        break;
    }
  }

  // ─── LOAD CATEGORY LIST ─────────────────────────────────────────────────────
  Future<void> categoryListMethod(
      CategoryLoadEvent event,
      Emitter<CategoryState> emit,
      ) async {
    final isFirstPage = event.page == 1;

    if (isLoadingMore) return;
    if (!hasMoreData && !isFirstPage) return;

    isLoadingMore = true;

    if (isFirstPage) {
      emit(CategoryLoadingState());
      allCategories.clear();
      hasMoreData = true;
      pageNo = 1;
      selectedCategoryId = null;
      selectedCategoryIndex = 0;
    }

    final categoryList = await categoryRepository!.getCategoryList(
      event.page,
      event.limit,
      event.categoryId,
    );

    switch (categoryList) {
      case Success<CategoriesResponseModel, Exception>():
        final newItems = categoryList.data.data?.items ?? [];

        if (newItems.length < event.limit) {
          hasMoreData = false;
        } else {
          pageNo = event.page;
        }

        allCategories.addAll(newItems);

        // Auto-select first category on first page load
        if (selectedCategoryId == null && allCategories.isNotEmpty) {
          final firstCategory = allCategories.first;
          selectedCategoryId = firstCategory.id;
          selectedCategoryIndex = 0;
        }

        // Fetch details for auto-selected or currently selected category
        final categoryDetails = await categoryRepository!
            .getCategoryDetails(selectedCategoryId ?? 0);

        CategoryData? selectedCategory;

        switch (categoryDetails) {
          case Success<CategoryDetailsResponseModel, Exception>():
            selectedCategory = categoryDetails.data.data;
            break;
          case Failure<CategoryDetailsResponseModel, Exception>():
            selectedCategory = null;
            break;
        }

        final updatedResponse = CategoriesResponseModel(
          status: true,
          message: '',
          statusCode: 200,
          data: CategoriesData(
            total: categoryList.data.data?.total,
            page: pageNo,
            limit: categoryList.data.data?.limit,
            total_pages: categoryList.data.data?.total_pages,
            is_previous: categoryList.data.data?.is_previous,
            is_next: hasMoreData,
            items: List.from(allCategories),
          ),
        );

        isLoadingMore = false;

        emit(CategoriesSuccessState(
          updatedResponse,
          hasMore: hasMoreData,
          selectedCategory: selectedCategory,
          selectedIndex: selectedCategoryIndex ?? 0,
          isLoadingDetails: false,
          detailsError: selectedCategory == null
              ? 'Failed to load category details'
              : null,
        ));

        break;

      case Failure<CategoriesResponseModel, Exception>():
        isLoadingMore = false;
        emit(CategoryErrorState(categoryList.error.toString()));
        break;
    }
  }

  // ─── CATEGORY DETAILS (standalone) ─────────────────────────────────────────
  categoryDetailsMethod(
      CategoryDetailsEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryDetailsLoadingState());

    final categoryDetails =
    await categoryRepository!.getCategoryDetails(event.categoryId);

    switch (categoryDetails) {
      case Success<CategoryDetailsResponseModel, Exception>():
        final category = categoryDetails.data.data;
        if (category != null) {
          emit(CategoryDetailsSuccessState(category));
        } else {
          emit(CategoryDetailsErrorState('Category not found'));
        }
        break;

      case Failure<CategoryDetailsResponseModel, Exception>():
        emit(CategoryDetailsErrorState(categoryDetails.error.toString()));
        break;
    }
  }
}
