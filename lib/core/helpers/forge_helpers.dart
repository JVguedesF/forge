import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../theme/app_theme.dart';
import '../../data/models/enums.dart';

class ForgeHelpers {
  static String workoutTypeLabel(WorkoutType type) => switch (type) {
        WorkoutType.musculacao => 'Musculação',
        WorkoutType.corrida => 'Corrida',
        WorkoutType.drills => 'Drills',
        WorkoutType.bola => 'Bola',
        WorkoutType.mobilidade => 'Mobilidade',
        WorkoutType.custom => 'Custom',
      };

  static Color workoutTypeColor(WorkoutType type) => switch (type) {
        WorkoutType.musculacao => ForgeColors.musculacao,
        WorkoutType.corrida => ForgeColors.corrida,
        WorkoutType.drills => ForgeColors.drills,
        WorkoutType.bola => ForgeColors.bola,
        WorkoutType.mobilidade => ForgeColors.mobilidade,
        WorkoutType.custom => ForgeColors.muted,
      };

  static Color workoutTypeColorLight(WorkoutType type) => switch (type) {
        WorkoutType.musculacao => ForgeColors.musculacaoLight,
        WorkoutType.corrida => ForgeColors.corridaLight,
        WorkoutType.drills => ForgeColors.drillsLight,
        WorkoutType.bola => ForgeColors.bolaLight,
        WorkoutType.mobilidade => ForgeColors.mobilidadeLight,
        WorkoutType.custom => ForgeColors.muted,
      };

  static IconData workoutTypeIcon(WorkoutType type) => switch (type) {
        WorkoutType.musculacao => LucideIcons.dumbbell,
        WorkoutType.corrida => LucideIcons.activity,
        WorkoutType.drills => LucideIcons.zap,
        WorkoutType.bola => LucideIcons.target,
        WorkoutType.mobilidade => LucideIcons.leaf,
        WorkoutType.custom => LucideIcons.sparkles,
      };

  static List<String> tagsByType(WorkoutType type) => switch (type) {
        WorkoutType.musculacao => [
            'Composto',
            'Isolado',
            'Core',
            'Potência',
            'Unilateral',
            'Explosão'
          ],
        WorkoutType.corrida => [
            'Longa',
            'Regeneração',
            'Intervalado',
            'Tempo Run',
            'Progressiva',
            'Fartlek'
          ],
        WorkoutType.drills => [
            'Agilidade',
            'Velocidade',
            'Coordenação',
            'Explosão'
          ],
        WorkoutType.bola => ['Domínio', 'Drible', 'Passe', 'Finalização'],
        WorkoutType.mobilidade => [
            'Alongamento',
            'Fortalecimento',
            'Cervical',
            'Lombar',
            'Quadril'
          ],
        WorkoutType.custom => ['Custom'],
      };

  static String formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) return '${h}h ${m.toString().padLeft(2, '0')}min';
    if (m > 0) return '${m}min';
    return '${s}s';
  }

  static String formatPace(double secondsPerKm) {
    final m = secondsPerKm ~/ 60;
    final s = (secondsPerKm % 60).round();
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  static String greetingByHour() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bom dia';
    if (h < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  static String todayLabel() {
    final now = DateTime.now();
    const dias = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo'
    ];
    const meses = [
      'jan',
      'fev',
      'mar',
      'abr',
      'mai',
      'jun',
      'jul',
      'ago',
      'set',
      'out',
      'nov',
      'dez'
    ];
    return '${dias[now.weekday - 1]} · ${now.day} de ${meses[now.month - 1]}';
  }
}
