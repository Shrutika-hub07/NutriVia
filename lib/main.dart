import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/tokens.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_strings.dart';
import 'core/services/rules_service.dart';
import 'core/providers/app_state_provider.dart';
import 'core/widgets/bottom_nav_bar.dart';

import 'features/home/home_screen.dart';
import 'features/track/track_screen.dart';
import 'features/eat/eat_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/assistant/assistant_screen.dart';
import 'features/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ClinicalRulesService().loadAllRules();
  runApp(const ProviderScope(child: NutriviaApp()));
}

class NutriviaApp extends ConsumerWidget {
  const NutriviaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);

    return MaterialApp(
      title: 'Nutrivia',
      debugShowCheckedModeBanner: false,
      theme: NutriviaTheme.lightTheme(state.textScale),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'IN'),
        Locale('hi', 'IN'),
        Locale('mr', 'IN'),
      ],
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends ConsumerStatefulWidget {
  const MainNavigationShell({super.key});

  @override
  ConsumerState<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends ConsumerState<MainNavigationShell> {
  int _currentIndex = 0;
  bool _showOnboarding = false; // By default launches directly into demo mode for fast judging

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final notifier = ref.read(appStateProvider.notifier);
    String tr(String key) => AppStrings.get(key, state.language);

    if (_showOnboarding) {
      return OnboardingScreen(
        onComplete: (lang, age, diet, fasts) {
          notifier.setLanguage(lang);
          setState(() {
            _showOnboarding = false;
          });
        },
      );
    }

    final pages = [
      HomeScreen(
        state: state,
        language: state.language,
        onOpenAssistant: _openAssistantScreen,
        onCheckinDone: () => notifier.incrementStreak(),
        onLanguageChange: (lang) => notifier.setLanguage(lang),
        onToggleDemoMode: () => _showPersonaSwitcher(context, notifier),
      ),
      TrackScreen(
        state: state,
        language: state.language,
        onCheckinDone: () => notifier.incrementStreak(),
      ),
      EatScreen(
        language: state.language,
      ),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NutriviaBottomNav(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        onVoiceTap: _openAssistantScreen,
        isListening: false,
        tr: tr,
      ),
    );
  }

  void _openAssistantScreen() {
    final state = ref.read(appStateProvider);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AssistantScreen(
          state: state,
          language: state.language,
        ),
      ),
    );
  }

  void _showPersonaSwitcher(BuildContext context, AppStateNotifier notifier) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: NutriviaShapes.organicCard),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Switch Demo Mode Persona', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: NutriviaColors.plum)),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.person, color: NutriviaColors.plum),
                title: const Text('Sunita (52, Marathi, 6-Wk Seeded)'),
                subtitle: const Text('High Anaemia & Vit D Risk, Vegetarian'),
                onTap: () {
                  notifier.loadPersona('sunita');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_outline, color: NutriviaColors.marigold),
                title: const Text('Meera (44, English/Hindi, Urban)'),
                subtitle: const Text('Early Perimenopause, Hot Flashes'),
                onTap: () {
                  notifier.loadPersona('meera');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh, color: NutriviaColors.stone),
                title: const Text('Start Fresh Profile (Blank)'),
                onTap: () {
                  notifier.loadPersona('fresh');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
