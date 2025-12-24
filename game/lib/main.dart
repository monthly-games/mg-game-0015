import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import 'package:mg_common_game/core/ui/theme/app_colors.dart';
import 'package:mg_common_game/core/ui/theme/app_text_styles.dart';
import 'features/resources/resource_manager.dart';
// import 'features/buildings/building_data.dart';
import 'features/buildings/building_definition.dart';
// import 'features/buildings/building_instance.dart';
import 'features/ui/construction_overlay.dart';
import 'features/ui/tutorial_overlay.dart';
import 'game/kingdom_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setupDI();
  await GetIt.I<AudioManager>().initialize();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ResourceManager())],
      child: const KingdomApp(),
    ),
  );
}

void _setupDI() {
  if (!GetIt.I.isRegistered<AudioManager>()) {
    GetIt.I.registerSingleton<AudioManager>(AudioManager());
  }
}

class KingdomApp extends StatelessWidget {
  const KingdomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kingdom Rebuild',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
      ),
      home: const KingdomScreen(),
    );
  }
}

class KingdomScreen extends StatefulWidget {
  const KingdomScreen({super.key});

  @override
  State<KingdomScreen> createState() => _KingdomScreenState();
}

class _KingdomScreenState extends State<KingdomScreen> {
  // We need to access the provider to pass it to the game instance
  // Or we can let the Game instance be creating inside build accessing context.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ResourceManager>(
        builder: (context, resourceManager, child) {
          return GameWidget(
            game: KingdomGame(resourceManager: resourceManager),
            overlayBuilderMap: {
              'HUD': (BuildContext context, KingdomGame game) {
                return KingdomHud(game: game);
              },
              'construction': (BuildContext context, KingdomGame game) {
                return ConstructionOverlay(
                  game: game,
                  resourceManager: resourceManager,
                  onClose: () {
                    game.overlays.remove('construction');
                    game.overlays.add('HUD');
                  },
                );
              },
              'tutorial': (BuildContext context, KingdomGame game) {
                return TutorialOverlay(
                  onFinish: () {
                    resourceManager.completeTutorial();
                    game.overlays.remove('tutorial');
                  },
                );
              },
            },
            initialActiveOverlays: [
              'HUD',
              if (!resourceManager.tutorialCompleted) 'tutorial',
            ],
          );
        },
      ),
    );
  }
}

class KingdomHud extends StatelessWidget {
  final KingdomGame game;
  const KingdomHud({super.key, required this.game});

