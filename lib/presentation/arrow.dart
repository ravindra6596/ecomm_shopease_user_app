// ============================================================
// ARROWS – PUZZLE ESCAPE  (Flutter BLoC, single file)
//
// pubspec.yaml dependencies:
//   flutter_bloc: ^8.1.6
//   equatable: ^2.0.5
//
// Run: flutter pub get && flutter run
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final int row;
  final int col;
  final ArrowDir dir;
  final bool removed;
  final bool removing;

  const ArrowCell({
    required this.id,
    required this.row,
    required this.col,
    required this.dir,
    this.removed = false,
    this.removing = false,
  });

  ArrowCell copyWith({bool? removed,bool? removing,}) => ArrowCell(
    id: id, row: row, col: col, dir: dir,
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
    List<PathLine> ? paths =[];
    Level({
    required this.number,
    required this.rows,
    required this.cols,
    required this.arrows,
    required this.title,
    this.paths
  });
}

// ═══════════════════════════════════════════════════════════
// LEVEL DATA — 5 levels
// ═══════════════════════════════════════════════════════════

int _gid = 0;
ArrowCell _a(int r, int c, ArrowDir d) => ArrowCell(id: _gid++, row: r, col: c, dir: d);

List<Level> buildLevels() {
  // ── Level 1: 4×4 ring ──────────────────────────────────
  _gid = 0;
  final l1 = Level(
    number: 1, rows: 3, cols: 3, title: 'Warm Up',
    arrows: [
      _a(0, 1, ArrowDir.right),
      _a(1, 1, ArrowDir.right),
      _a(2, 1, ArrowDir.right),
    ],
  );

  // ── Level 2: 4×4 ring ──────────────────────────────────
  _gid = 0;
  final l2 = Level(
    number: 2, rows: 4, cols: 4, title: 'Warm Up',
    arrows: [
      _a(0, 0, ArrowDir.right),
      _a(0, 3, ArrowDir.down),
      _a(3, 3, ArrowDir.left),
      _a(3, 1, ArrowDir.up),
    ],
  );
  // ── Level 3: 4×4 ring ──────────────────────────────────
  _gid = 0;
  final l3 = Level(
    number: 3, rows: 4, cols: 4, title: 'Warm Up',
    arrows: [
      _a(0, 0, ArrowDir.right),
      _a(0, 1, ArrowDir.right),
      _a(0, 2, ArrowDir.down),
      _a(0, 3, ArrowDir.down),

      _a(1, 3, ArrowDir.down),
      _a(2, 3, ArrowDir.left),

      _a(3, 0, ArrowDir.up),
      _a(3, 1, ArrowDir.left),
    ],
  );

// ── Level 4: 5×5 cross ─────────────────────────────────
  _gid = 0;
  final l4 = Level(
    number: 4, rows: 5, cols: 5, title: 'Cross Roads',
    arrows: [
      _a(0, 2, ArrowDir.left),
      _a(1, 1, ArrowDir.right),
      _a(1, 3, ArrowDir.down),
      _a(1, 2, ArrowDir.right),
      _a(2, 0, ArrowDir.right),
      _a(2, 1, ArrowDir.up),
      _a(2, 2, ArrowDir.right),
      _a(2, 4, ArrowDir.right),
      _a(3, 1, ArrowDir.up),
      _a(3, 2, ArrowDir.left),
      _a(4, 2, ArrowDir.up),
    ],
  );

// ── Level 3: 5×5 spiral ────────────────────────────────
  _gid = 0;
  final l5 = Level(
    number: 5, rows: 5, cols: 5, title: 'Spiral',
    arrows: [

      _a(0, 0, ArrowDir.right),
      _a(0, 1, ArrowDir.right),
      _a(0, 2, ArrowDir.up),
      _a(0, 3, ArrowDir.right),
      _a(0, 4, ArrowDir.down),

      _a(1, 0, ArrowDir.up),
      _a(1, 1, ArrowDir.right),
      _a(1, 2, ArrowDir.right),
      _a(1, 3, ArrowDir.down),
      _a(1, 4, ArrowDir.down),

      _a(2, 0, ArrowDir.up),
      _a(2, 1, ArrowDir.left),
      _a(2, 2, ArrowDir.down),
      _a(2, 3, ArrowDir.down),
      _a(2, 4, ArrowDir.right),

      _a(3, 0, ArrowDir.down),
      _a(3, 1, ArrowDir.up),
      _a(3, 2, ArrowDir.left),
      _a(3, 3, ArrowDir.right),
      _a(3, 4, ArrowDir.right),

      _a(4, 0, ArrowDir.left),
      _a(4, 1, ArrowDir.left),
      _a(4, 2, ArrowDir.left),
      _a(4, 3, ArrowDir.left),
      _a(4, 4, ArrowDir.left),

    ],
  );


  // return [l6];
  return [l1, l2, l3, l4, l5];
}

