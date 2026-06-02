import 'package:flutter/material.dart';

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  const AppLocalizations();

  String get ui_general_battle_pass => 'Battle Pass';
  String get ui_general_tower_summon => 'Tower Summon';
  String get notification_claim_all__bpunclaimedrewardcount => 'Claim All';
  String get progress_level_battlepasscurrentlevel => 'Battle Pass';
  String get ui_general__gachatotalpulls_90_90 => 'Gacha';
  String get notification_rewardslength_rewards_claimed => 'Rewards Claimed';
  String get progress_tier_level_names => 'Tier';
}

// [STABILIZED] Local L10n Extension Removed

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return const AppLocalizations();
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
