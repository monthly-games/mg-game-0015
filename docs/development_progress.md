# MG-0015 개발 진척도

**게임명**: 왕국 재건 프로젝트 (Kingdom Rebuild Project)
**장르**: 방치형 + 도시 건설 + 스토리
**시작일**: 2025-07-01
**현재 진척도**: 20%

---

## 🎯 핵심 게임플레이

### 게임 루프
1. **건물 건설**: 다양한 건물을 건설하여 왕국 기능 확장
2. **방치 수익**: 오프라인 동안 자동으로 자원 생산
3. **스토리 진행**: 챕터별 스토리를 통해 왕국의 과거와 미래 발견
4. **주민 관리**: 주민을 배치하여 건물 효율 증가

### 핵심 차별점
- **스토리 기반의 점진적 왕국 재건**: 단순 방치형이 아닌 스토리 중심 경험
- **챕터 해금 시스템**: 스토리를 진행하며 새로운 지역과 건물 획득
- **왕국 단계 진화**: 폐허 → 정착지 → 마을 → 도시 → 왕국으로 발전
- **장기 운영형 타이틀**: Year 2 핵심 타이틀 후보

---

## ✅ 완료된 기능

### 1. 기본 자원 시스템 (100%)
- ✅ 골드/목재/석재 자원 관리
- ✅ 방치 수익 생성 (시간 기반)
- ✅ 클릭 수집 기능 (세금 징수)
- ✅ 자원 표시 HUD (상단 바)
- ✅ 세이브/로드 (SharedPreferences)

**파일**:
- [resource_manager.dart](../game/lib/features/resources/resource_manager.dart)

### 2. 건물 시스템 (50%)
- ✅ 건물 데이터 모델 (BuildingData)
- ✅ 3종 기본 건물 (성, 벌목소, 채석장)
- ✅ 건물 업그레이드 시스템 (레벨 1-50)
- ✅ 건물별 생산량 증가
- ✅ 건물 비용 계산 (exponential scaling)
- ✅ 건물 컴포넌트 렌더링 (Flame canvas)
- ⬜ 다양한 건물 카테고리 (생산/주거/문화/군사/특수)
- ⬜ 건물 배치 시스템
- ⬜ 건물 외형 변화 (레벨별)
- ⬜ 건설 대기열
- ⬜ 건물 장식/커스터마이징

**파일**:
- [building_data.dart](../game/lib/features/buildings/building_data.dart)
- [building_component.dart](../game/lib/features/buildings/building_component.dart)

### 3. 게임 엔진 통합 (80%)
- ✅ Flame 엔진 통합
- ✅ Provider 상태 관리
- ✅ GetIt DI 설정
- ✅ AudioManager 통합 (mg_common_game)
- ✅ AppColors 테마 통합
- ✅ 게임 루프 (update/render)
- ✅ 건물 스포닝
- ✅ Floating text 이펙트
- ⬜ 카메라 시스템 (확대/축소/이동)
- ⬜ 애니메이션 시스템

**파일**:
- [main.dart](../game/lib/main.dart)
- [kingdom_game.dart](../game/lib/game/kingdom_game.dart)
- [floating_text.dart](../game/lib/game/components/floating_text.dart)

### 4. UI/UX (60%)
- ✅ Material Design Dark Theme
- ✅ 자원 표시 바
- ✅ 건물 패널 (Bottom Sheet 스타일)
- ✅ 건물 아이콘 및 색상 구분
- ✅ 업그레이드 버튼
- ✅ 리스트 스크롤
- ⬜ 설정 화면
- ⬜ 튜토리얼
- ⬜ 스토리 UI
- ⬜ 왕국 단계 표시

---

## 🚧 진행 중 작업

없음

---

## ⬜ 미구현 주요 기능

### 1. 스토리 시스템 (0%) ⭐ 핵심!
GDD의 가장 중요한 차별점. 현재 구현 안 됨.

**구현 필요 항목**:
```dart
// 1. Story Data Model
class StoryChapter {
  String id;
  String title;
  String description;
  List<StoryDialogue> dialogues;
  List<BuildingType> unlockedBuildings;
  Map<String, double> rewards;
}

class StoryDialogue {
  String character;
  String text;
  String? characterImage;
  List<DialogueChoice>? choices;
}

class DialogueChoice {
  String text;
  String nextDialogueId;
  Map<String, double>? rewardModifier;
}

// 2. Story Manager (Provider)
class StoryManager extends ChangeNotifier {
  int _currentChapter = 0;
  List<StoryChapter> _completedChapters = [];

  void startChapter(int chapter);
  void completeChapter();
  void unlockBuilding(BuildingType type);
}

// 3. Story UI Components
// - Dialogue screen with character portraits
// - Dialogue choices buttons
// - Chapter complete screen
// - Story progress indicator
```

