// ============================================================
// ARROWS – PUZZLE ESCAPE  (Highly Refined UI & Mechanics)
//
// pubspec.yaml dependencies:
//   flutter_bloc: ^8.1.6
//   equatable: ^2.0.5
// ============================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_notification/ui/home/home_screen.dart';

void main() => runApp(const ArrowPuzzleApp());

// ═══════════════════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════════════════

enum ArrowDir { up, down, left, right }

extension ArrowDirExt on ArrowDir {
  double get angle {
    switch (this) {
      case ArrowDir.right: return 0;
      case ArrowDir.down:  return math.pi / 2;
      case ArrowDir.left:  return math.pi;
      case ArrowDir.up:    return -math.pi / 2;
    }
  }

  (int, int) exitDelta() {
    switch (this) {
      case ArrowDir.up:    return (-1, 0);
      case ArrowDir.down:  return (1, 0);
      case ArrowDir.left:  return (0, -1);
      case ArrowDir.right: return (0, 1);
    }
  }
}

class ArrowCell {
  final int id;
  final List<Offset> path;
  final ArrowDir dir;
  final bool removed;
  final bool removing;

  ArrowCell({
    required this.id,
    required List<Offset> path,
    required this.dir,
    this.removed = false,
    this.removing = false,
  }) : this.path = _normalizePath(path, dir);

  static List<Offset> _normalizePath(List<Offset> originalPath, ArrowDir dir) {
    if (originalPath.isEmpty) return [];
    if (originalPath.length == 1) {
      final cell = originalPath.first;
      final (dr, dc) = dir.exitDelta();
      return [
        Offset(cell.dx - dc * 0.35, cell.dy - dr * 0.35),
        cell,
      ];
    }
    return originalPath;
  }

  int get row => path.isEmpty ? 0 : path.last.dy.round();
  int get col => path.isEmpty ? 0 : path.last.dx.round();

  ArrowCell copyWith({
    bool? removed,
    bool? removing,
    List<Offset>? path,
    ArrowDir? dir,
  }) => ArrowCell(
    id: id,
    path: path ?? this.path,
    dir: dir ?? this.dir,
    removed: removed ?? this.removed,
    removing: removing ?? this.removing,
  );
}

class Level {
  final int number;
  final int rows;
  final int cols;
  final List<ArrowCell> arrows;
  final String title;

  Level({
    required this.number,
    required this.rows,
    required this.cols,
    required this.arrows,
    required this.title,
  });
}

// ═══════════════════════════════════════════════════════════
// LEVEL DATA
// ═══════════════════════════════════════════════════════════

int _gid = 0;
ArrowCell _a(List<Offset> path, ArrowDir dir) => ArrowCell(id: _gid++, path: path, dir: dir);
ArrowCell _s(double c, double r, ArrowDir dir) => ArrowCell(id: _gid++, path: [Offset(c, r)], dir: dir);