// ═══════════════════════════════════════════════════════════
// BLOC EVENTS
// ═══════════════════════════════════════════════════════════

abstract class PuzzleEvent  {
  const PuzzleEvent();
  List<Object?> get props => [];
}
class LoadLevel    extends PuzzleEvent { final int idx; const LoadLevel(this.idx); @override List<Object?> get props => [idx]; }
class TapArrow     extends PuzzleEvent { final int id;  const TapArrow(this.id);  @override List<Object?> get props => [id];  }
class UseHint      extends PuzzleEvent { const UseHint(); }
class RestartLevel extends PuzzleEvent { const RestartLevel(); }
class NextLevel    extends PuzzleEvent { const NextLevel(); }
class ClearWrong   extends PuzzleEvent { const ClearWrong(); }

// ═══════════════════════════════════════════════════════════
// BLOC STATE
// ═══════════════════════════════════════════════════════════

enum PuzzleStatus { playing, levelComplete, gameOver, allDone }

class PuzzleState   {
  final Level level;
  final List<ArrowCell> arrows;
  final int lives;
  final int maxLives;
  final int hintId;   // -1 = none
  final int wrongId;  // -1 = none
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
  int get totalCount   => arrows.length;

  PuzzleState copyWith({
    List<ArrowCell>? arrows,
    int? lives,
    int? hintId,
    int? wrongId,
    PuzzleStatus? status,
  }) => PuzzleState(
    level: level,
    arrows: arrows  ?? this.arrows,
    lives:  lives   ?? this.lives,
    maxLives: maxLives,
    hintId:  hintId  ?? this.hintId,
    wrongId: wrongId ?? this.wrongId,
    status:  status  ?? this.status,
    levelIndex: levelIndex,
    totalLevels: totalLevels,
  );

  List<Object?> get props =>
      [level, arrows, lives, hintId, wrongId, status, levelIndex];
}

