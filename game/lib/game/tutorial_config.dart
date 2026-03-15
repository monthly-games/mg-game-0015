import 'package:mg_common_game/systems/tutorial/tutorial.dart';

/// Tutorial configuration for MG-0015: Kingdom Rebuild (Strategy).
///
/// Placeholder tutorial steps for v1.2.0 pilot integration.
/// In production, replace descriptions with localized strings
/// and add targetSelector for highlight positioning.
const kOnboardingTutorial = TutorialConfig(
  id: 'onboarding',
  name: 'Kingdom Rebuild Tutorial',
  steps: [
    TutorialStep(
      id: 'welcome',
      title: 'Welcome, Your Majesty!',
      description: 'Rebuild your fallen kingdom from the ruins.',
      actionHint: 'Tap to continue',
    ),
    TutorialStep(
      id: 'build_first',
      title: 'Build a Lumber Mill',
      description:
          'Place your first building to start producing resources.',
      actionHint: 'Tap build',
      targetSelector: 'build_button',
    ),
    TutorialStep(
      id: 'collect_tax',
      title: 'Collect Tax',
      description: 'Tap the Collect Tax button to earn gold from citizens.',
      actionHint: 'Tap collect',
      targetSelector: 'tax_button',
    ),
    TutorialStep(
      id: 'upgrade_building',
      title: 'Upgrade Buildings',
      description:
          'Spend gold to upgrade buildings and increase production.',
      actionHint: 'Tap to continue',
    ),
  ],
  skippable: true,
  showOnFirstLaunch: true,
  trigger: TutorialTrigger.firstLaunch,
);
