import 'package:flame/extensions.dart';
import 'dart:math';

class GridSystem {
  static const int gridWidth = 20;
  static const int gridHeight = 20;
  static const double tileWidth = 64.0;
  static const double tileHeight = 32.0; // Isometric tile height

  // 2D grid occupancy map: [x][y] -> occupied by instanceId
  // Null means empty
  final List<List<String?>> _occupancy = List.generate(
    gridWidth,
    (_) => List.generate(gridHeight, (_) => null),
  );

  void clear() {
    for (var x = 0; x < gridWidth; x++) {
      for (var y = 0; y < gridHeight; y++) {
        _occupancy[x][y] = null;
      }
    }
  }

  bool isOccupied(
    int x,
    int y, {
    int width = 1,
    int height = 1,
    String? ignoreId,
  }) {
    if (x < 0 || y < 0 || x + width > gridWidth || y + height > gridHeight) {
      return true; // Out of bounds is "occupied"
    }

    for (var i = x; i < x + width; i++) {
      for (var j = y; j < y + height; j++) {
        final occupiedId = _occupancy[i][j];
        if (occupiedId != null && occupiedId != ignoreId) {
          return true;
        }
      }
    }
    return false;
  }

  String? getOccupantId(int x, int y) {
    if (x < 0 || y < 0 || x >= gridWidth || y >= gridHeight) return null;
    return _occupancy[x][y];
  }

  void markOccupied(int x, int y, int width, int height, String instanceId) {
    for (var i = x; i < x + width; i++) {
      for (var j = y; j < y + height; j++) {
        _occupancy[i][j] = instanceId;
      }
    }
  }

  void unmarkOccupied(int x, int y, int width, int height) {
    for (var i = x; i < x + width; i++) {
      for (var j = y; j < y + height; j++) {
        _occupancy[i][j] = null;
      }
    }
  }

  // Isometric projection
  Vector2 gridToWorld(int x, int y) {
    // Basic Iso:
    // screen.x = (grid.x - grid.y) * (tile_width / 2)
    // screen.y = (grid.x + grid.y) * (tile_height / 2)
    // Centered on screen usually requires an offset

    double screenX = (x - y) * (tileWidth / 2);
    double screenY = (x + y) * (tileHeight / 2);
    return Vector2(screenX, screenY);
  }

  // Inverse isometric (approximate for picking)
  // This needs to be relative to the grid origin
  Point<int> worldToGrid(Vector2 worldPos) {
    // world.x / (w/2) = grid.x - grid.y
    // world.y / (h/2) = grid.x + grid.y

    double a = worldPos.x / (tileWidth / 2);
    double b = worldPos.y / (tileHeight / 2);

    // grid.x = (a + b) / 2
    // grid.y = (b - a) / 2

    int gridX = ((a + b) / 2).round();
    int gridY = ((b - a) / 2).round();

    return Point(gridX, gridY);
  }
}