// ═══════════════════════════════════════════════════════════
// BLOC
// ═══════════════════════════════════════════════════════════

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  final List<Level> levels;

  PuzzleBloc({required this.levels}) : super(_makeState(levels, 0)) {
    on<LoadLevel>    ((e, emit) => emit(_makeState(levels, e.idx)));
    on<RestartLevel> ((e, emit) => emit(_makeState(levels, state.levelIndex)));
    on<NextLevel>    ((e, emit) {
      final n = state.levelIndex + 1;
      if (n < levels.length) emit(_makeState(levels, n));
    });
    on<ClearWrong>   ((e, emit) => emit(state.copyWith(wrongId: -1)));
    on<TapArrow>     (_onTap);
    on<UseHint>      (_onHint);
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
  bool _canRemove(ArrowCell arrow, List<ArrowCell> arrows) {
    final visited = <String>{};

    int r = arrow.row;
    int c = arrow.col;

    final (dr, dc) = arrow.dir.exitDelta();

    while (true) {
      r += dr;
      c += dc;

      final key = '$r,$c';
      if (visited.contains(key)) return false;
      visited.add(key);

      // out of bounds → safe
      if (r < 0 || r >= state.level.rows ||
          c < 0 || c >= state.level.cols) {
        return true;
      }

      // if another arrow exists → BLOCK
      final blocker = arrows.any(
            (a) => !a.removed && a.row == r && a.col == c,
      );

      if (blocker) return false;
    }
  }
  bool _canRemoves(ArrowCell arrow, List<ArrowCell> arrows) {
    final (dr, dc) = arrow.dir.exitDelta();
    final er = arrow.row + dr;
    final ec = arrow.col + dc;
    if (er < 0 || er >= state.level.rows || ec < 0 || ec >= state.level.cols) return true;
    return !arrows.any((a) => !a.removed && a.row == er && a.col == ec);
  }
  bool canRemoveArrow(ArrowCell arrow) {
    return _canRemove(arrow, state.arrows);
  }
  ArrowCell? _firstRemovable(List<ArrowCell> arrows) {
    for (final a in arrows.where((x) => !x.removed)) {
      if (_canRemove(a, arrows)) return a;
    }
    return null;
  }

  void _onTap(TapArrow event, Emitter<PuzzleState> emit) async {
    if (state.status != PuzzleStatus.playing) return;
    final arrows = List<ArrowCell>.from(state.arrows);
    final idx = arrows.indexWhere((a) => a.id == event.id);
    if (idx == -1 || arrows[idx].removed) return;

    if (_canRemove(arrows[idx], arrows)) {
      // arrows[idx] = arrows[idx].copyWith(removed: true);
      arrows[idx] = arrows[idx].copyWith(removing: true);
      emit(state.copyWith(arrows: arrows));
      await Future.delayed(const Duration(milliseconds: 600));
      arrows[idx] = arrows[idx].copyWith(removed: true);
      final allGone = arrows.every((a) => a.removed);
      final newStatus = allGone
          ? (state.levelIndex + 1 >= levels.length
          ? PuzzleStatus.allDone
          : PuzzleStatus.levelComplete)
          : PuzzleStatus.playing;
      emit(state.copyWith(arrows: arrows, hintId: -1, wrongId: -1, status: newStatus));
    } else {
      final newLives = state.lives - 1;
      emit(state.copyWith(
        lives: newLives,
        wrongId: event.id,
        hintId: -1,
        status: newLives <= 0 ? PuzzleStatus.gameOver : PuzzleStatus.playing,
      ));
      // Auto-clear wrong highlight after 600ms
      await Future.delayed(const Duration(milliseconds: 600));
      if (!emit.isDone) emit(state.copyWith(wrongId: -1));
    }
  }

  void _onHint(UseHint event, Emitter<PuzzleState> emit) {
    if (state.status != PuzzleStatus.playing) return;
    final hint = _firstRemovable(state.arrows);
    if (hint != null) emit(state.copyWith(hintId: hint.id, wrongId: -1));
  }
}

// ═══════════════════════════════════════════════════════════
// APP ROOT
// ═══════════════════════════════════════════════════════════

class ArrowPuzzleApp extends StatelessWidget {
  const ArrowPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PuzzleBloc(levels: buildLevels()),
      child: MaterialApp(
        title: 'Arrows – Puzzle Escape',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFF2EFE9),
          useMaterial3: true,
        ),
        home: const PuzzleScreen(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// PUZZLE SCREEN
// ═══════════════════════════════════════════════════════════

class PuzzleScreen extends StatelessWidget {
  const PuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EFE9),
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
    );
  }
}

