import 'package:isar/isar.dart';
import '../models/macro_cycle.dart';
import '../../core/database/isar_service.dart';

class MacroCycleRepository {
  Isar get _db => IsarService.instance;

  Future<MacroCycle?> getActive() =>
      _db.macroCycles.filter().isActiveEqualTo(true).findFirst();

  Future<List<MacroCycle>> getAll() => _db.macroCycles.where().findAll();

  Future<int> save(MacroCycle cycle) =>
      _db.writeTxn(() => _db.macroCycles.put(cycle));

  Future<void> setActive(int id) async {
    await _db.writeTxn(() async {
      final all = await _db.macroCycles.where().findAll();
      for (final c in all) {
        c.isActive = c.id == id;
        await _db.macroCycles.put(c);
      }
    });
  }

  Future<void> incrementCompletedSessions() async {
    final cycle = await getActive();
    if (cycle == null) return;
    final phase =
        cycle.phases.isNotEmpty ? cycle.phases[cycle.currentPhaseIndex] : null;
    if (phase == null) return;
    phase.completedSessions += 1;
    await save(cycle);
  }

  Stream<MacroCycle?> watchActive() => _db.macroCycles
      .filter()
      .isActiveEqualTo(true)
      .watch(fireImmediately: true)
      .map((list) => list.isEmpty ? null : list.first);
}
