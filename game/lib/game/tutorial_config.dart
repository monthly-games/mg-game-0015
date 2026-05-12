import 'package:mg_common_game/systems/tutorial/tutorial.dart';

/// Tutorial configuration for MG-0015: Kingdom Rebuild (Strategy).
///
/// Placeholder tutorial steps for v1.2.0 pilot integration.
/// In production, replace descriptions with localized strings
/// and add targetKey for highlight positioning.
const kOnboardingTutorial = TutorialConfig(
  id: 'onboarding',
  name: 'Kingdom Rebuild Tutorial',
  skippable: true,
  steps: [
    TutorialStep(
      id: 'tap_area',
      title: '탭하여 자원을 모으세요',
      description: '화면을 탭하여 골드를 획득합니다.',
    ),
    TutorialStep(
      id: 'shop_button',
      title: '첫 업그레이드를 구매하세요',
      description: '상점에서 업그레이드를 구매하여 수입을 늘리세요.',
    ),
    TutorialStep(
      id: 'auto_button',
      title: '자동 수집을 해제하세요',
      description: '자동 수집기를 구매하면 탭 없이도 골드가 쌓입니다.',
    ),
    TutorialStep(
      id: 'prestige_button',
      title: '프레스티지로 성장하세요',
      description: '프레스티지를 통해 영구 보너스를 획득하세요.',
    ),
  ],
);