**스토리 챕터 예시** (GDD 기반):
1. **챕터 1: 폐허의 왕국** - 튜토리얼, 성 복구 시작
2. **챕터 2: 첫 번째 정착민** - 주거 건물 해금
3. **챕터 3: 잊혀진 역사** - 과거 왕국의 비밀 발견
4. **챕터 4-10+**: 점진적 왕국 재건

### 2. 왕국 단계 시스템 (0%)
폐허 → 정착지 → 마을 → 도시 → 왕국으로 진화

**구현 필요 항목**:
- KingdomStage enum (ruins, settlement, town, city, kingdom)
- 단계별 시각적 변화 (배경, 건물 스타일)
- 단계별 해금 건물
- 단계 진행 조건 (건물 수, 인구, 스토리 진행)
- UI에 현재 단계 표시

### 3. NPC/캐릭터 시스템 (0%)
스토리를 이끄는 캐릭터들

**구현 필요 항목**:
- Character data model
- Character portraits
- Character dialogue system
- Character relationships
- 주요 캐릭터: 왕, 참모, 장군, 상인, 마법사 등

### 4. 이벤트 및 위기 시스템 (0%)
라이브 운영을 위한 이벤트 시스템

**구현 필요 항목**:
- Crisis events (기근, 전쟁, 재해)
- Limited-time events
- Event rewards
- Event UI
- Event scheduling system

### 5. 프리미엄 화폐 시스템 (0%)
보석(Gem) 시스템

**구현 필요 항목**:
- Gem currency
- Gem shop
- Speed-up mechanics
- Premium buildings
- IAP integration

### 6. 주민 관리 시스템 (0%)
건물 효율을 높이는 주민 배치

**구현 필요 항목**:
- Citizen data model
- Citizen assignment to buildings
- Efficiency bonuses
- Population management
- Housing requirements

### 7. 고급 건물 시스템 (0%)
**필요한 추가 건물 카테고리**:
- **생산 건물**: 농장, 광산, 어장, 작업장
- **주거 건물**: 오두막, 주택, 아파트, 저택
- **문화 건물**: 시장, 성당, 극장, 도서관
- **군사 건물**: 병영, 훈련소, 성벽, 감시탑
- **특수 건물**: 마법탑, 길드 홀, 박물관

### 8. 광고 통합 (0%)
보상형 광고 시스템

**구현 필요 항목**:
- Ad SDK integration
- Reward ad placement (생산 2배, 즉시 완료)
- Ad cooldown management

### 9. 고급 UI/UX (0%)
- 스킬 북 스타일 건물 도감
- 왕국 지도 (확대/축소/스크롤)
- 튜토리얼 시스템
- 설정 화면
- 업적 시스템
- 일일 로그인 보너스

---

## 📋 우선순위별 작업 목록

### 우선순위 1: 핵심 게임 루프 완성 (⚠️ 가장 중요!)
1. ⬜ **스토리 시스템 구현** ⭐
   - StoryManager 및 StoryData 모델
   - 3-5개 초기 챕터 작성
   - 다이얼로그 UI 구현
   - 챕터 완료 보상 연동
   - 건물 해금 시스템 연동
2. ⬜ **왕국 단계 시스템**
   - 5단계 진화 시스템
   - 단계별 비주얼 변화
   - 단계 진행 조건
3. ⬜ **NPC/캐릭터 시스템**
   - 주요 캐릭터 5명 생성
   - 캐릭터 초상화
   - 다이얼로그 시스템

### 우선순위 2: 컨텐츠 확장
1. ⬜ **다양한 건물 추가** (현재 3종 → 20종+)
   - 생산 건물 (5종)
   - 주거 건물 (4종)
   - 문화 건물 (4종)
   - 군사 건물 (4종)
   - 특수 건물 (3종)
2. ⬜ **주민 관리 시스템**
   - 인구 시스템
   - 주민 배치
   - 효율 보너스
