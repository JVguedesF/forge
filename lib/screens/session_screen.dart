import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';

// ── Enum de modo de sessão
enum SessionMode { musculacao, timed, corrida }

class SessionScreen extends ConsumerStatefulWidget {
  final SessionMode mode;
  const SessionScreen({super.key, this.mode = SessionMode.musculacao});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  late SessionMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return switch (_mode) {
      SessionMode.musculacao =>
        _MuscSession(theme: theme, onEnd: () => _goSummary(context)),
      SessionMode.timed =>
        _TimedSession(theme: theme, onEnd: () => _goSummary(context)),
      SessionMode.corrida =>
        _CorridaSession(theme: theme, onEnd: () => _showForm(context)),
    };
  }

  void _goSummary(BuildContext context) =>
      context.pushReplacement('/session/summary');
  void _showForm(BuildContext context) => context.push('/session/form');
}

// ════════════════════════════════════
// MUSCULAÇÃO
// ════════════════════════════════════
class _MuscSession extends ConsumerStatefulWidget {
  final ForgeTheme theme;
  final VoidCallback onEnd;
  const _MuscSession({required this.theme, required this.onEnd});

  @override
  ConsumerState<_MuscSession> createState() => _MuscSessionState();
}

class _MuscSessionState extends ConsumerState<_MuscSession> {
  int _elapsed = 0;
  int _rest = 0;
  Timer? _timer;
  int _activeSet = 2;

  final _sets = [
    _SetData(prev: '80kg×9', kg: '82', reps: '9', done: true),
    _SetData(prev: '80kg×8', kg: '82', reps: '8', done: true),
    _SetData(prev: '80kg×9', kg: '82', reps: '', done: false, active: true),
    _SetData(prev: '80kg×8', kg: '', reps: '', done: false),
  ];

  @override
  void initState() {
    super.initState();
    _elapsed = 18 * 60 + 24;
    _rest = 107;
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setState(() {
              _elapsed++;
              if (_rest > 0) _rest--;
            }));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(int s) =>
      '${(s ~/ 3600).toString().padLeft(2, '0')}:${((s % 3600) ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
  String _fmtRest(int s) =>
      '${(s ~/ 60).toString().padLeft(1, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final accent = widget.theme.accent;
    final restPct = 1 - (_rest / 180);

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(children: [
                _XBtn(onTap: () => context.pop()),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(children: [
                  const Text('UPPER A',
                      style: TextStyle(
                          fontSize: 10,
                          color: ForgeColors.muted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1)),
                  Text(_fmt(_elapsed),
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 20,
                          color: accent,
                          letterSpacing: 0)),
                ])),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: ForgeColors.card,
                      border: Border.all(color: ForgeColors.border),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text('3 / 6',
                      style: TextStyle(fontSize: 11, color: ForgeColors.muted)),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                      value: .4,
                      minHeight: 4,
                      backgroundColor: ForgeColors.border,
                      valueColor:
                          AlwaysStoppedAnimation(ForgeColors.musculacaoLight))),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tags
                      Wrap(spacing: 4, children: [
                        _TagChip('Peito', color: ForgeColors.musculacaoLight),
                        _TagChip('Composto', color: accent),
                      ]),
                      const SizedBox(height: 6),
                      // Nome exercício
                      const Text('Supino\nReto',
                          style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 46,
                              color: ForgeColors.text,
                              height: .92)),
                      const SizedBox(height: 4),
                      const Text('Barra livre · 4×8-10 reps · 3 min descanso',
                          style: TextStyle(
                              fontSize: 12, color: ForgeColors.muted)),
                      const SizedBox(height: 6),
                      // Fase badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                            color: accent.withOpacity(.08),
                            border: Border.all(color: accent.withOpacity(.2)),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(LucideIcons.sun, color: accent, size: 12),
                          const SizedBox(width: 6),
                          Text('Fase 1 · 65–75% 1RM',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: accent,
                                  fontWeight: FontWeight.w600)),
                        ]),
                      ),
                      const SizedBox(height: 14),
                      // Tabela de séries
                      _SetTable(
                          sets: _sets, activeSet: _activeSet, accent: accent),
                      const SizedBox(height: 10),
                      // Timer de descanso
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: ForgeColors.card,
                            border: Border.all(color: ForgeColors.border),
                            borderRadius: BorderRadius.circular(14)),
                        child: Row(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_fmtRest(_rest),
                                    style: TextStyle(
                                        fontFamily: 'BebasNeue',
                                        fontSize: 28,
                                        color: accent,
                                        letterSpacing: 0)),
                                const Text('Descanso · 3 min',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: ForgeColors.muted)),
                              ]),
                          const SizedBox(width: 12),
                          Expanded(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: LinearProgressIndicator(
                                      value: restPct.clamp(0, 1),
                                      minHeight: 4,
                                      backgroundColor: ForgeColors.border,
                                      valueColor:
                                          AlwaysStoppedAnimation(accent)))),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => setState(() => _rest = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  border: Border.all(color: ForgeColors.border),
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Text('Pular',
                                  style: TextStyle(
                                      fontSize: 11, color: ForgeColors.muted)),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      // Botão principal
                      GestureDetector(
                        onTap: widget.onEnd,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: ForgeColors.musculacao,
                              borderRadius: BorderRadius.circular(14)),
                          child: const Text('CONCLUIR SÉRIE 3 →',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: 20,
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {},
                                child: const Text('← Anterior',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ForgeColors.muted))),
                            const SizedBox(width: 28),
                            GestureDetector(
                                onTap: () {},
                                child: const Text('Pular →',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ForgeColors.muted))),
                          ]),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetData {
  final String prev, kg, reps;
  final bool done, active;
  const _SetData(
      {required this.prev,
      required this.kg,
      required this.reps,
      required this.done,
      this.active = false});
}

