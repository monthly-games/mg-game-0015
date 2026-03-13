import 'package:mg_common_game/core/assets/asset_types.dart';

/// Spine 통합 플래그. `--dart-define=SPINE_ENABLED=true`로 활성화.
const kSpineEnabled = bool.fromEnvironment(
  'SPINE_ENABLED',
  defaultValue: false,
);

// ── King ─────────────────────────────────────────────────────

const kKingMeta = SpineAssetMeta(
  key: 'king',
  path: 'spine/characters/king',
  atlasPath: 'assets/spine/characters/king/king.atlas',
  skeletonPath: 'assets/spine/characters/king/king.skel',
  animations: ['idle', 'walk', 'attack', 'hit'],
  defaultAnimation: 'idle',
  defaultMix: 0.2,
);

// ── Builder ──────────────────────────────────────────────────

const kBuilderMeta = SpineAssetMeta(
  key: 'builder',
  path: 'spine/characters/builder',
  atlasPath: 'assets/spine/characters/builder/builder.atlas',
  skeletonPath: 'assets/spine/characters/builder/builder.skel',
  animations: ['idle', 'walk', 'attack', 'hit'],
  defaultAnimation: 'idle',
  defaultMix: 0.2,
);

// ── Soldier ──────────────────────────────────────────────────

const kSoldierMeta = SpineAssetMeta(
  key: 'soldier',
  path: 'spine/characters/soldier',
  atlasPath: 'assets/spine/characters/soldier/soldier.atlas',
  skeletonPath: 'assets/spine/characters/soldier/soldier.skel',
  animations: ['idle', 'walk', 'attack', 'hit'],
  defaultAnimation: 'idle',
  defaultMix: 0.2,
);
