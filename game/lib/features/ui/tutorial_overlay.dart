import 'package:flutter/material.dart';
import 'package:mg_common_game/core/ui/theme/app_colors.dart';
import 'package:mg_common_game/core/ui/theme/app_text_styles.dart';

class TutorialOverlay extends StatelessWidget {
  final VoidCallback onFinish;

  const TutorialOverlay({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary, width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 5),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Welcome to Kingdom Rebuild!", style: AppTextStyles.header1),
            const SizedBox(height: 16),
            const Text(
              "Your goal is to rebuild the kingdom.\n\n"
              "1. Collect resources by waiting or clicking buttons.\n"
              "2. Build structures like Lumber Mills to automate production.\n"
              "3. Upgrade buildings to increase efficiency.\n"
              "4. Manage workers to boost output.\n\n"
              "Good luck, my liege!",
              style: AppTextStyles.body,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onFinish,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text("Start Rebuilding"),
            ),
          ],
        ),
      ),
    );
  }
}
