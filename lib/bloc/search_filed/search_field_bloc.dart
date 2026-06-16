import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'search_field_event.dart';
import 'search_field_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<String> allItems; // items for search suggestions
  final List<String> hints;    // rotating hint texts

  Timer? _timer;
  int _hintIndex = 0;

  SearchBloc({required this.allItems, required this.hints})
      : super(SearchState(hint: hints.isNotEmpty ? hints[0] : "Search", suggestions: [], query: "")) {
    on<StartHintRotation>(_onStart);
    on<NextHint>(_onNextHint);
    on<QueryChanged>(_onQueryChanged);
    on<UpdateHintsEvent>(onUpdateHints);

    // Start rotation immediately
    add(StartHintRotation());

  }

  void _onStart(StartHintRotation event, Emitter<SearchState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      add(NextHint());
    });
  }

  void _onNextHint(NextHint event, Emitter<SearchState> emit) {
    if (state.query.isNotEmpty) return;

    if (hints.isEmpty) return;

    _hintIndex = (_hintIndex + 1) % hints.length;
    emit(state.copyWith(hint: hints[_hintIndex]));
  }

  void _onQueryChanged(QueryChanged event, Emitter<SearchState> emit) {
    final query = event.query;

    List<String> filtered = [];
    if (query.isNotEmpty) {
      filtered = allItems
          .where((e) => e.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    emit(state.copyWith(query: query, suggestions: filtered));
  }
  onUpdateHints(UpdateHintsEvent event, emit){
    hints.clear();
    hints.addAll(event.hints);

    if (hints.isNotEmpty) {
      emit(
        state.copyWith(
          hint: hints.first,
        ),
      );
    }
  }
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}