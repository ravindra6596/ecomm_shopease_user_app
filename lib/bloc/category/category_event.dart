abstract class CategoryEvent {
  const CategoryEvent();

  List<Object?> get props => [];
}

class TopCategoryLoadEvent extends CategoryEvent {
  const TopCategoryLoadEvent();
}

class CategoryLoadEvent extends CategoryEvent {
  final int page;
  final int limit;
  final int? categoryId;
  const CategoryLoadEvent(this.page, this.limit,  [this.categoryId]);
}

class TopCategorySelectEvent extends CategoryEvent {
  final int? categoryId;
  final String categoryName;

  const TopCategorySelectEvent({
    this.categoryId,
    required this.categoryName,
  });

  @override
  List<Object?> get props => [categoryId, categoryName];
}

class CategorySelectEvent extends CategoryEvent {
  final int categoryId;
  final int selectedIndex;

  const CategorySelectEvent(
    this.categoryId,
    this.selectedIndex,
   );

  @override
  List<Object?> get props => [categoryId, selectedIndex];
}
class CategoryDetailsEvent extends CategoryEvent {
  final int categoryId;
  CategoryDetailsEvent(this.categoryId);
}