class SearchState {
  final String hint;
  final List<String> suggestions;
  final String query;

  SearchState({
    required this.hint,
    required this.suggestions,
    required this.query,
  });

  SearchState copyWith({
    String? hint,
    List<String>? suggestions,
    String? query,
  }) {
    return SearchState(
      hint: hint ?? this.hint,
      suggestions: suggestions ?? this.suggestions,
      query: query ?? this.query,
    );
  }
}