import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/isar_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarService.init();
  runApp(const ProviderScope(child: ForgeApp()));
}

class ForgeApp extends ConsumerWidget {
  const ForgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Forge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(theme),
      home: const Scaffold(
        body: Center(
          child: Text('Forge', style: TextStyle(fontSize: 48)),
        ),
      ),
    );
  }
}