class _SetTable extends StatelessWidget {
  final List<_SetData> sets;
  final int activeSet;
  final Color accent;
  const _SetTable(
      {required this.sets, required this.activeSet, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: ForgeColors.surface,
            child: const Row(children: [
              SizedBox(
                  width: 28,
                  child: Text('#',
                      style: TextStyle(
                          fontSize: 9,
                          color: ForgeColors.muted,
                          fontWeight: FontWeight.w600))),
              Expanded(
                  child: Text('ANTERIOR',
                      style: TextStyle(
                          fontSize: 9,
                          color: ForgeColors.muted,
                          fontWeight: FontWeight.w600))),
              SizedBox(
                  width: 66,
                  child: Text('KG',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 9,
                          color: ForgeColors.muted,
                          fontWeight: FontWeight.w600))),
              SizedBox(
                  width: 66,
                  child: Text('REPS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 9,
                          color: ForgeColors.muted,
                          fontWeight: FontWeight.w600))),
              SizedBox(width: 30),
            ]),
          ),
          ...sets
              .asMap()
              .entries
              .map((e) => _SetRow(index: e.key, data: e.value, accent: accent)),
        ],
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  final int index;
  final _SetData data;
  final Color accent;
  const _SetRow(
      {required this.index, required this.data, required this.accent});

  @override
  Widget build(BuildContext context) {
    final isActive = data.active;
    final isDone = data.done;
    final isPending = !isActive && !isDone;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: isActive ? accent.withOpacity(.12) : Colors.transparent,
        border: Border(
          top: BorderSide(
              color: isActive ? accent.withOpacity(.3) : ForgeColors.border),
          left:
              isActive ? BorderSide(color: accent, width: 3) : BorderSide.none,
        ),
      ),
      child: Opacity(
        opacity: isPending ? .3 : 1,
        child: Row(children: [
          SizedBox(
              width: 28,
              child: Text('${index + 1}',
                  style: TextStyle(
                      fontSize: 13,
                      color: isActive ? accent : ForgeColors.muted,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal))),
          Expanded(
              child: Text(data.prev,
                  style: const TextStyle(
                      fontSize: 11, color: ForgeColors.muted2))),
          SizedBox(
              width: 66,
              child:
                  _SetCell(value: data.kg, active: isActive, accent: accent)),
          SizedBox(
              width: 66,
              child: _SetCell(
                  value: data.reps,
                  active: isActive,
                  accent: accent,
                  placeholder: '—')),
          SizedBox(
            width: 30,
            child: isDone
                ? Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                        color: Color(0xFF22c55e), shape: BoxShape.circle),
                    child:
                        const Icon(Icons.check, color: Colors.white, size: 13))
                : isActive
                    ? Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: accent, width: 2)),
                        child: Center(
                            child: Text('○',
                                style: TextStyle(fontSize: 11, color: accent))))
                    : Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: ForgeColors.muted3, width: 2))),
          ),
        ]),
      ),
    );
  }
}

