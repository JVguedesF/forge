import 'package:isar/isar.dart';
import '../database/isar_service.dart';
import '../../data/models/exercise.dart';
import '../../data/models/workout.dart';
import '../../data/models/macro_cycle.dart';
import '../../data/models/enums.dart';

class SeedService {
  static Future<void> seedIfEmpty() async {
    final db = IsarService.instance;
    final count = await db.workouts.count();
    if (count > 0) return;

    await _seedExercises(db);
    await _seedWorkouts(db);
    await _seedMacroCycle(db);
  }

  static Future<void> _seedExercises(Isar db) async {
    final exercises = [
      Exercise()
        ..name = 'Supino Reto'
        ..type = ExerciseType.weightReps
        ..tags = ['Peito', 'Tri', 'Composto']
        ..defaultSets = 4
        ..defaultReps = '8-10'
        ..defaultWeight = 80
        ..defaultRestSeconds = 180,
      Exercise()
        ..name = 'Supino Inclinado'
        ..type = ExerciseType.weightReps
        ..tags = ['Peito', 'Composto']
        ..defaultSets = 3
        ..defaultReps = '10-12'
        ..defaultWeight = 70
        ..defaultRestSeconds = 90,
      Exercise()
        ..name = 'Crucifixo'
        ..type = ExerciseType.weightReps
        ..tags = ['Peito', 'Isolado']
        ..defaultSets = 3
        ..defaultReps = '12'
        ..defaultWeight = 22
        ..defaultRestSeconds = 75,
      Exercise()
        ..name = 'Voador'
        ..type = ExerciseType.weightReps
        ..tags = ['Peito', 'Isolado']
        ..defaultSets = 3
        ..defaultReps = '15'
        ..defaultWeight = 20
        ..defaultRestSeconds = 60,
      Exercise()
        ..name = 'Desenvolvimento'
        ..type = ExerciseType.weightReps
        ..tags = ['Ombros', 'Composto']
        ..defaultSets = 4
        ..defaultReps = '8-10'
        ..defaultWeight = 60
        ..defaultRestSeconds = 180,
      Exercise()
        ..name = 'Elevação Lateral'
        ..type = ExerciseType.weightReps
        ..tags = ['Ombros', 'Isolado']
        ..defaultSets = 3
        ..defaultReps = '12-15'
        ..defaultWeight = 12
        ..defaultRestSeconds = 60,
      Exercise()
        ..name = 'Remada Curvada'
        ..type = ExerciseType.weightReps
        ..tags = ['Costas', 'Composto']
        ..defaultSets = 4
        ..defaultReps = '8-10'
        ..defaultWeight = 80
        ..defaultRestSeconds = 180,
      Exercise()
        ..name = 'Puxada Frontal'
        ..type = ExerciseType.weightReps
        ..tags = ['Costas', 'Composto']
        ..defaultSets = 3
        ..defaultReps = '10-12'
        ..defaultWeight = 70
        ..defaultRestSeconds = 90,
      Exercise()
        ..name = 'Agachamento'
        ..type = ExerciseType.weightReps
        ..tags = ['Pernas', 'Composto']
        ..defaultSets = 4
        ..defaultReps = '8-10'
        ..defaultWeight = 100
        ..defaultRestSeconds = 180,
      Exercise()
        ..name = 'Leg Press'
        ..type = ExerciseType.weightReps
        ..tags = ['Pernas', 'Composto']
        ..defaultSets = 3
        ..defaultReps = '10-12'
        ..defaultWeight = 150
        ..defaultRestSeconds = 120,
      Exercise()
        ..name = 'Deadlift'
        ..type = ExerciseType.weightReps
        ..tags = ['Posterior', 'Costas', 'Composto']
        ..defaultSets = 4
        ..defaultReps = '5-6'
        ..defaultWeight = 120
        ..defaultRestSeconds = 240,
      Exercise()
        ..name = 'Rosca Direta'
        ..type = ExerciseType.weightReps
        ..tags = ['Bíceps', 'Isolado']
        ..defaultSets = 3
        ..defaultReps = '10-12'
        ..defaultWeight = 30
        ..defaultRestSeconds = 75,
      Exercise()
        ..name = 'Tríceps Corda'
        ..type = ExerciseType.weightReps
        ..tags = ['Tríceps', 'Isolado']
        ..defaultSets = 3
        ..defaultReps = '12-15'
        ..defaultWeight = 25
        ..defaultRestSeconds = 60,
      Exercise()
        ..name = 'Prancha'
        ..type = ExerciseType.timed
        ..tags = ['Core']
        ..defaultSets = 3
        ..defaultDurationSeconds = 60
        ..defaultRestSeconds = 60
        ..hasSides = false,
      Exercise()
        ..name = 'Figura 4 Deitado'
        ..type = ExerciseType.timed
        ..tags = ['Quadril', 'Mobilidade']
        ..defaultSets = 1
        ..defaultDurationSeconds = 45
        ..defaultRestSeconds = 10
        ..hasSides = true,
      Exercise()
        ..name = 'Pigeon Pose'
        ..type = ExerciseType.timed
        ..tags = ['Quadril', 'Mobilidade']
        ..defaultSets = 1
        ..defaultDurationSeconds = 45
        ..defaultRestSeconds = 10
        ..hasSides = true,
      Exercise()
        ..name = 'Alongamento Cervical'
        ..type = ExerciseType.timed
        ..tags = ['Cervical', 'Mobilidade']
        ..defaultSets = 1
        ..defaultDurationSeconds = 30
        ..defaultRestSeconds = 5
        ..hasSides = true,
      Exercise()
        ..name = 'Embaixadinha'
        ..type = ExerciseType.repsOnly
        ..tags = ['Domínio', 'Bola']
        ..defaultSets = 1
        ..defaultReps = 'máximo'
        ..hasSides = false,
    ];
    await db.writeTxn(() => db.exercises.putAll(exercises));
  }