List<Level> buildLevels() {
  // ── Level 1: Warm Up (3×3) ──────────────────────────────────
  _gid = 0;
  final l1 = Level(
    number: 1, rows: 3, cols: 3, title: 'Warm Up',
    arrows: [
      _s(0, 1, ArrowDir.up),
      _s(1, 1, ArrowDir.down),
      _s(2, 1, ArrowDir.up),
    ],
  );

  // ── Level 2: Winding Intro (3×3) ───────────────────────────
  _gid = 0;
  final l2 = Level(
    number: 2, rows: 3, cols: 3, title: 'Winding Intro',
    arrows: [
      _s(0, 0, ArrowDir.right),
      _a([Offset(1, 0), Offset(1, 1), Offset(2, 1)], ArrowDir.right),
      _a([Offset(1, 2), Offset(0, 2), Offset(0, 1)], ArrowDir.up),
      _s(2, 2, ArrowDir.up),
    ],
  );

  // ── Level 3: Cross Roads (4×4) ─────────────────────────────
  _gid = 0;
  final l3 = Level(
    number: 3, rows: 4, cols: 4, title: 'Cross Roads',
    arrows: [
      _s(0, 0, ArrowDir.down),
      _a([Offset(0, 3), Offset(1, 3), Offset(1, 2), Offset(2, 2)], ArrowDir.right),
      _s(3, 2, ArrowDir.up),
      _a([Offset(2, 0), Offset(2, 1), Offset(3, 1)], ArrowDir.right),
      _a([Offset(1, 0), Offset(1, 1), Offset(0, 1), Offset(0, 2)], ArrowDir.down),
    ],
  );

  // ── Level 4: Spiral (5×5) ──────────────────────────────────
  _gid = 0;
  final l4 = Level(
    number: 4, rows: 5, cols: 5, title: 'Double Spiral',
    arrows: [
      _a([Offset(0, 0), Offset(0, 1), Offset(1, 1), Offset(1, 2)], ArrowDir.down),
      _a([Offset(1, 0), Offset(2, 0), Offset(2, 1), Offset(2, 2)], ArrowDir.down),
      _s(2, 4, ArrowDir.left),
      _a([Offset(0, 2), Offset(0, 3), Offset(1, 3), Offset(2, 3)], ArrowDir.right),
      _s(4, 2, ArrowDir.up),
      _a([Offset(4, 0), Offset(3, 0), Offset(3, 1),Offset(3, 2),  Offset(3, 3), Offset(4, 3)], ArrowDir.right),
      _a([Offset(3, 4), Offset(4, 4)], ArrowDir.right),
    ],
  );

  // ── Level 5: Grand Escape (Your Verified Code) ──────────────
  _gid = 0;
  final l5 = Level(
    number: 5, rows: 11, cols: 8, title: 'Grand Escape',
    arrows: [
      // 1. Top left single lone arrow pointing up
      _a([Offset(1, 3), Offset(1, 1), Offset(0, 1), Offset(0, 0)], ArrowDir.up),

      // 2. Far left edge long vertical line that goes down and wraps around the bottom right
      _a([Offset(0, 2), Offset(0, 4), Offset(1, 4), Offset(6, 4),Offset(6, 6)], ArrowDir.down),

      // 3. Second vertical line down in col 2 (top segment)
      _a([Offset(2, 0), Offset(2, 3)], ArrowDir.down),

      // 4. Second vertical line down in col 2 (bottom segment)
      _a([Offset(2, 5), Offset(2, 8)], ArrowDir.down),

      // 5. Downward hook path in the center-left columns
      _a([Offset(3, 1), Offset(4, 1), Offset(4, 3)], ArrowDir.down),

      // 7. Top right winding hook path going left
      _a([Offset(5, 1), Offset(7, 1), Offset(7, 3), Offset(5, 3)], ArrowDir.left),

      // 8. Outer right vertical path going down
      _a([Offset(7, 4), Offset(7, 7)], ArrowDir.down),

      // 9. Right middle snake pathway weaving back to the right

      // 10. Center tiny path going right
      _a([Offset(4, 6), Offset(5, 6)], ArrowDir.right),

      // 11. Large bottom inner container loop going left
      _a([Offset(3, 10), Offset(3, 9), Offset(7, 9), Offset(7, 8), Offset(5, 8)], ArrowDir.left),

      // 12. Inner horizontal path going left
      _a([Offset(6, 7), Offset(4, 7)], ArrowDir.left),
      _a([Offset(0, 10), Offset(0, 5), Offset(1, 5), Offset(1, 9), Offset(2, 9), Offset(2, 10)], ArrowDir.down),

    ],
  );

  // ── Level 6: The Interlock Chamber (9×9) ───────────────────
  // Focuses on intersecting loops where unhooking one arrow opens the path for two others.
  // ── Level 6: Interlock Chamber (8×8) ────────────────────────
  _gid = 0;
  final l6 = Level(
    number: 6, rows: 8, cols: 8, title: 'Interlock Chamber',
    arrows: [
      _a([Offset(1, 0), Offset(1, 4)], ArrowDir.down),
      _a([Offset(0, 5), Offset(3, 5), Offset(3, 2)], ArrowDir.up),
      _a([Offset(2, 7), Offset(2, 6), Offset(5, 6), Offset(5, 7)], ArrowDir.down),
      _a([Offset(6, 0), Offset(4, 0), Offset(4, 3)], ArrowDir.down),
      _a([Offset(7, 6), Offset(7, 2), Offset(5, 2)], ArrowDir.left),
      _a([Offset(4, 5), Offset(6, 5), Offset(6, 7), Offset(7, 7)], ArrowDir.right),
    ],
  );

  // ── Level 7: Twisted Grid (9×9) ────────────────────────────
  _gid = 0;
  final l7 = Level(
    number: 7, rows: 9, cols: 9, title: 'Twisted Grid',
    arrows: [
      _a([Offset(4, 7), Offset(4, 5),Offset(0, 5),Offset(0, 8), Offset(4, 8)], ArrowDir.right),
      _a([Offset(4, 1),Offset(1, 1),  Offset(1, 3),Offset(4, 3)], ArrowDir.right),
      _a([Offset(2, 2), Offset(7, 2),Offset(7, 0),Offset(8, 0),], ArrowDir.right),
      _a([Offset(3, 6), Offset(1, 6), Offset(1, 7)], ArrowDir.down),
      _a([Offset(6, 8), Offset(8, 8), Offset(8, 5)], ArrowDir.up),
      _a([Offset(8, 1), Offset(8, 4), Offset(6, 4)], ArrowDir.left),
      _a([Offset(7, 5), Offset(5, 5), Offset(5, 7)], ArrowDir.down),
      _a([Offset(7, 6), Offset(6, 6), Offset(6, 7)], ArrowDir.down),
      _a([Offset(0, 3), Offset(0, 0), Offset(6, 0),Offset(6, 1)], ArrowDir.down),
      _a([Offset(7, 3), Offset(5, 3), Offset(5, 4),Offset(0, 4)], ArrowDir.left),
    ],
  );

  // ── Level 8: Mega Maze Pit (10×10) ──────────────────────────
  _gid = 0;
  final l8 = Level(
    number: 8, rows: 10, cols: 10, title: 'Mega Maze Pit',
    arrows: [
      _a([Offset(2, 0), Offset(8, 0), Offset(8, 3),Offset(9, 3),Offset(9, 2)], ArrowDir.up),
      _a([Offset(0, 2), Offset(0, 9), Offset(9, 9)], ArrowDir.right),
      _a([Offset(2, 3), Offset(5, 3), Offset(5, 1),Offset(2, 1)], ArrowDir.left),
      _a([Offset(3, 5), Offset(3, 4), Offset(6, 4),Offset(6, 1)], ArrowDir.up),
      _a([Offset(4, 7), Offset(1, 7), Offset(1, 8)], ArrowDir.down),
      _a([Offset(8, 8), Offset(6, 8), Offset(6, 7),Offset(8, 7),Offset(8, 6),Offset(1, 6),Offset(1, 0),Offset(0, 0)], ArrowDir.left),
      _a([Offset(7, 1), Offset(7, 4), Offset(9, 4)], ArrowDir.right),
      _a([Offset(5, 7), Offset(5, 8), Offset(2, 8)], ArrowDir.left),
      _a([Offset(2, 2), Offset(4, 2), ], ArrowDir.right),
      _a([Offset(6, 5), Offset(9, 5), Offset(9, 8)], ArrowDir.down),
    ],
  );

  // ── Level 9: Ultimate Labyrinth (10×11) ─────────────────────
  _gid = 0;
  final l9 = Level(
    number: 9, rows: 11, cols: 10, title: 'Ultimate Labyrinth',
    arrows: [
      _a([Offset(1, 1), Offset(1, 5), Offset(2, 5), Offset(2, 2)], ArrowDir.up),
      _a([Offset(0, 2), Offset(0, 10), Offset(1, 10),Offset(1, 6),Offset(5, 6),Offset(5, 7)], ArrowDir.down),
      _a([Offset(2, 1), Offset(5, 1), Offset(5, 4), Offset(3, 4),Offset(3, 5)], ArrowDir.down),
      _a([Offset(7, 0), Offset(8, 0), Offset(8, 3),Offset(9, 3)], ArrowDir.right),
      _a([Offset(6, 9), Offset(3, 9),Offset(3, 7), Offset(2, 7),Offset(2, 10)], ArrowDir.down),
      _a([Offset(7, 6), Offset(7, 8), Offset(6, 8),Offset(6, 5),Offset(4, 5)], ArrowDir.left),
      _a([Offset(9, 0), Offset(9, 2)], ArrowDir.down),
      _a([ Offset(7, 3), Offset(7, 1)], ArrowDir.up),
      _a([Offset(4, 2), Offset(4, 3), Offset(3, 3),Offset(3, 2)], ArrowDir.up),
      _a([Offset(3, 10), Offset(7, 10),Offset(7, 9), Offset(8, 9),Offset(8, 10)], ArrowDir.down),
      _a([Offset(9, 10), Offset(9, 8),Offset(8, 8), Offset(8, 7),Offset(9, 7)], ArrowDir.right),
      _a([Offset(9, 6), Offset(9, 4),Offset(6, 4), Offset(6, 0),Offset(0, 0)], ArrowDir.left),
      _a([Offset(7,5), Offset(8, 5),Offset(8, 6), ], ArrowDir.down),
    ],
  );

  // ── Level 10: Escape Mastermind (11×11) ────────────────────
  _gid = 0;
  final l10 = Level(
    number: 10, rows: 11, cols: 11, title: 'Escape Mastermind',
    arrows: [
      _a([Offset(1, 1), Offset(8, 1), Offset(8, 3), Offset(6, 3)], ArrowDir.left),
      _a([Offset(0, 2), Offset(0, 10), Offset(9, 10)], ArrowDir.right),
      _a([Offset(2, 3), Offset(5, 3), Offset(5, 7), Offset(2, 7)], ArrowDir.left),
      _a([Offset(3, 2), Offset(3, 5), Offset(1, 5), Offset(1, 9)], ArrowDir.down),
      _a([Offset(4, 9), Offset(7, 9), Offset(7, 10), Offset(9, 10)], ArrowDir.right),
      _a([Offset(7, 2), Offset(9, 2), Offset(9, 4), Offset(8, 4)], ArrowDir.left),
      _s(2, 9, ArrowDir.left),
      _s(4, 10, ArrowDir.down),
      _s(9, 8, ArrowDir.right),
    ],
  );

  return [l1, l2, l3, l4, l5, l6, l7, l8, l9, l10];
}

