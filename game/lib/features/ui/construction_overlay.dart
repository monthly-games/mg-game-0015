import 'package:flutter/material.dart';
import '../../game/kingdom_game.dart';
import '../buildings/building_definition.dart';
import '../resources/resource_manager.dart';
import 'package:mg_common_game/core/ui/theme/app_colors.dart';
import 'package:mg_common_game/core/ui/theme/app_text_styles.dart';

class ConstructionOverlay extends StatelessWidget {
  final KingdomGame game;
  final ResourceManager resourceManager;
  final VoidCallback onClose;

  const ConstructionOverlay({
    Key? key,
    required this.game,
    required this.resourceManager,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final available = resourceManager.definitions.values.toList();

    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      height: 200,
      child: Material(
        color: AppColors.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Construction", style: AppTextStyles.title),
                  IconButton(icon: const Icon(Icons.close), onPressed: onClose),
                ],
              ),
            ),
            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: available.length,
                itemBuilder: (context, index) {
                  final def = available[index];
                  bool canAfford = resourceManager.gold >= def.baseCost;

                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 16, bottom: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(def.name, style: AppTextStyles.bodyBold),
                        const SizedBox(height: 4),
                        Text(
                          "Cost: ${def.baseCost.toInt()}",
                          style: TextStyle(
                            color: canAfford ? Colors.green : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: canAfford
                              ? () {
                                  // Select building
                                  game.selectedBuildingType = def.type;
                                  onClose(); // Close overlay to allow placement
                                }
                              : null,
                          child: const Text("Select"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