  static Future<void> _seedWorkouts(Isar db) async {
    final exs = await db.exercises.where().findAll();
    Map<String, int> exId = {for (final e in exs) e.name: e.id!};

    WorkoutExercise ex(String name,
        {String reps = '10', double? kg, int dur = 0, bool sides = false}) {
      return WorkoutExercise()
        ..exerciseId = exId[name]
        ..exerciseName = name
        ..type = dur > 0 ? ExerciseType.timed : ExerciseType.weightReps
        ..reps = reps
        ..suggestedWeight = kg
        ..durationSeconds = dur
        ..hasSides = sides;
    }

    WorkoutBlock block(List<WorkoutExercise> exercises,
        {int sets = 3,
        int rest = 90,
        bool isCircuit = false,
        String? name,
        int restAfter = 0}) {
      return WorkoutBlock()
        ..isCircuit = isCircuit
        ..circuitName = name
        ..sets = sets
        ..restAfterSeconds = restAfter > 0 ? restAfter : rest
        ..exercises = exercises;
    }

    List<WorkoutBlock> orderBlocks(List<WorkoutBlock> blocks) {
      for (var i = 0; i < blocks.length; i++) {
        blocks[i].orderIndex = i;
      }
      return blocks;
    }

    final workouts = [
      Workout()
        ..name = 'Upper A'
        ..type = WorkoutType.musculacao
        ..colorValue = 0xFF3b82f6
        ..iconName = 'dumbbell'
        ..tags = ['Composto', 'Isolado']
        ..blocks = orderBlocks([
          block([ex('Supino Reto', reps: '8-10', kg: 80)], sets: 4, rest: 180),
          block([ex('Supino Inclinado', reps: '10-12', kg: 70)],
              sets: 3, rest: 90),
          block([
            ex('Crucifixo', reps: '12', kg: 22),
            ex('Voador', reps: '15', kg: 20)
          ], sets: 3, rest: 120, isCircuit: true, name: 'Super-set 1'),
          block([ex('Desenvolvimento', reps: '8-10', kg: 60)],
              sets: 4, rest: 180),
          block([ex('Elevação Lateral', reps: '12-15', kg: 12)],
              sets: 3, rest: 60),
          block([ex('Tríceps Corda', reps: '12-15', kg: 25)],
              sets: 3, rest: 60),
        ])
        ..estimatedMinutes = 55
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      Workout()
        ..name = 'Lower A'
        ..type = WorkoutType.musculacao
        ..colorValue = 0xFF3b82f6
        ..iconName = 'dumbbell'
        ..tags = ['Composto', 'Core']
        ..blocks = orderBlocks([
          block([ex('Agachamento', reps: '8-10', kg: 100)], sets: 4, rest: 180),
          block([ex('Leg Press', reps: '10-12', kg: 150)], sets: 3, rest: 120),
          block([ex('Deadlift', reps: '5-6', kg: 120)], sets: 4, rest: 240),
          block([ex('Rosca Direta', reps: '10-12', kg: 30)], sets: 3, rest: 75),
          block([ex('Prancha', dur: 60)], sets: 3, rest: 60),
        ])
        ..estimatedMinutes = 60
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      Workout()
        ..name = 'Upper B'
        ..type = WorkoutType.musculacao
        ..colorValue = 0xFF3b82f6
        ..iconName = 'dumbbell'
        ..tags = ['Composto', 'Potência']
        ..blocks = orderBlocks([
          block([ex('Remada Curvada', reps: '8-10', kg: 80)],
              sets: 4, rest: 180),
          block([ex('Puxada Frontal', reps: '10-12', kg: 70)],
              sets: 3, rest: 90),
          block([ex('Desenvolvimento', reps: '8-10', kg: 60)],
              sets: 4, rest: 180),
          block([ex('Elevação Lateral', reps: '12-15', kg: 12)],
              sets: 3, rest: 60),
          block([ex('Rosca Direta', reps: '10-12', kg: 30)], sets: 3, rest: 75),
          block([ex('Tríceps Corda', reps: '12-15', kg: 25)],
              sets: 3, rest: 60),
        ])
        ..estimatedMinutes = 55
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      Workout()
        ..name = 'Lower B'
        ..type = WorkoutType.musculacao
        ..colorValue = 0xFF3b82f6
        ..iconName = 'dumbbell'
        ..tags = ['Core', 'Unilateral']
        ..blocks = orderBlocks([
          block([ex('Agachamento', reps: '8-10', kg: 100)], sets: 4, rest: 180),
          block([ex('Deadlift', reps: '5-6', kg: 120)], sets: 4, rest: 240),
          block([ex('Leg Press', reps: '10-12', kg: 150)], sets: 3, rest: 120),
          block([ex('Prancha', dur: 60)], sets: 3, rest: 60),
        ])
        ..estimatedMinutes = 60
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      Workout()
        ..name = 'Corrida Longa'
        ..type = WorkoutType.corrida
        ..colorValue = 0xFF0ea5e9
        ..iconName = 'activity'
        ..tags = ['Longa']
        ..blocks = []
        ..estimatedMinutes = 0
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      Workout()
        ..name = 'Corrida Regeneração'
        ..type = WorkoutType.corrida
        ..colorValue = 0xFF0ea5e9
        ..iconName = 'activity'
        ..tags = ['Regeneração']
        ..blocks = []
        ..estimatedMinutes = 0
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      Workout()
        ..name = 'Drills Iniciante'
        ..type = WorkoutType.drills
        ..colorValue = 0xFF06b6d4
        ..iconName = 'zap'
        ..tags = ['Agilidade', 'Velocidade']
        ..blocks = []
        ..estimatedMinutes = 45
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      Workout()
        ..name = 'Bola Intermediário'
        ..type = WorkoutType.bola
        ..colorValue = 0xFF22c55e
        ..iconName = 'target'
        ..tags = ['Domínio', 'Drible']
        ..blocks = orderBlocks([
          block([ex('Embaixadinha', reps: 'máximo')],
              sets: 3, rest: 60, isCircuit: false),
        ])
        ..estimatedMinutes = 50
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      Workout()
        ..name = 'Mobilidade A'
        ..type = WorkoutType.mobilidade
        ..colorValue = 0xFF8b5cf6
        ..iconName = 'leaf'
        ..tags = ['Alongamento', 'Fortalecimento']
        ..blocks = orderBlocks([
          block([ex('Figura 4 Deitado', dur: 45, sides: true)],
              sets: 1, rest: 10, isCircuit: true, name: 'Membros Inferiores'),
          block([ex('Alongamento Cervical', dur: 30, sides: true)],
              sets: 1, rest: 5, isCircuit: true, name: 'Cervical'),
          block([ex('Pigeon Pose', dur: 45, sides: true)],
              sets: 1, rest: 10, isCircuit: true, name: 'Quadril'),
        ])
        ..estimatedMinutes = 30
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
      Workout()
        ..name = 'Mobilidade B'
        ..type = WorkoutType.mobilidade
        ..colorValue = 0xFF8b5cf6
        ..iconName = 'leaf'
        ..tags = ['Cervical', 'Lombar']
        ..blocks = orderBlocks([
          block([ex('Alongamento Cervical', dur: 30, sides: true)],
              sets: 1, rest: 5, isCircuit: true, name: 'Cervical'),
          block([ex('Figura 4 Deitado', dur: 45, sides: true)],
              sets: 1, rest: 10, isCircuit: true, name: 'Lombar'),
        ])
        ..estimatedMinutes = 30
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now(),
    ];

    await db.writeTxn(() => db.workouts.putAll(workouts));
  }