  @override
  // ... Inside KingdomHud
  Widget build(BuildContext context) {
    // Consume resource manager to rebuild HUD on change
    return Consumer<ResourceManager>(
      builder: (context, resources, child) {
        // Selection Logic
        final selectedId = resources.selectedBuildingId;
        final selectedBuilding = selectedId != null
            ? resources.buildings.cast<BuildingInstance?>().firstWhere(
                (b) => b?.id == selectedId,
                orElse: () => null,
              )
            : null;

        return SafeArea(
          child: Column(
            children: [
              // 1. Top Resource Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.panel,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildResourceItem(
                      Icons.monetization_on,
                      AppColors.secondary,
                      resources.gold,
                    ),
                    _buildResourceItem(
                      Icons.forest,
                      Colors.brown,
                      resources.wood,
                    ),
                    _buildResourceItem(
                      Icons.landscape,
                      Colors.grey,
                      resources.stone,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 2. Active Buttons (Floating) - Only if NOT selecting? Or always?
              // Hide Build button if selecting to avoid clutter? No, keep it.
              Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (selectedBuilding ==
                        null) // Hide controls when inspecting?
                      FloatingActionButton.extended(
                        heroTag: 'build_btn',
                        onPressed: () {
                          try {
                            GetIt.I<AudioManager>().playSfx('sfx_click.wav');
                          } catch (_) {}
                          // Open Construction Overlay
                          // Ideally we pass context or callback.
                          // For now, hack: we know the 'construction' overlay is registered.
                          // But we can't trigger it easily without GameRef.
                          // Wait, in previous step I said I'd fix structure.
                          // KingdomHud has field: final KingdomGame game;
                          // So we CAN use game.overlays!
                          // Step 1188 shows: class KingdomHud extends StatelessWidget { const KingdomHud({super.key}); ...
                          // It lacks the `final KingdomGame game` field in the definition!
                          // But line 74: KingdomHud(game: game) implies it is expected or failed.
                          // Ah, line 74 in `build` passes `game`, but class definition (line 95) does NOT have it.
                          // I must fix that too.

                          // BUT, I can't simple fix constructor in THIS replace block easily if I don't target it.
                          // I am targeting `build`.

                          // I will assume `game` is available if I fix the class def in a separate edit or larger edit.
                          // I'll make this edit assume `this.game` exists and I'll do a second edit to add the field.
                          game.overlays.add('construction');
                          game.overlays.remove('HUD');
                        },
                        icon: const Icon(Icons.construction),
                        label: const Text("Build"),
                        backgroundColor: AppColors.primary,
                      ),
                    const SizedBox(width: 16),
                    FloatingActionButton.extended(
                      heroTag: 'tax_btn',
                      onPressed: () {
                        try {
                          GetIt.I<AudioManager>().playSfx('sfx_coin.wav');
                        } catch (_) {}
                        resources.click();
                      },
                      icon: const Icon(Icons.touch_app),
                      label: const Text("Collect Tax"),
                      backgroundColor: AppColors.secondary,
                    ),
                  ],
                ),
              ),

              // 3. Bottom Panel (Selection or List)
              Container(
                height: 280, // Slightly taller
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: selectedBuilding != null
                    ? _buildInspector(context, resources, selectedBuilding)
                    : _buildBuildingList(context, resources),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInspector(
    BuildContext context,
    ResourceManager resources,
    BuildingInstance b,
  ) {
    final canAfford = resources.canAfford(b.currentCost);
    final isConstructing = b.isUnderConstruction;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Inspect: ${b.name}", style: AppTextStyles.header2),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => resources.selectBuilding(null),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Icon
                CircleAvatar(
                  radius: 30,
                  backgroundColor: _getBuildingColor(b.type).withOpacity(0.2),
                  child: Icon(
                    _getBuildingIcon(b.type),
                    size: 30,
                    color: _getBuildingColor(b.type),
                  ),
                ),
                const SizedBox(height: 10),
                Text("Level ${b.level}", style: AppTextStyles.header1),
                Text(b.definition.description, style: AppTextStyles.body),
                const Divider(),
                // Upgrade Btn
                ElevatedButton(
                  onPressed: !isConstructing && canAfford
                      ? () {
                          resources.upgradeBuilding(b.id);
                          GetIt.I<AudioManager>().playSfx('sfx_build.wav');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    isConstructing
                        ? "Upgrading..."
                        : "Upgrade (${b.currentCost.toInt()} G)",
                  ),
                ),
                if (isConstructing)
                  Text(
                    "Time Left: ${b.constructionEndTime!.difference(DateTime.now()).inSeconds}s",
                  ),

                const SizedBox(height: 10),

                // Workers
                if (b.maxWorkers > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: b.workers > 0
                            ? () => resources.removeWorker(b.id)
                            : null,
                      ),
                      Text("Workers: ${b.workers} / ${b.maxWorkers}"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed:
                            (resources.availableWorkers > 0 &&
                                b.workers < b.maxWorkers)
                            ? () => resources.assignWorker(b.id)
                            : null,
                      ),
                    ],
                  ),

                const Divider(),
                // Demolish
                TextButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "Demolish (50% Refund)",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    resources.removeBuilding(b.id);
                    resources.selectBuilding(null);
                    GetIt.I<AudioManager>().playSfx(
                      'sfx_error.wav',
                    ); // Destructive sound?
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuildingList(BuildContext context, ResourceManager resources) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text("Kingdom Overview", style: AppTextStyles.header2),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: resources.buildings.length,
            itemBuilder: (context, index) {
              final b = resources.buildings[index];
              // Just simple list, tap to select
              return ListTile(
                leading: Icon(
                  _getBuildingIcon(b.type),
                  color: _getBuildingColor(b.type),
                ),
                title: Text(b.name),
                subtitle: Text("Lv.${b.level}"),
                onTap: () {
                  resources.selectBuilding(b.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResourceItem(
    IconData icon,
    Color color,
    double amount, {
    bool isInt = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          isInt
              ? amount.toInt().toString()
              : amount
                    .toInt()
                    .toString(), // Helper is same for now as amount is floor?
          style: AppTextStyles.header2.copyWith(
            color: AppColors.textHighEmphasis,
          ),
        ),
      ],
    );
  }

  Color _getBuildingColor(BuildingType type) {
    switch (type) {
      case BuildingType.castle:
        return Colors.grey;
      case BuildingType.lumberMill:
        return Colors.brown;
      case BuildingType.stoneQuarry:
        return Colors.blueGrey;
      case BuildingType.house:
        return Colors.orangeAccent;
    }
  }

  IconData _getBuildingIcon(BuildingType type) {
    switch (type) {
      case BuildingType.castle:
        return Icons.security;
      case BuildingType.lumberMill:
        return Icons.forest;
      case BuildingType.stoneQuarry:
        return Icons.landscape;
      case BuildingType.house:
        return Icons.maps_home_work;
    }
  }
}
