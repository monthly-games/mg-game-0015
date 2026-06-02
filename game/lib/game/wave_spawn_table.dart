class WaveSpawnEntry {
  const WaveSpawnEntry({
    required this.stage,
    required this.wave,
    required this.enemyCount,
    required this.spawnCadenceSeconds,
    required this.pressureBudget,
    required this.winCondition,
  });

  final String stage;
  final int wave;
  final int enemyCount;
  final double spawnCadenceSeconds;
  final int pressureBudget;
  final String winCondition;
}

const kWaveSpawnTable = <WaveSpawnEntry>[
  WaveSpawnEntry(
    stage: 'Basic Village Hut',
    wave: 1,
    enemyCount: 5,
    spawnCadenceSeconds: 2.82,
    pressureBudget: 17,
    winCondition: 'Rebuild the kingdom: Raise the first safe shelter',
  ),
  WaveSpawnEntry(
    stage: 'Small Farm Build',
    wave: 2,
    enemyCount: 7,
    spawnCadenceSeconds: 2.74,
    pressureBudget: 22,
    winCondition: 'Rebuild the kingdom: Plant the first food route',
  ),
  WaveSpawnEntry(
    stage: 'Basic Mine Shack',
    wave: 3,
    enemyCount: 9,
    spawnCadenceSeconds: 2.66,
    pressureBudget: 28,
    winCondition: 'Rebuild the kingdom: Reopen a stone supply point',
  ),
  WaveSpawnEntry(
    stage: 'Small Builder Workshop',
    wave: 4,
    enemyCount: 11,
    spawnCadenceSeconds: 2.58,
    pressureBudget: 35,
    winCondition: 'Rebuild the kingdom: Train builders for faster repairs',
  ),
  WaveSpawnEntry(
    stage: 'Basic Village Storehouse',
    wave: 5,
    enemyCount: 13,
    spawnCadenceSeconds: 2.50,
    pressureBudget: 43,
    winCondition: 'Rebuild the kingdom: Secure resources against raids',
  ),
  WaveSpawnEntry(
    stage: 'Restore Village Hall',
    wave: 6,
    enemyCount: 15,
    spawnCadenceSeconds: 2.42,
    pressureBudget: 52,
    winCondition:
        'Rebuild the kingdom: Reopen town decisions and worker planning',
  ),
  WaveSpawnEntry(
    stage: 'Construct Farm Terrace',
    wave: 7,
    enemyCount: 17,
    spawnCadenceSeconds: 2.34,
    pressureBudget: 62,
    winCondition: 'Rebuild the kingdom: Expand food production up the ridge',
  ),
  WaveSpawnEntry(
    stage: 'Kingdom Mine Works',
    wave: 8,
    enemyCount: 19,
    spawnCadenceSeconds: 2.26,
    pressureBudget: 73,
    winCondition:
        'Rebuild the kingdom: Chain mine output into construction flow',
  ),
  WaveSpawnEntry(
    stage: 'Castle Wall Foundation',
    wave: 9,
    enemyCount: 21,
    spawnCadenceSeconds: 2.18,
    pressureBudget: 85,
    winCondition: 'Rebuild the kingdom: Lay the first defensive ring',
  ),
  WaveSpawnEntry(
    stage: 'Restore Market Square',
    wave: 10,
    enemyCount: 23,
    spawnCadenceSeconds: 2.10,
    pressureBudget: 98,
    winCondition: 'Rebuild the kingdom: Bring trade back to the central plaza',
  ),
  WaveSpawnEntry(
    stage: 'Grand Castle Gate',
    wave: 11,
    enemyCount: 25,
    spawnCadenceSeconds: 2.02,
    pressureBudget: 112,
    winCondition:
        'Rebuild the kingdom: Fortify the main gate before pressure peaks',
  ),
  WaveSpawnEntry(
    stage: 'Castle Keep Restoration',
    wave: 12,
    enemyCount: 27,
    spawnCadenceSeconds: 1.94,
    pressureBudget: 127,
    winCondition: 'Rebuild the kingdom: Restore command rooms inside the keep',
  ),
  WaveSpawnEntry(
    stage: 'Grand Palace Wing',
    wave: 13,
    enemyCount: 29,
    spawnCadenceSeconds: 1.86,
    pressureBudget: 143,
    winCondition: 'Rebuild the kingdom: Repair noble quarters for diplomacy',
  ),
  WaveSpawnEntry(
    stage: 'Kingdom Monument Plaza',
    wave: 14,
    enemyCount: 31,
    spawnCadenceSeconds: 1.78,
    pressureBudget: 160,
    winCondition: 'Rebuild the kingdom: Restore morale with a central monument',
  ),
  WaveSpawnEntry(
    stage: 'Castle Harbor',
    wave: 15,
    enemyCount: 33,
    spawnCadenceSeconds: 1.70,
    pressureBudget: 178,
    winCondition: 'Rebuild the kingdom: Reconnect river supply lines',
  ),
  WaveSpawnEntry(
    stage: 'Palace Garden Build',
    wave: 16,
    enemyCount: 35,
    spawnCadenceSeconds: 1.62,
    pressureBudget: 197,
    winCondition:
        'Rebuild the kingdom: Balance beauty, food, and citizen happiness',
  ),
  WaveSpawnEntry(
    stage: 'Grand Aqueduct',
    wave: 17,
    enemyCount: 37,
    spawnCadenceSeconds: 1.54,
    pressureBudget: 217,
    winCondition: 'Rebuild the kingdom: Bring clean water across the capital',
  ),
  WaveSpawnEntry(
    stage: 'Monument Watchtower',
    wave: 18,
    enemyCount: 39,
    spawnCadenceSeconds: 1.46,
    pressureBudget: 238,
    winCondition: 'Rebuild the kingdom: Guard the borders and spot raids early',
  ),
  WaveSpawnEntry(
    stage: 'Castle Barracks',
    wave: 19,
    enemyCount: 41,
    spawnCadenceSeconds: 1.38,
    pressureBudget: 260,
    winCondition: 'Rebuild the kingdom: Train defenders for the next expansion',
  ),
  WaveSpawnEntry(
    stage: 'Kingdom Treasury',
    wave: 20,
    enemyCount: 43,
    spawnCadenceSeconds: 1.30,
    pressureBudget: 283,
    winCondition: 'Rebuild the kingdom: Protect long-term wealth and taxes',
  ),
  WaveSpawnEntry(
    stage: 'Grand Cathedral Build',
    wave: 21,
    enemyCount: 45,
    spawnCadenceSeconds: 1.22,
    pressureBudget: 307,
    winCondition:
        'Rebuild the kingdom: Complete a landmark for citizen loyalty',
  ),
  WaveSpawnEntry(
    stage: 'Palace Armory',
    wave: 22,
    enemyCount: 47,
    spawnCadenceSeconds: 1.14,
    pressureBudget: 332,
    winCondition: 'Rebuild the kingdom: Equip elite builders and guards',
  ),
  WaveSpawnEntry(
    stage: 'Monument Bridge',
    wave: 23,
    enemyCount: 49,
    spawnCadenceSeconds: 1.06,
    pressureBudget: 358,
    winCondition: 'Rebuild the kingdom: Connect outer villages to the capital',
  ),
  WaveSpawnEntry(
    stage: 'Castle Archive',
    wave: 24,
    enemyCount: 51,
    spawnCadenceSeconds: 0.98,
    pressureBudget: 385,
    winCondition:
        'Rebuild the kingdom: Recover blueprints for ancient structures',
  ),
  WaveSpawnEntry(
    stage: 'Grand Citadel',
    wave: 25,
    enemyCount: 53,
    spawnCadenceSeconds: 0.90,
    pressureBudget: 413,
    winCondition: 'Rebuild the kingdom: Finish the strongest defensive tier',
  ),
  WaveSpawnEntry(
    stage: 'Palace Observatory',
    wave: 26,
    enemyCount: 55,
    spawnCadenceSeconds: 0.82,
    pressureBudget: 442,
    winCondition:
        'Rebuild the kingdom: Forecast threats and prosperity windows',
  ),
  WaveSpawnEntry(
    stage: 'Kingdom Grand Harbor',
    wave: 27,
    enemyCount: 57,
    spawnCadenceSeconds: 0.74,
    pressureBudget: 472,
    winCondition: 'Rebuild the kingdom: Open overseas trade and migration',
  ),
  WaveSpawnEntry(
    stage: 'Monument Crown Hall',
    wave: 28,
    enemyCount: 59,
    spawnCadenceSeconds: 0.66,
    pressureBudget: 503,
    winCondition: 'Rebuild the kingdom: Host the first full council ceremony',
  ),
  WaveSpawnEntry(
    stage: 'Castle Throne Restoration',
    wave: 29,
    enemyCount: 61,
    spawnCadenceSeconds: 0.58,
    pressureBudget: 535,
    winCondition:
        'Rebuild the kingdom: Restore the throne and final civic systems',
  ),
  WaveSpawnEntry(
    stage: 'Grand Kingdom Reborn',
    wave: 30,
    enemyCount: 63,
    spawnCadenceSeconds: 0.50,
    pressureBudget: 568,
    winCondition:
        'Rebuild the kingdom: Complete the capital and unlock repeatable prestige',
  ),
];