class _SetCell extends StatelessWidget {
  final String value, placeholder;
  final bool active;
  final Color accent;
  const _SetCell(
      {required this.value,
      required this.active,
      required this.accent,
      this.placeholder = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: active
            ? accent.withOpacity(.12)
            : ForgeColors.border.withOpacity(.5),
        border: active ? Border.all(color: accent) : null,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
          child: Text(
        value.isNotEmpty ? value : placeholder,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: active ? accent : ForgeColors.text),
      )),
    );
  }
}

// ════════════════════════════════════
// TIMED (Mobilidade / Drills / Bola)
// ════════════════════════════════════
class _TimedSession extends ConsumerStatefulWidget {
  final ForgeTheme theme;
  final VoidCallback onEnd;
  const _TimedSession({required this.theme, required this.onEnd});

  @override
  ConsumerState<_TimedSession> createState() => _TimedSessionState();
}

class _TimedSessionState extends ConsumerState<_TimedSession> {
  int _elapsed = 8 * 60 + 15;
  int _countdown = 27;
  int _totalCountdown = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setState(() {
              _elapsed++;
              if (_countdown > 0) _countdown--;
            }));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(int s) =>
      '${(s ~/ 3600).toString().padLeft(2, '0')}:${((s % 3600) ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final color = ForgeColors.mobilidade;
    final colorLight = ForgeColors.mobilidadeLight;
    final pct = _countdown / _totalCountdown;
    const r = 62.0;
    const circumference = 2 * 3.14159 * r;
    final offset = circumference * (1 - pct);

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(children: [
                _XBtn(onTap: () => context.pop()),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(children: [
                  const Text('MOBILIDADE ROTINA A',
                      style: TextStyle(
                          fontSize: 10,
                          color: ForgeColors.muted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1)),
                  Text(_fmt(_elapsed),
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 20,
                          color: colorLight,
                          letterSpacing: 0)),
                ])),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: ForgeColors.card,
                      border: Border.all(color: ForgeColors.border),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text('3 / 12',
                      style: TextStyle(fontSize: 11, color: ForgeColors.muted)),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                      value: .25,
                      minHeight: 4,
                      backgroundColor: ForgeColors.border,
                      valueColor: AlwaysStoppedAnimation(color))),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(children: [
                    // Bloco badge
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                          color: color.withOpacity(.1),
                          border: Border.all(color: color.withOpacity(.28)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Text('🦵 Membros Inferiores',
                            style: TextStyle(
                                fontSize: 11,
                                color: colorLight,
                                fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Text('⚠ Escoliose',
                            style: TextStyle(fontSize: 10, color: color)),
                      ]),
                    ),
                    const SizedBox(height: 14),
                    Wrap(spacing: 4, children: [
                      _TagChip('Membros Inf.', color: colorLight),
                      const _TagChip('Alongamento'),
                    ]),
                    const SizedBox(height: 8),
                    const Text('Figura 4\nDeitado',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 38,
                            color: ForgeColors.text,
                            height: .95)),
                    const SizedBox(height: 4),
                    const Text('Cruze tornozelo sobre joelho, puxe coxa',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 12, color: ForgeColors.muted)),
                    const SizedBox(height: 10),
                    // Indicador de lado
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: colorLight, shape: BoxShape.circle)),
                      const SizedBox(width: 10),
                      Text('LADO ESQUERDO',
                          style: TextStyle(
                              fontSize: 12,
                              color: colorLight,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .5)),
                      const SizedBox(width: 10),
                      Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: ForgeColors.border,
                              shape: BoxShape.circle)),
                    ]),
                    const SizedBox(height: 22),
                    // Timer circular SVG
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(alignment: Alignment.center, children: [
                        Transform.rotate(
                          angle: -3.14159 / 2,
                          child: CustomPaint(
                            size: const Size(140, 140),
                            painter:
                                _CircleTimerPainter(pct: pct, color: color),
                          ),
                        ),
                        Column(mainAxisSize: MainAxisSize.min, children: [
                          Text('$_countdown',
                              style: const TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: 50,
                                  color: ForgeColors.text,
                                  letterSpacing: 0,
                                  height: 1)),
                          const Text('seg',
                              style: TextStyle(
                                  fontSize: 10, color: ForgeColors.muted)),
                        ]),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    // Preview próximo
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                          color: ForgeColors.card,
                          border: Border.all(color: ForgeColors.border),
                          borderRadius: BorderRadius.circular(12)),
                      child: RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: 'A seguir: ',
                            style: TextStyle(
                                fontSize: 10, color: ForgeColors.muted)),
                        TextSpan(
                            text: 'Figura 4 — Lado Direito',
                            style: TextStyle(
                                fontSize: 12,
                                color: ForgeColors.text,
                                fontWeight: FontWeight.w500)),
                      ])),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: widget.onEnd,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(14)),
                        child: const Text('CONCLUÍDO ✓',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'BebasNeue',
                                fontSize: 20,
                                color: Colors.white)),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleTimerPainter extends CustomPainter {
  final double pct;
  final Color color;
  const _CircleTimerPainter({required this.pct, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const r = 62.0;
    const strokeW = 7.0;
    const circumference = 2 * 3.14159265 * r;

    canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..color = ForgeColors.border
          ..strokeWidth = strokeW
          ..style = PaintingStyle.stroke);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -3.14159265 / 2,
      2 * 3.14159265 * pct,
      false,
      Paint()
        ..color = color
        ..strokeWidth = strokeW
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_CircleTimerPainter old) => old.pct != pct;
}