// ═══════════════════════════════════════════════════════════
// BLOC STATE & EVENTS
// ═══════════════════════════════════════════════════════════

abstract class PuzzleEvent {
  const PuzzleEvent();
}
class LoadLevel extends PuzzleEvent { final int idx; const LoadLevel(this.idx); }
class TapArrow extends PuzzleEvent { final int id; const TapArrow(this.id); }
class UseHint extends PuzzleEvent { const UseHint(); }
class RestartLevel extends PuzzleEvent { const RestartLevel(); }
class NextLevel extends PuzzleEvent { const NextLevel(); }
class ClearWrong extends PuzzleEvent { const ClearWrong(); }

enum PuzzleStatus { playing, levelComplete, gameOver, allDone }

class PuzzleState {
  final Level level;
  final List<ArrowCell> arrows;
  final int lives;
  final int maxLives;
  final int hintId;
  final int wrongId;
  final PuzzleStatus status;
  final int levelIndex;
  final int totalLevels;

  const PuzzleState({
    required this.level,
    required this.arrows,
    required this.lives,
    required this.maxLives,
    required this.hintId,
    required this.wrongId,
    required this.status,
    required this.levelIndex,
    required this.totalLevels,
  });

  int get removedCount => arrows.where((a) => a.removed).length;
  int get totalCount => arrows.length;

