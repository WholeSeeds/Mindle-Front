import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class SvgCacheService {
  static final SvgCacheService _instance = SvgCacheService._internal();
  factory SvgCacheService() => _instance;
  SvgCacheService._internal();

  final Map<String, ui.Picture> _pictureCache = {};
  final Map<String, Completer<ui.Picture>> _loadingCompleter = {};

  Future<ui.Picture> loadSvgAsPicture(
    String assetPath, {
    double? width,
    double? height,
    Color? color,
  }) async {
    final cacheKey = _generateCacheKey(assetPath, width, height, color);

    if (_pictureCache.containsKey(cacheKey)) {
      return _pictureCache[cacheKey]!;
    }

    if (_loadingCompleter.containsKey(cacheKey)) {
      return await _loadingCompleter[cacheKey]!.future;
    }

    final completer = Completer<ui.Picture>();
    _loadingCompleter[cacheKey] = completer;

    try {
      final svgString = await rootBundle.loadString(assetPath);
      final pictureInfo = await vg.loadPicture(
        SvgStringLoader(svgString),
        null,
      );

      final svgSize = pictureInfo.size; // ✅ viewport → size로 변경
      final targetWidth = width ?? svgSize.width;
      final targetHeight = height ?? svgSize.height;
      // 비율 유지: 두 축 중 더 작은 값을 사용
      final scale = [
        targetWidth / svgSize.width,
        targetHeight / svgSize.height,
      ].reduce((a, b) => a < b ? a : b);

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // 가운데 정렬 + 비율 유지
      final offsetX = (targetWidth / scale - svgSize.width) / 2;
      final offsetY = (targetHeight / scale - svgSize.height) / 2;
      canvas.scale(scale, scale);
      canvas.translate(offsetX, offsetY);

      if (color != null) {
        final paint = Paint()
          ..colorFilter = ColorFilter.mode(color, BlendMode.srcIn);
        canvas.saveLayer(
          Rect.fromLTWH(0, 0, svgSize.width, svgSize.height),
          paint,
        );
      }

      // ✅ pictureInfo.picture를 직접 그리면 됨
      canvas.drawPicture(pictureInfo.picture);

      if (color != null) {
        canvas.restore();
      }

      final picture = recorder.endRecording();

      _pictureCache[cacheKey] = picture;
      completer.complete(picture);
      return picture;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _loadingCompleter.remove(cacheKey);
    }
  }

  ui.Picture? getCachedPicture(
    String assetPath, {
    double? width,
    double? height,
    Color? color,
  }) {
    final cacheKey = _generateCacheKey(assetPath, width, height, color);
    return _pictureCache[cacheKey];
  }

  Future<void> preloadSvgs(List<SvgPreloadConfig> configs) async {
    final futures = configs.map(
      (config) => loadSvgAsPicture(
        config.assetPath,
        width: config.width,
        height: config.height,
        color: config.color,
      ),
    );
    await Future.wait(futures);
  }

  String _generateCacheKey(
    String assetPath,
    double? width,
    double? height,
    Color? color,
  ) {
    return '$assetPath:${width ?? 'null'}:${height ?? 'null'}:${color?.value ?? 'null'}';
  }

  void clearCache() => _pictureCache.clear();

  void removeCachedSvg(
    String assetPath, {
    double? width,
    double? height,
    Color? color,
  }) {
    final cacheKey = _generateCacheKey(assetPath, width, height, color);
    _pictureCache.remove(cacheKey);
  }

  bool isCached(
    String assetPath, {
    double? width,
    double? height,
    Color? color,
  }) {
    final cacheKey = _generateCacheKey(assetPath, width, height, color);
    return _pictureCache.containsKey(cacheKey);
  }
}

class SvgPreloadConfig {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;

  const SvgPreloadConfig({
    required this.assetPath,
    this.width,
    this.height,
    this.color,
  });
}