// ════════════════════════════════════
// CORRIDA
// ════════════════════════════════════
class _CorridaSession extends ConsumerStatefulWidget {
  final ForgeTheme theme;
  final VoidCallback onEnd;
  const _CorridaSession({required this.theme, required this.onEnd});

  @override
  ConsumerState<_CorridaSession> createState() => _CorridaSessionState();
}

class _CorridaSessionState extends ConsumerState<_CorridaSession> {
  int _elapsed = 42 * 60 + 18;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (_) => setState(() => _elapsed++));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    const color = ForgeColors.corrida;
    const colorLight = ForgeColors.corridaLight;

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(children: [
                _XBtn(onTap: () => context.pop()),
                const SizedBox(width: 12),
                const Expanded(
                    child: Text('Corrida Longa',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 20,
                            color: ForgeColors.text))),
                const SizedBox(width: 46),
              ]),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  Text(_fmt(_elapsed),
                      style: const TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 64,
                          color: ForgeColors.text,
                          letterSpacing: 0,
                          height: 1)),
                  const Text('tempo decorrido',
                      style: TextStyle(fontSize: 13, color: ForgeColors.muted)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                        color: ForgeColors.card,
                        border: Border.all(color: color.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Column(children: [
                        const Text('8 km',
                            style: TextStyle(
                                fontFamily: 'BebasNeue',
                                fontSize: 22,
                                color: colorLight,
                                letterSpacing: 0)),
                        const Text('meta',
                            style: TextStyle(
                                fontSize: 9, color: ForgeColors.muted)),
                      ]),
                      Container(
                          width: 1,
                          height: 36,
                          color: ForgeColors.border,
                          margin: const EdgeInsets.symmetric(horizontal: 24)),
                      Column(children: [
                        const Text('5:30',
                            style: TextStyle(
                                fontFamily: 'BebasNeue',
                                fontSize: 22,
                                color: colorLight,
                                letterSpacing: 0)),
                        const Text('pace alvo/km',
                            style: TextStyle(
                                fontSize: 9, color: ForgeColors.muted)),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        color: ForgeColors.card,
                        border: Border.all(color: ForgeColors.border),
                        borderRadius: BorderRadius.circular(14)),
                    clipBehavior: Clip.hardEdge,
                    child: Column(children: [
                      _StepRow(
                          done: true,
                          label: 'Aquecimento',
                          dist: '1 km',
                          color: color),
                      _StepRow(
                          current: true,
                          label: 'Corrida Principal',
                          dist: '6 km',
                          color: color),
                      _StepRow(
                          done: false,
                          label: 'Volta à Calma',
                          dist: '1 km',
                          color: color,
                          last: true),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: widget.onEnd,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(14)),
                      child: const Text('FINALIZAR SESSÃO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 20,
                              color: Colors.white)),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final bool done, current, last;
  final String label, dist;
  final Color color;
  const _StepRow(
      {this.done = false,
      this.current = false,
      this.last = false,
      required this.label,
      required this.dist,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: current ? color.withOpacity(.05) : Colors.transparent,
        border: Border(
          left: current ? BorderSide(color: color, width: 3) : BorderSide.none,
          bottom: last
              ? BorderSide.none
              : const BorderSide(color: ForgeColors.border),
        ),
      ),
      child: Row(children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: done
                ? const Color(0xFF22c55e)
                : current
                    ? color
                    : ForgeColors.border,
            shape: BoxShape.circle,
          ),
          child: done
              ? const Icon(Icons.check, color: Colors.white, size: 12)
              : current
                  ? const Icon(Icons.play_arrow, color: Colors.white, size: 10)
                  : null,
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: done
                        ? ForgeColors.muted
                        : current
                            ? ForgeColors.text
                            : ForgeColors.muted2,
                    fontWeight:
                        current ? FontWeight.w600 : FontWeight.normal))),
        Text(dist,
            style: TextStyle(
                fontSize: 12,
                color: done
                    ? ForgeColors.muted2
                    : current
                        ? ForgeColors.corridaLight
                        : ForgeColors.muted2)),
      ]),
    );
  }
}