// ═══════════════════════════════════════════════════════════
// HEADER
// ═══════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  final PuzzleState state;
  const _Header({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back icon
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 16, color: Color(0xFF444444)),
            ),
          ),
          // Title
          Column(
            children: [
              Text(
                'Level ${state.level.number}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                state.level.title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          // Hearts
          Row(
            children: List.generate(
              state.maxLives,
                  (i) => Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  i < state.lives ? Icons.favorite : Icons.favorite_border,
                  color: i < state.lives
                      ? const Color(0xFFE53935)
                      : const Color(0xFFDDDDDD),
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// BODY
// ═══════════════════════════════════════════════════════════

class _Body extends StatelessWidget {
  final PuzzleState state;
  const _Body({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.status == PuzzleStatus.levelComplete ||
        state.status == PuzzleStatus.allDone) {
      return _LevelCompleteView(state: state);
    }
    if (state.status == PuzzleStatus.gameOver) {
      return _GameOverView(state: state);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420, maxHeight: 560),
          child: AspectRatio(
            aspectRatio: state.level.cols / state.level.rows,
            child: _MazeWidget(state: state),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// MAZE WIDGET  — white card with grid + arrows
// ═══════════════════════════════════════════════════════════

class _MazeWidget extends StatelessWidget {
  final PuzzleState state;
  const _MazeWidget({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,           // ← explicit white background
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            final W = constraints.maxWidth;
            final H = constraints.maxHeight;
            final cellW = W / state.level.cols;
            final cellH = H / state.level.rows;

            return SizedBox(
              width: W,
              height: H,
              child: Stack(
                children: [

                  // ── White fill (safety net) ──────────────
                  Positioned.fill(
                    child: ColoredBox(color: Colors.white),
                  ),
                  // ── GRID CELLS (ADD THIS) ──
                  Positioned.fill(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: state.level.cols,
                      ),
                      itemCount: state.level.rows * state.level.cols,
                      itemBuilder: (context, index) {
                        final row = index ~/ state.level.cols;
                        final col = index % state.level.cols;
                        return Text('R-$row,C-$col',textAlign: TextAlign.center,);
                      },
                    ),
                  ),
                  // ── Grid painter ──────────────────────────
                  /*Positioned.fill(
                    child: CustomPaint(
                      painter: _GridPainter(
                        rows: state.level.rows,
                        cols: state.level.cols,
                      ),
                    ),
                  ),*/
                  Positioned.fill(
                    child: CustomPaint(
                      painter: MazePathPainter(
                        state.level.paths ?? [],
                      ),
                    ),
                  ),
                  // ── Arrow widgets ─────────────────────────
                  ...state.arrows
                      .where((a) => !a.removed)
                      .map((arrow) => _ArrowTile(
                    key: ValueKey(arrow.id),
                    arrow: arrow,
                    cellW: cellW,
                    cellH: cellH,
                    rows: state.level.rows,
                    cols: state.level.cols,
                    isHint:  arrow.id == state.hintId,
                    isWrong: arrow.id == state.wrongId,
                    isBlocked: !context.read<PuzzleBloc>()
                        .canRemoveArrow(arrow),
                  )),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// GRID PAINTER — draws faint grid lines + thick border
// ═══════════════════════════════════════════════════════════

class _GridPainter extends CustomPainter {
  final int rows, cols;
  const _GridPainter({required this.rows, required this.cols});

  @override
  void paint(Canvas canvas, Size size) {
    // Fill white (belt-and-suspenders)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    final cw = size.width  / cols;
    final ch = size.height / rows;

    // Faint grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFE8E3D8)
      ..strokeWidth = 0.8;

    for (int r = 1; r < rows; r++) {
      canvas.drawLine(Offset(0, r * ch), Offset(size.width, r * ch), gridPaint);
    }
    for (int c = 1; c < cols; c++) {
      canvas.drawLine(Offset(c * cw, 0), Offset(c * cw, size.height), gridPaint);
    }

    // Outer border
    final borderPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
        const Radius.circular(16),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.rows != rows || old.cols != cols;
}

// ═══════════════════════════════════════════════════════════
// ARROW TILE
// ═══════════════════════════════════════════════════════════

class _ArrowTile extends StatefulWidget {
  final ArrowCell arrow;
  final double cellW, cellH;
  final bool isHint, isWrong,isBlocked;
  final int rows;
  final int cols;
  const _ArrowTile({
    super.key,
    required this.arrow,
    required this.cellW,
    required this.cellH,
    required this.isHint,
    required this.isWrong,
    required this.isBlocked,
    required this.rows,
    required this.cols,
  });

  @override
  State<_ArrowTile> createState() => _ArrowTileState();
}

class _ArrowTileState extends State<_ArrowTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _blink;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..repeat(reverse: true);
    _blink = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left:   widget.arrow.col * widget.cellW,
      top:    widget.arrow.row * widget.cellH,
      width:  widget.cellW,
      height: widget.cellH,
      child: InkWell(
        onTap: () =>
            context.read<PuzzleBloc>().add(TapArrow(widget.arrow.id)),
        child: AnimatedBuilder(
          animation: _blink,
          builder: (_, __) {
            final Color arrowColor;
            if (widget.isWrong) {
              arrowColor = Color.lerp(
                const Color(0xFF1A1A1A),
                const Color(0xFFE53935),
                _blink.value,
              )!;
            }
            // hide it if not need block arrow
            else if (widget.isBlocked) {
              arrowColor = Colors.red.shade300;
            }
            else if (widget.isHint) {
              arrowColor = Color.lerp(
                const Color(0xFF1A1A1A),
                const Color(0xFFF5A623),
                _blink.value,
              )!;
            } else {
              arrowColor = const Color(0xFF1A1A1A);
            }

            return AnimatedSlide(
              duration: const Duration(milliseconds: 600),
              offset: widget.arrow.removing
                  ? getRemoveOffset()
                  : Offset.zero,
              child: CustomPaint(
                painter: _ArrowPainter(
                  dir:   widget.arrow.dir,
                  color: arrowColor,
                  cellW: widget.cellW,
                  cellH: widget.cellH,
                ),
              ),


            );
          },
        ),
      ),
    );
  }
  Offset getRemoveOffset() {
    switch (widget.arrow.dir) {
      case ArrowDir.right:
        return Offset(
          (widget.cols - widget.arrow.col).toDouble(),
          0,
        );

      case ArrowDir.left:
        return Offset(
          -(widget.arrow.col + 1).toDouble(),
          0,
        );

      case ArrowDir.down:
        return Offset(
          0,
          (widget.rows - widget.arrow.row).toDouble(),
        );

      case ArrowDir.up:
        return Offset(
          0,
          -(widget.arrow.row + 1).toDouble(),
        );
    }
  }
  Offset getRemoveOffsets(ArrowDir dir) {
    switch (dir) {
      case ArrowDir.right:
        return const Offset(1.0, 0.0);   // move right
      case ArrowDir.left:
        return const Offset(-1.0, 0.0);  // move left
      case ArrowDir.up:
        return const Offset(0.0, -1.0);  // move up
      case ArrowDir.down:
        return const Offset(0.0, 1.0);   // move down
    }
  }
  double getTargetLeft() {
    switch (widget.arrow.dir) {
      case ArrowDir.right:
        return widget.arrow.col * widget.cellW + (widget.cellW * 5);
      case ArrowDir.left:
        return widget.arrow.col * widget.cellW - (widget.cellW * 5);
      default:
        return widget.arrow.col * widget.cellW;
    }
  }

  double getTargetTop() {
    switch (widget.arrow.dir) {
      case ArrowDir.down:
        return widget.arrow.row * widget.cellH + (widget.cellH * 5);
      case ArrowDir.up:
        return widget.arrow.row * widget.cellH - (widget.cellH * 5);
      default:
        return widget.arrow.row * widget.cellH;
    }
  }
}

// ═══════════════════════════════════════════════════════════
// ARROW PAINTER
// Thin-line arrow matching the game screenshots:
//   ──────>   (shaft + two-line arrowhead)
// ═══════════════════════════════════════════════════════════

class _ArrowPainter extends CustomPainter {
  final ArrowDir dir;
  final Color color;
  final double cellW, cellH;

  const _ArrowPainter({
    required this.dir,
    required this.color,
    required this.cellW,
    required this.cellH,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap  = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cx = size.width  / 2;
    final cy = size.height / 2;

    // Dimensions relative to the smaller cell dimension
    final minDim   = math.min(size.width, size.height);
    final shaftLen = minDim * .45;   // half-shaft length each side
    final headLen  = minDim * .1;   // arrowhead arm length
    const headAngle = 0.45;           // radians ≈ 26°

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(dir.angle); // right=0, down=π/2, left=π, up=-π/2

    // Shaft: from left to just before tip
    canvas.drawLine(
      Offset(-shaftLen, 0),
      Offset(shaftLen, 0),
      paint,
    );

    // Arrowhead tip position
    final tipX = shaftLen;

    // Two arrowhead arms
    canvas.drawLine(
      Offset(tipX, 0),
      Offset(tipX - headLen * math.cos(headAngle),
          headLen * math.sin(headAngle)),
      paint,
    );
    canvas.drawLine(
      Offset(tipX, 0),
      Offset(tipX - headLen * math.cos(headAngle),
          -headLen * math.sin(headAngle)),
      paint,
    );

    canvas.restore();
  }



  @override
  bool shouldRepaint(_ArrowPainter o) =>
      o.dir != dir || o.color != color;
}

// ═══════════════════════════════════════════════════════════
// FOOTER
// ═══════════════════════════════════════════════════════════

class _Footer extends StatelessWidget {
  final PuzzleState state;
  const _Footer({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PuzzleBloc>();
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
      decoration: const BoxDecoration(
        color: Color(0xFFF2EFE9),
        border: Border(top: BorderSide(color: Color(0xFFDDD8CC), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _FooterBtn(
            icon: Icons.refresh_rounded,
            label: 'Restart',
            onTap: () => bloc.add(const RestartLevel()),
          ),
          _ProgressWidget(
            removed: state.removedCount,
            total:   state.totalCount,
          ),
          _FooterBtn(
            icon: Icons.lightbulb_outline_rounded,
            label: 'Hint',
            iconColor: const Color(0xFFF5A623),
            labelColor: const Color(0xFFF5A623),
            bgColor: const Color(0xFFFFF3DC),
            onTap: () => bloc.add(const UseHint()),
          ),
        ],
      ),
    );
  }
}

class _FooterBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final Color? bgColor;

  const _FooterBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final ic = iconColor  ?? const Color(0xFF555555);
    final lc = labelColor ?? const Color(0xFF555555);
    final bg = bgColor    ?? const Color(0xFFECE8E0);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: ic, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: lc,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressWidget extends StatelessWidget {
  final int removed, total;
  const _ProgressWidget({required this.removed, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : removed / total;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 52, height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: pct,
                strokeWidth: 4,
                backgroundColor: const Color(0xFFDDD8CC),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF4CAF50)),
              ),
              Text(
                '$removed/$total',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Progress',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF555555),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// OVERLAYS
// ═══════════════════════════════════════════════════════════

class _LevelCompleteView extends StatelessWidget {
  final PuzzleState state;
  const _LevelCompleteView({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PuzzleBloc>();
    final isLast = state.status == PuzzleStatus.allDone;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Container(
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(
                isLast ? 'You Win!' : 'Level Complete!',
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 8),
              Text(
                isLast
                    ? 'Amazing! All 5 levels cleared!'
                    : 'Great solve! Ready for more?',
                style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (!isLast)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => bloc.add(const NextLevel()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Next Level →',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => bloc.add(const RestartLevel()),
                child: const Text('Play Again',
                    style: TextStyle(
                        fontSize: 14, color: Color(0xFF999999))),
              ),
            ],
          ),
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
    final bloc = context.read<PuzzleBloc>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Container(
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💔', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text('Game Over',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A))),
              const SizedBox(height: 8),
              const Text(
                'You ran out of lives.\nTry again!',
                style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => bloc.add(const RestartLevel()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Try Again',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PathLine {
  final Offset start;
  final Offset end;

  const PathLine({
    required this.start,
    required this.end,
  });
}
class MazePathPainter extends CustomPainter {
  final List<PathLine> paths;

  MazePathPainter(this.paths);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (final path in paths) {
      canvas.drawLine(
        path.start,
        path.end,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}