  PuzzleState copyWith({
    List<ArrowCell>? arrows,
    int? lives,
    int? hintId,
    int? wrongId,
    PuzzleStatus? status,
  }) => PuzzleState(
    level: level,
    arrows: arrows ?? this.arrows,
    lives: lives ?? this.lives,
    maxLives: maxLives,
    hintId: hintId ?? this.hintId,
    wrongId: wrongId ?? this.wrongId,
    status: status ?? this.status,
    levelIndex: levelIndex,
    totalLevels: totalLevels,
  );
}

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  final List<Level> levels;

  PuzzleBloc({required this.levels}) : super(_makeState(levels, 0)) {
    on<LoadLevel>((e, emit) => emit(_makeState(levels, e.idx)));
    on<RestartLevel>((e, emit) => emit(_makeState(levels, state.levelIndex)));
    on<NextLevel>((e, emit) {
      final n = state.levelIndex + 1;
      if (n < levels.length) emit(_makeState(levels, n));
    });
    on<ClearWrong>((e, emit) => emit(state.copyWith(wrongId: -1)));
    on<TapArrow>(_onTap);
    on<UseHint>(_onHint);
  }

  static PuzzleState _makeState(List<Level> lvls, int idx) => PuzzleState(
    level: lvls[idx],
    arrows: List<ArrowCell>.from(lvls[idx].arrows),
    lives: 5, maxLives: 5,
    hintId: -1, wrongId: -1,
    status: PuzzleStatus.playing,
    levelIndex: idx,
    totalLevels: lvls.length,
  );

  List<(int, int)> getOccupiedCells(List<Offset> path) {
    final cells = <(int, int)>{};
    if (path.isEmpty) return [];

    for (int i = 0; i < path.length - 1; i++) {
      final p1 = path[i];
      final p2 = path[i + 1];

      final minR = math.min(p1.dy.round(), p2.dy.round());
      final maxR = math.max(p1.dy.round(), p2.dy.round());
      final minC = math.min(p1.dx.round(), p2.dx.round());
      final maxC = math.max(p1.dx.round(), p2.dx.round());

      for (int r = minR; r <= maxR; r++) {
        for (int c = minC; c <= maxC; c++) {
          cells.add((r, c));
        }
      }
    }
    return cells.toList();
  }

  bool _canRemove(ArrowCell arrow, List<ArrowCell> arrows) {
    if (arrow.path.isEmpty) return true;
    final head = arrow.path.last;
    final (dr, dc) = arrow.dir.exitDelta();

    int r = head.dy.round();
    int c = head.dx.round();
    final visited = <String>{};

    while (true) {
      r += dr;
      c += dc;

      if (r < 0 || r >= state.level.rows || c < 0 || c >= state.level.cols) {
        return true;
      }

      final key = '$r,$c';
      if (visited.contains(key)) return false;
      visited.add(key);

      final blocker = arrows.any((a) {
        if (a.id == arrow.id || a.removed) return false;
        return getOccupiedCells(a.path).any((cell) => cell.$1 == r && cell.$2 == c);
      });

      if (blocker) return false;
    }
  }

  bool canRemoveArrow(ArrowCell arrow) => _canRemove(arrow, state.arrows);

  void _onTap(TapArrow event, Emitter<PuzzleState> emit) async {
    if (state.status != PuzzleStatus.playing) return;
    final arrows = List<ArrowCell>.from(state.arrows);
    final idx = arrows.indexWhere((a) => a.id == event.id);
    if (idx == -1 || arrows[idx].removed || arrows[idx].removing) return;

    if (_canRemove(arrows[idx], arrows)) {
      arrows[idx] = arrows[idx].copyWith(removing: true);
      emit(state.copyWith(arrows: arrows, hintId: -1, wrongId: -1));

      await Future.delayed(const Duration(milliseconds: 500));

      arrows[idx] = arrows[idx].copyWith(removed: true, removing: false);
      final allGone = arrows.every((a) => a.removed);
      final newStatus = allGone
          ? (state.levelIndex + 1 >= levels.length ? PuzzleStatus.allDone : PuzzleStatus.levelComplete)
          : PuzzleStatus.playing;
      emit(state.copyWith(arrows: arrows, status: newStatus));
    } else {
      final newLives = state.lives - 1;
      emit(state.copyWith(
        lives: newLives,
        wrongId: event.id,
        hintId: -1,
        status: newLives <= 0 ? PuzzleStatus.gameOver : PuzzleStatus.playing,
      ));
      await Future.delayed(const Duration(milliseconds: 500));
      if (!emit.isDone) emit(state.copyWith(wrongId: -1));
    }
  }

  void _onHint(UseHint event, Emitter<PuzzleState> emit) {
    if (state.status != PuzzleStatus.playing) return;
    for (final a in state.arrows.where((x) => !x.removed && !x.removing)) {
      if (_canRemove(a, state.arrows)) {
        emit(state.copyWith(hintId: a.id, wrongId: -1));
        return;
      }
    }
  }
}