// ════════════════════════════════════
// FORMULÁRIO PÓS-CORRIDA
// ════════════════════════════════════
class RunFormScreen extends ConsumerWidget {
  const RunFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    const color = ForgeColors.corrida;
    const colorLight = ForgeColors.corridaLight;

    final paces = ['5:45', '5:30', '5:28', '5:25'];

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Row(children: [
                _XBtn(onTap: () => context.pop(), icon: LucideIcons.arrow_left),
                const SizedBox(width: 12),
                const Expanded(
                    child: Text('Registrar Corrida',
                        style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 22,
                            color: ForgeColors.text))),
                GestureDetector(
                  onTap: () => context.pushReplacement('/session/summary'),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(10)),
                    child: const Text('SALVAR',
                        style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 15,
                            color: Colors.white)),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              const _SLabel('Km totais'),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                    color: ForgeColors.card,
                                    border: Border.all(color: color),
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Text('8.2',
                                    style: TextStyle(
                                        fontFamily: 'BebasNeue',
                                        fontSize: 24,
                                        color: colorLight,
                                        letterSpacing: 0)),
                              ),
                            ])),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              const _SLabel('Tempo total'),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                    color: ForgeColors.card,
                                    border: Border.all(color: color),
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Text('42:18',
                                    style: TextStyle(
                                        fontFamily: 'BebasNeue',
                                        fontSize: 24,
                                        color: colorLight,
                                        letterSpacing: 0)),
                              ),
                            ])),
                      ]),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 11),
                        decoration: BoxDecoration(
                            color: ForgeColors.card,
                            border: Border.all(color: ForgeColors.border),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Pace médio calculado',
                                  style: TextStyle(
                                      fontSize: 13, color: ForgeColors.muted)),
                              Text('5:09 /km',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: colorLight,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                      const SizedBox(height: 16),
                      const _SLabel('Pace por km'),
                      Container(
                        decoration: BoxDecoration(
                            color: ForgeColors.card,
                            border: Border.all(color: ForgeColors.border),
                            borderRadius: BorderRadius.circular(14)),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              color: ForgeColors.surface,
                              child: const Row(children: [
                                Expanded(
                                    child: Text('KM',
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: ForgeColors.muted,
                                            fontWeight: FontWeight.w600))),
                                Text('PACE',
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: ForgeColors.muted,
                                        fontWeight: FontWeight.w600)),
                              ]),
                            ),
                            ...paces.asMap().entries.map((e) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 9),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: const BorderSide(
                                              color: ForgeColors.border))),
                                  child: Row(children: [
                                    Expanded(
                                        child: Text('Km ${e.key + 1}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: ForgeColors.muted))),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: color.withOpacity(.1),
                                          border: Border.all(
                                              color: color.withOpacity(.3)),
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: Text(e.value,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: colorLight,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ]),
                                )),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 9),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: ForgeColors.border))),
                              child: Row(children: [
                                const Expanded(
                                    child: Text('Km 5+',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: ForgeColors.muted))),
                                Opacity(
                                    opacity: .5,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: color.withOpacity(.1),
                                          border: Border.all(
                                              color: color.withOpacity(.3)),
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: const Text('—',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: colorLight,
                                              fontWeight: FontWeight.w600)),
                                    )),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════
// RESUMO
// ════════════════════════════════════
class SessionSummaryScreen extends ConsumerStatefulWidget {
  const SessionSummaryScreen({super.key});

