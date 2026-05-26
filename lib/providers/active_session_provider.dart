import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/training_session.dart';
import '../data/models/enums.dart';

class ActiveSession {
  final int? workoutId;
  final String workoutName;
  final WorkoutType workoutType;
  final int workoutColorValue;
  final DateTime startTime;
  int durationSeconds;
  List<SessionExercise> exercises;
  double totalVolume;
  double totalDistanceKm;
  double avgPaceSeconds;
  List<double> kmPaces;
  int totalActiveSeconds;
  int? perceivedEffort;
  String? notes;

  ActiveSession({
    this.workoutId,
    required this.workoutName,
    required this.workoutType,
    required this.workoutColorValue,
    required this.startTime,
    this.durationSeconds = 0,
    List<SessionExercise>? exercises,
    this.totalVolume = 0,
    this.totalDistanceKm = 0,
    this.avgPaceSeconds = 0,
    List<double>? kmPaces,
    this.totalActiveSeconds = 0,
    this.perceivedEffort,
    this.notes,
  })  : exercises = exercises ?? [],
        kmPaces = kmPaces ?? [];

  TrainingSession toTrainingSession() {
    final s = TrainingSession();
    s.workoutId = workoutId;
    s.workoutName = workoutName;
    s.workoutType = workoutType;
    s.workoutColorValue = workoutColorValue;
    s.startTime = startTime;
    s.endTime = DateTime.now();
    s.durationSeconds = durationSeconds;
    s.exercises = exercises;
    s.totalVolume = totalVolume;
    s.totalDistanceKm = totalDistanceKm;
    s.avgPaceSeconds = avgPaceSeconds;
    s.kmPaces = kmPaces;
    s.totalActiveSeconds = totalActiveSeconds;
    s.completedSets = exercises.fold(
        0, (sum, e) => sum + e.sets.where((set) => set.completed).length);
    s.perceivedEffort = perceivedEffort;
    s.notes = notes;
    s.prCount = 0;
    return s;
  }
}

class ActiveSessionNotifier extends StateNotifier<ActiveSession?> {
  ActiveSessionNotifier() : super(null);

  void start({
    required String workoutName,
    required WorkoutType workoutType,
    int workoutColorValue = 0xFF3b82f6,
    int? workoutId,
  }) {
    state = ActiveSession(
      workoutId: workoutId,
      workoutName: workoutName,
      workoutType: workoutType,
      workoutColorValue: workoutColorValue,
      startTime: DateTime.now(),
    );
  }

  void setDuration(int seconds) {
    if (state == null) return;
    state = _copy(durationSeconds: seconds);
  }

  void setEffort(int effort) {
    if (state == null) return;
    state = _copy(perceivedEffort: effort);
  }

  void setNotes(String notes) {
    if (state == null) return;
    state = _copy(notes: notes);
  }

  void setRunData({
    required double km,
    required int totalSeconds,
    required List<double> paces,
  }) {
    if (state == null) return;
    final avgPace = km > 0 ? totalSeconds / km : 0.0;
    state = _copy(
      totalDistanceKm: km,
      durationSeconds: totalSeconds,
      avgPaceSeconds: avgPace,
      kmPaces: paces,
    );
  }

  void addCompletedSet({
    required String exerciseName,
    required int exerciseId,
    required double? weight,
    required int? reps,
    required int? durationSeconds,
  }) {
    if (state == null) return;
    final exercises = List<SessionExercise>.from(state!.exercises);
    final idx = exercises.indexWhere((e) => e.exerciseId == exerciseId);

    final set = SessionSet()
      ..setIndex = idx >= 0 ? exercises[idx].sets.length : 0
      ..weight = weight
      ..reps = reps
      ..durationSeconds = durationSeconds
      ..completed = true;

    if (idx >= 0) {
      exercises[idx].sets.add(set);
    } else {
      final ex = SessionExercise()
        ..exerciseId = exerciseId
        ..exerciseName = exerciseName
        ..sets = [set];
      exercises.add(ex);
    }

    final vol = state!.totalVolume + ((weight ?? 0) * (reps ?? 0));
    state = _copy(exercises: exercises, totalVolume: vol);
  }

  void clear() => state = null;

  ActiveSession _copy({
    int? workoutId,
    int? durationSeconds,
    List<SessionExercise>? exercises,
    double? totalVolume,
    double? totalDistanceKm,
    double? avgPaceSeconds,
    List<double>? kmPaces,
    int? totalActiveSeconds,
    int? perceivedEffort,
    String? notes,
  }) {
    final s = state!;
    return ActiveSession(
      workoutId: workoutId ?? s.workoutId,
      workoutName: s.workoutName,
      workoutType: s.workoutType,
      workoutColorValue: s.workoutColorValue,
      startTime: s.startTime,
      durationSeconds: durationSeconds ?? s.durationSeconds,
      exercises: exercises ?? s.exercises,
      totalVolume: totalVolume ?? s.totalVolume,
      totalDistanceKm: totalDistanceKm ?? s.totalDistanceKm,
      avgPaceSeconds: avgPaceSeconds ?? s.avgPaceSeconds,
      kmPaces: kmPaces ?? s.kmPaces,
      totalActiveSeconds: totalActiveSeconds ?? s.totalActiveSeconds,
      perceivedEffort: perceivedEffort ?? s.perceivedEffort,
      notes: notes ?? s.notes,
    );
  }
}

final activeSessionProvider =
    StateNotifierProvider<ActiveSessionNotifier, ActiveSession?>(
  (ref) => ActiveSessionNotifier(),
);