  static Future<void> _seedMacroCycle(Isar db) async {
    final workouts = await db.workouts.where().findAll();
    Map<String, int> wId = {for (final w in workouts) w.name: w.id!};

    final cycle = MacroCycle()
      ..name = 'Ciclo Base 2025'
      ..description =
          'Ciclo de base para desenvolvimento de força e condicionamento'
      ..startDate = DateTime(2025, 3, 1)
      ..isActive = true
      ..currentPhaseIndex = 0
      ..phases = [
        Phase()
          ..name = 'Fase 1 — Base'
          ..objective = 'Desenvolver base de força e volume'
          ..durationWeeks = 8
          ..targetSessions = 24
          ..completedSessions = 14
          ..intensityPercent = 70
          ..recommendedSets = 4
          ..recommendedReps = '8-10'
          ..deloadWeeks = [3, 7]
          ..startDate = DateTime(2025, 3, 1)
          ..weeklySchedule = [
            DaySchedule()
              ..weekday = 1
              ..workoutIds = [wId['Upper A'] ?? 0, wId['Mobilidade A'] ?? 0]
              ..workoutNames = ['Upper A', 'Mobilidade A'],
            DaySchedule()
              ..weekday = 2
              ..workoutIds = [wId['Lower A'] ?? 0]
              ..workoutNames = ['Lower A'],
            DaySchedule()
              ..weekday = 3
              ..workoutIds = [
                wId['Drills Iniciante'] ?? 0,
                wId['Corrida Longa'] ?? 0
              ]
              ..workoutNames = ['Drills Iniciante', 'Corrida Longa'],
            DaySchedule()
              ..weekday = 4
              ..workoutIds = [wId['Upper B'] ?? 0, wId['Mobilidade B'] ?? 0]
              ..workoutNames = ['Upper B', 'Mobilidade B'],
            DaySchedule()
              ..weekday = 5
              ..workoutIds = [
                wId['Bola Intermediário'] ?? 0,
                wId['Lower B'] ?? 0
              ]
              ..workoutNames = ['Bola Intermediário', 'Lower B'],
            DaySchedule()
              ..weekday = 6
              ..workoutIds = [wId['Corrida Regeneração'] ?? 0]
              ..workoutNames = ['Corrida Regeneração'],
            DaySchedule()
              ..weekday = 7
              ..workoutIds = []
              ..workoutNames = ['Descanso'],
          ]
          ..goals = [
            PhaseGoal()
              ..type = GoalType.sessions
              ..description = '2× Bola/semana'
              ..unit = 'sessões'
              ..target = 16
              ..current = 12,
            PhaseGoal()
              ..type = GoalType.distance
              ..description = '8km pace 5:30'
              ..unit = 'km'
              ..target = 120
              ..current = 68,
            PhaseGoal()
              ..type = GoalType.weight
              ..description = 'Supino 100kg'
              ..unit = 'kg'
              ..target = 100
              ..current = 82,
          ],
        Phase()
          ..name = 'Fase 2 — Intensidade'
          ..objective = 'Aumentar intensidade e cargas'
          ..durationWeeks = 6
          ..targetSessions = 20
          ..completedSessions = 0
          ..intensityPercent = 80
          ..recommendedSets = 4
          ..recommendedReps = '6-8'
          ..deloadWeeks = [5]
          ..weeklySchedule = [],
      ];

    await db.writeTxn(() => db.macroCycles.put(cycle));
  }
}