  @override
  ConsumerState<SessionSummaryScreen> createState() =>
      _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends ConsumerState<SessionSummaryScreen> {
  int? _effort;

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Check + título
              Center(
                  child: Column(children: [
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: theme.accent.withOpacity(.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.accent, width: 2)),
                  child: Icon(Icons.check, color: theme.accent, size: 28),
                ),
                const SizedBox(height: 12),
                const Text('Treino Concluído!',
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 32,
                        color: ForgeColors.text)),
                const Text('Upper A · 52 min',
                    style: TextStyle(fontSize: 13, color: ForgeColors.muted)),
              ])),
              const SizedBox(height: 24),
              // Stats grid
              Row(children: [
                _StatMini(
                    value: '52 min', label: 'Tempo', accent: theme.accent),
                const SizedBox(width: 8),
                _StatMini(
                    value: '6.240 kg', label: 'Volume', accent: theme.accent),
                const SizedBox(width: 8),
                _StatMini(value: '18', label: 'Séries', accent: theme.accent),
              ]),
              const SizedBox(height: 14),
              // Ativo vs descanso
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: ForgeColors.card,
                    border: Border.all(color: ForgeColors.border),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Expanded(
                      child: Column(children: [
                    const Text('38 min',
                        style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 22,
                            color: Color(0xFF22c55e),
                            letterSpacing: 0)),
                    const Text('ativo',
                        style:
                            TextStyle(fontSize: 10, color: ForgeColors.muted)),
                  ])),
                  Container(width: 1, height: 32, color: ForgeColors.border),
                  Expanded(
                      child: Column(children: [
                    const Text('14 min',
                        style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 22,
                            color: ForgeColors.muted2,
                            letterSpacing: 0)),
                    const Text('descanso',
                        style:
                            TextStyle(fontSize: 10, color: ForgeColors.muted2)),
                  ])),
                ]),
              ),
              const SizedBox(height: 18),
              // Esforço
              const _SLabel('Como foi o treino?'),
              Row(
                  children: ['😵', '😓', '😊', '💪', '🔥']
                      .asMap()
                      .entries
                      .map((e) => Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _effort = e.key),
                              child: Container(
                                margin:
                                    EdgeInsets.only(right: e.key < 4 ? 8 : 0),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _effort == e.key
                                      ? theme.accent.withOpacity(.12)
                                      : ForgeColors.card,
                                  border: Border.all(
                                      color: _effort == e.key
                                          ? theme.accent
                                          : ForgeColors.border),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(e.value,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 20)),
                              ),
                            ),
                          ))
                      .toList()),
              const SizedBox(height: 20),
              // Notas
              const _SLabel('Notas'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                constraints: const BoxConstraints(minHeight: 72),
                decoration: BoxDecoration(
                    color: ForgeColors.card,
                    border: Border.all(color: ForgeColors.border),
                    borderRadius: BorderRadius.circular(12)),
                child: const Text('Anotações opcionais...',
                    style: TextStyle(fontSize: 13, color: ForgeColors.muted)),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => context.go('/home'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: theme.accent,
                      borderRadius: BorderRadius.circular(14)),
                  child: Text('SALVAR SESSÃO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 20,
                          color: theme.id == 'neon'
                              ? Colors.black
                              : ForgeColors.bg)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared widgets
class _TagChip extends StatelessWidget {
  final String label;
  final Color? color;
  const _TagChip(this.label, {this.color});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(right: 4, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
            color: (color ?? ForgeColors.muted).withOpacity(.1),
            borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: TextStyle(
                fontSize: 9,
                color: color ?? ForgeColors.muted,
                fontWeight: FontWeight.w500)),
      );
}

class _StatMini extends StatelessWidget {
  final String value, label;
  final Color accent;
  const _StatMini(
      {required this.value, required this.label, required this.accent});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
              color: ForgeColors.card,
              border: Border.all(color: ForgeColors.border),
              borderRadius: BorderRadius.circular(14)),
          child: Column(children: [
            Text(value,
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 20,
                    color: accent,
                    letterSpacing: 0)),
            Text(label,
                style: const TextStyle(fontSize: 10, color: ForgeColors.muted)),
          ]),
        ),
      );
}

class _SLabel extends StatelessWidget {
  final String text;
  const _SLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text.toUpperCase(),
            style: const TextStyle(
                fontSize: 9,
                color: ForgeColors.muted,
                letterSpacing: 2,
                fontWeight: FontWeight.w600)),
      );
}

class _XBtn extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const _XBtn({required this.onTap, this.icon = LucideIcons.x});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
              border: Border.all(color: ForgeColors.border),
              shape: BoxShape.circle),
          child: Icon(icon, color: ForgeColors.muted, size: 16),
        ),
      );
}