// ═══════════════════════════════════════════════════════════
// UI COMPONENTS
// ═══════════════════════════════════════════════════════════

class ArrowPuzzleApp extends StatelessWidget {
  const ArrowPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PuzzleBloc(levels: buildLevels()),
      child: MaterialApp(
        title: 'Arrows Escape',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          useMaterial3: true,
        ),
        home: const PuzzleScreen(),
      ),
    );
  }
}

class PuzzleScreen extends StatelessWidget {
  const PuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
          }, icon: Icon(Icons.arrow_back)),
        ),
        body: SafeArea(
          child: BlocBuilder<PuzzleBloc, PuzzleState>(
            builder: (ctx, state) => Column(
              children: [
                _Header(state: state),
                Expanded(child: _Body(state: state)),
                _Footer(state: state),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final PuzzleState state;
  const _Header({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40),
          Column(
            children: [
              Text('Level ${state.level.number}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
              Text(state.level.title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          Row(
            children: List.generate(state.maxLives, (i) => Icon(
              i < state.lives ? Icons.favorite : Icons.favorite_border,
              color: i < state.lives ? const Color(0xFFE53E3E) : const Color(0xFFE2E8F0),
              size: 20,
            )),
          )
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final PuzzleState state;
  const _Body({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.status == PuzzleStatus.levelComplete || state.status == PuzzleStatus.allDone) {
      return _LevelCompleteView(state: state);
    }
    if (state.status == PuzzleStatus.gameOver) {
      return _GameOverView(state: state);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: AspectRatio(
          aspectRatio: state.level.cols / state.level.rows,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                final cellW = constraints.maxWidth / state.level.cols;
                final cellH = constraints.maxHeight / state.level.rows;
                final bloc = context.read<PuzzleBloc>();

                final activeOccupied = state.arrows
                    .where((a) => !a.removed)
                    .expand((a) => bloc.getOccupiedCells(a.path))
                    .toSet();

                return Stack(
                  children: [
                    Positioned.fill(child: CustomPaint(painter: _GridPainter(rows: state.level.rows, cols: state.level.cols, activeOccupied: activeOccupied))),
                    // 2. 🧪 TESTING LAYER: Draws Whiteboard Grid Coordinates everywhere
                    Positioned.fill(
                      child: IgnorePointer( // IgnorePointer ensures this overlay doesn't block tap gestures
                        child: CustomPaint(
                          painter: _DebugMatrixPainter(
                            rows: state.level.rows,
                            cols: state.level.cols,
                            cellW: cellW,
                            cellH: cellH,
                          ),
                        ),
                      ),
                    ),
                    // 3. Arrow graphics tiles with dynamic Testing Colors 🧪
                    ...state.arrows.where((a) => !a.removed).map((arrow) {
                      // Look up if this arrow is currently allowed to escape
                      final bool isNextMove = context.read<PuzzleBloc>().canRemoveArrow(arrow);

                      // Determine testing colors
                      Color testingColor = const Color(0xFF1E293B); // Default: Slate/Black

                      if (arrow.removing) {
                        testingColor = Colors.blue; // 🔵 Currently moving
                      } else if (isNextMove) {
                        testingColor = Colors.green; // 🟢 TESTING: Ready to move next!
                      }

                      return _ArrowTile(
                        key: ValueKey(arrow.id),
                        arrow: arrow,
                        cellW: cellW,
                        cellH: cellH,
                        isHint: arrow.id == state.hintId,
                        isWrong: arrow.id == state.wrongId,
                        // Pass the calculated testing color into your arrow tile setup
                        colorOverride: testingColor,
                      );
                    }),
                    Positioned.fill(child: _GridButtonLayer(state: state, cellW: cellW, cellH: cellH)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _GridButtonLayer extends StatelessWidget {
  final PuzzleState state;
  final double cellW, cellH;
  const _GridButtonLayer({required this.state, required this.cellW, required this.cellH});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PuzzleBloc>();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        final col = (details.localPosition.dx / cellW).floor();
        final row = (details.localPosition.dy / cellH).floor();

        final tapped = bloc.state.arrows.firstWhere(
              (a) => !a.removed && bloc.getOccupiedCells(a.path).contains((row, col)),
          orElse: () => ArrowCell(id: -1, path: [], dir: ArrowDir.up),
        );
        if (tapped.id != -1) {
          bloc.add(TapArrow(tapped.id));
        }
      },
      child: const SizedBox.expand(),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// PAINTERS (GRID & ARROW)
// ═══════════════════════════════════════════════════════════

class _GridPainter extends CustomPainter {
  final int rows, cols;
  final Set<(int, int)> activeOccupied;
  const _GridPainter({required this.rows, required this.cols, required this.activeOccupied});

  @override
  void paint(Canvas canvas, Size size) {
    final cw = size.width / cols;
    final ch = size.height / rows;
    final dotPaint = Paint()..color = const Color(0xFFCBD5E0)..style = PaintingStyle.fill;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!activeOccupied.contains((r, c))) {
          canvas.drawCircle(Offset(c * cw + cw / 2, r * ch + ch / 2), 3.0, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.activeOccupied != activeOccupied;
}

class _ArrowTile extends StatefulWidget {
  final ArrowCell arrow;
  final double cellW, cellH;
  final bool isHint, isWrong;
  final Color colorOverride;
  const _ArrowTile({super.key, required this.arrow, required this.cellW, required this.cellH, required this.isHint, required this.isWrong, required this.colorOverride});

  @override
  State<_ArrowTile> createState() => _ArrowTileState();
}

class _ArrowTileState extends State<_ArrowTile> with TickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.arrow.removing ? 3000 : 800),
    );
    _progress = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOutCubic));

    if (widget.isHint || widget.isWrong) {
      _animCtrl.repeat(reverse: true);
    } else if (widget.arrow.removing) {
      _animCtrl.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _ArrowTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.arrow.removing && !oldWidget.arrow.removing) {
      _animCtrl.duration = const Duration(milliseconds: 450);
      _animCtrl.forward(from: 0.0);
    } else if ((widget.isHint && !oldWidget.isHint) || (widget.isWrong && !oldWidget.isWrong)) {
      _animCtrl.duration = const Duration(milliseconds: 400);
      _animCtrl.repeat(reverse: true);
    } else if (!widget.isHint && !widget.isWrong && !widget.arrow.removing && (oldWidget.isHint || oldWidget.isWrong)) {
      _animCtrl.stop();
      _animCtrl.reset();
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, child) {
          Color color = widget.colorOverride; // Premium slim dark charcoal standard lines
          if (widget.arrow.removing) {
            color = const Color(0xFF3182CE); // Highlighting sleek active sliding blue
          } else if (widget.isWrong) {
            color = Color.lerp(const Color(0xFF1A202C), const Color(0xFFE53E3E), _progress.value)!;
          } else if (widget.isHint) {
            color = Color.lerp(const Color(0xFF1A202C), const Color(0xFFDD6B20), _progress.value)!;
          }

          double tx = 0, ty = 0;
          if (widget.isWrong) {
            final shake = math.sin(_progress.value * math.pi * 4) * 4.0;
            if (widget.arrow.dir == ArrowDir.up || widget.arrow.dir == ArrowDir.down) tx = shake; else ty = shake;
          }

          return Transform.translate(
            offset: Offset(tx, ty),
            child: CustomPaint(
              painter: _ArrowPainter(
                path: widget.arrow.path,
                dir: widget.arrow.dir,
                color: color,
                cellW: widget.cellW,
                cellH: widget.cellH,
                progress: widget.arrow.removing ? _progress.value : 0.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
class _DebugMatrixPainter extends CustomPainter {
  final int rows;
  final int cols;
  final double cellW;
  final double cellH;

  _DebugMatrixPainter({
    required this.rows,
    required this.cols,
    required this.cellW,
    required this.cellH,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final double textX = c * cellW + cellW / 2;
        final double textY = r * cellH + cellH / 2;

        final matrixTextPainter = TextPainter(
          text: TextSpan(
            text: '$c,$r',
            style: TextStyle(
              color: Colors.blueGrey.withOpacity(0.4), // Faint blueprint look
              fontSize: 9,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.white.withOpacity(0.7), // Readable background badge
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        matrixTextPainter.paint(
          canvas,
          Offset(textX - matrixTextPainter.width / 2, textY - matrixTextPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DebugMatrixPainter oldDelegate) =>
      oldDelegate.rows != rows || oldDelegate.cols != cols;
}
class _ArrowPainter extends CustomPainter {
  final List<Offset> path;
  final ArrowDir dir;
  final Color color;
  final double cellW, cellH;
  final double progress;

  const _ArrowPainter({
    required this.path,
    required this.dir,
    required this.color,
    required this.cellW,
    required this.cellH,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (path.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0 // Exact original stroke width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // 1. Map all grid coordinates to screen pixel points
    final first = path.first; // <-- DEFINED HERE NOW to fix the 'first' undefined error
    final List<Offset> points = [];
    for (final pt in path) {
      points.add(Offset(pt.dx * cellW + cellW / 2, pt.dy * cellH + cellH / 2));
    }

    // Append the off-screen exit extension point
    final last = path.last;
    final lastX = last.dx * cellW + cellW / 2;
    final lastY = last.dy * cellH + cellH / 2;
    final (dr, dc) = dir.exitDelta();
    final exitDistance = math.max(size.width, size.height) * 2.0;
    points.add(Offset(lastX + dc * exitDistance, lastY + dr * exitDistance));

    // 2. Build the smooth base path by rounding the corner joints manually
    final extendedPath = Path();
    if (points.isNotEmpty) {
      extendedPath.moveTo(points.first.dx, points.first.dy);

      // Your updated fine-tuned corner radius setting
      final double cornerRadius = math.min(cellW, cellH) * 0.05;

      for (int i = 1; i < points.length - 1; i++) {
        final pPrev = points[i - 1];
        final pCurr = points[i];
        final pNext = points[i + 1];

        final v1 = pCurr - pPrev;
        final v2 = pNext - pCurr;

        final d1 = v1.distance;
        final d2 = v2.distance;

        // Ensure radius fits comfortably within the segment lengths
        final r = math.min(cornerRadius, math.min(d1 / 2, d2 / 2));

        if (r > 0) {
          final pStart = pCurr - (v1 / d1) * r;
          final pEnd = pCurr + (v2 / d2) * r;

          extendedPath.lineTo(pStart.dx, pStart.dy);
          extendedPath.quadraticBezierTo(pCurr.dx, pCurr.dy, pEnd.dx, pEnd.dy);
        } else {
          extendedPath.lineTo(pCurr.dx, pCurr.dy);
        }
      }
      extendedPath.lineTo(points.last.dx, points.last.dy);
    }

    // 3. Keep your exact original slithering movement calculation
    double baseLength = 0.0;
    for (int i = 0; i < points.length - 2; i++) {
      baseLength += (points[i + 1] - points[i]).distance;
    }
    final extendedMetrics = extendedPath.computeMetrics().toList();


    double extendedLength = 0.0;
    if (extendedMetrics.isNotEmpty) {
      extendedLength = extendedMetrics.first.length;
    }

    final double startDist = progress * extendedLength;
    final double endDist = baseLength + progress * (extendedLength - baseLength);

    Path drawnPath = Path();
    Offset? headPos;
    double headAngle = dir.angle;

    // Locate this block inside your _ArrowPainter paint() method:
    if (extendedMetrics.isNotEmpty) {
      final metric = extendedMetrics.first;
      if (endDist > startDist) {
        drawnPath = metric.extractPath(startDist, endDist);
      }
      final tangent = metric.getTangentForOffset(endDist);
      if (tangent != null) {
        headPos = tangent.position;
        // FIX: Ensure the head angle always matches the exit direction vector smoothly
        headAngle = math.atan2(tangent.vector.dy, tangent.vector.dx);
      }
    } else {
      // Fallback configuration
      drawnPath.moveTo(first.dx * cellW + cellW / 2, first.dy * cellH + cellH / 2);
      for (int i = 1; i < path.length; i++) {
        final pt = path[i];
        drawnPath.lineTo(pt.dx * cellW + cellW / 2, pt.dy * cellH + cellH / 2);
      }
      headPos = Offset(lastX, lastY);
      headAngle = dir.angle; // FIX: Fallback directly to the explicit arrow direction enum angle
    }

    // Draw the winding curved line shaft
    canvas.drawPath(drawnPath, paint);

    // 4. Draw matching stroke wings seamlessly fused at the absolute tip
    if (headPos != null) {
      canvas.save();
      canvas.translate(headPos.dx, headPos.dy);
      canvas.rotate(headAngle);

      final headPath = Path();
      const double hWidth = 6.5;
      const double hLength = 10.0;

      headPath.moveTo(-hLength, -hWidth);
      headPath.lineTo(0, 0);
      headPath.lineTo(-hLength, hWidth);

      canvas.drawPath(headPath, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ArrowPainter old) =>
      old.path != path ||
          old.dir != dir ||
          old.color != color ||
          old.progress != progress;
}// REFRESHED FOOTER CONTROL PANELS
// ═══════════════════════════════════════════════════════════

class _Footer extends StatelessWidget {
  final PuzzleState state;
  const _Footer({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PuzzleBloc>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDF2F7))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Btn(icon: Icons.refresh, label: 'Restart', onTap: () => bloc.add(const RestartLevel())),
          _ProgressCircle(removed: state.removedCount, total: state.totalCount),
          _Btn(icon: Icons.lightbulb_outline, label: 'Hint', activeColor: const Color(0xFFDD6B20), onTap: () => bloc.add(const UseHint())),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? activeColor;

  const _Btn({required this.icon, required this.label, required this.onTap, this.activeColor});

  @override
  Widget build(BuildContext context) {
    final col = activeColor ?? const Color(0xFF4A5568);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 50, height: 50, decoration: BoxDecoration(color: col.withOpacity(0.06), shape: BoxShape.circle), child: Icon(icon, color: col)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: col)),
        ],
      ),
    );
  }
}

class _ProgressCircle extends StatelessWidget {
  final int removed, total;
  const _ProgressCircle({required this.removed, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 50, height: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(value: total == 0 ? 0 : removed / total, strokeWidth: 3.5, backgroundColor: const Color(0xFFE2E8F0), valueColor: const AlwaysStoppedAnimation(Color(0xFF38A169))),
              Text('$removed/$total', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text('Progress', style: TextStyle(fontSize: 12, color: Color(0xFF718096))),
      ],
    );
  }
}

class _LevelCompleteView extends StatelessWidget {
  final PuzzleState state;
  const _LevelCompleteView({required this.state});

  @override
  Widget build(BuildContext context) {
    final isLast = state.status == PuzzleStatus.allDone;
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isLast ? '🏆' : '🎉', style: const TextStyle(fontSize: 50)),
            const SizedBox(height: 16),
            Text(isLast ? 'Master Escape!' : 'Level Cleared!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            if (!isLast) ElevatedButton(
              onPressed: () => context.read<PuzzleBloc>().add(const NextLevel()),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A202C), foregroundColor: Colors.white),
              child: const Text('Next Level'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameOverView extends StatelessWidget {
  final PuzzleState state;
  const _GameOverView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💔', style: TextStyle(fontSize: 50)),
            const SizedBox(height: 16),
            const Text('Game Over', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.read<PuzzleBloc>().add(const RestartLevel()),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53E3E), foregroundColor: Colors.white),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