3. ⬜ **건물 배치 시스템**
   - 그리드 기반 배치
   - 건물 회전
   - 장식 시스템

### 우선순위 3: 수익화 및 라이브 운영
1. ⬜ **프리미엄 화폐 (보석) 시스템**
   - Gem 획득/사용
   - IAP 통합
   - 프리미엄 건물
2. ⬜ **광고 통합**
   - 보상형 광고
   - 광고 배치 (생산 2배, 즉시 완료)
3. ⬜ **이벤트 시스템**
   - 위기 이벤트
   - 한정 이벤트
   - 이벤트 보상
4. ⬜ **라이브 운영 준비**
   - Firebase 백엔드 연동
   - 원격 구성 (RemoteConfig)
   - 푸시 알림

### 우선순위 4: 폴리싱
1. ⬜ **애니메이션 및 이펙트**
   - 건물 건설 애니메이션
   - 자원 수집 이펙트
   - 화면 전환 애니메이션
2. ⬜ **사운드 및 음악**
   - BGM (평화로운 왕국 테마)
   - 건설/업그레이드 SFX
   - UI 상호작용 SFX
3. ⬜ **튜토리얼 및 온보딩**
   - 초보자 가이드
   - 인터랙티브 튜토리얼
   - 툴팁 시스템

---

## 📊 진척도 요약

| 시스템 | 진척도 | 상태 |
|--------|--------|------|
| 자원 시스템 | 100% | ✅ 완료 |
| 건물 시스템 (기본) | 50% | 🚧 진행 중 |
| 게임 엔진 통합 | 80% | 🚧 진행 중 |
| UI/UX (기본) | 60% | 🚧 진행 중 |
| **스토리 시스템** | 0% | ⬜ 미착수 ⭐ |
| 왕국 단계 시스템 | 0% | ⬜ 미착수 |
| NPC/캐릭터 시스템 | 0% | ⬜ 미착수 |
| 이벤트 시스템 | 0% | ⬜ 미착수 |
| 주민 관리 | 0% | ⬜ 미착수 |
| 프리미엄 화폐 | 0% | ⬜ 미착수 |
| 광고 통합 | 0% | ⬜ 미착수 |
| 고급 건물 (20종+) | 15% | ⬜ 미착수 |

**전체 진척도**: 20%

---

## 🐛 알려진 이슈

1. **스토리 시스템 미구현**: 게임의 핵심 차별점이 없음 - 단순 방치형 게임과 차별화 불가
2. **건물 종류 부족**: 현재 3종 (목표 20종+)
3. **건물 배치 없음**: 건물 위치 고정, 사용자가 배치 불가
4. **왕국 단계 없음**: 시각적 진화 부재
5. **주민 시스템 없음**: 건물 효율 증가 메커니즘 없음
6. **카메라 제어 없음**: 확대/축소/이동 불가

---

## 📝 다음 작업

### 현재 상태
- MG-0015의 기본 방치형 게임 구조는 완성 (20%)
- 하지만 **핵심 차별점인 스토리 시스템이 없음** ⚠️
- 현재는 단순 방치형 게임 MVP 수준

### 긴급 우선순위 작업
1. **스토리 시스템 구현** (가장 중요!)
   - StoryManager 및 데이터 모델
   - 다이얼로그 UI
   - 3-5개 초기 챕터 작성
   - 건물 해금 연동
2. **왕국 단계 시스템**
   - 5단계 진화 (폐허→정착지→마을→도시→왕국)
   - 시각적 변화
3. **건물 확장**
   - 3종 → 10-15종으로 확대
   - 건물 카테고리 다양화

### 목표
- **2-3주 내**: 스토리 시스템 MVP 완성
- **1-2개월 내**: 왕국 단계 시스템 및 건물 확장
- **3개월 내**: 수익화 통합 및 소프트 론칭 준비

---

## 📚 관련 문서

- [GDD](design/gdd_game_0015.json) - 게임 디자인 문서
- [비즈니스 모델](bm_design.md) - F2P + IAP + Ads, 0.12-0.18 ARPU 목표
- [Fun Design](fun_design.md) - 3대 재미 요소 (성장/표현/내러티브)
- [운영 전략](ops_design.md) - Year 1 라이브 운영 계획
- [수익화 전략](monetization_design.md) - IAP 패키지 및 광고 배치

---

**작성일**: 2025-12-17
**버전**: 1.0
**작성자**: Claude Code (MG Development Assistant)
