import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/location_controller.dart';
import 'package:mindle/widgets/location_select_panel.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  static const Color gray6 = Color(0xFFEDEDED);
  static const Color gray7 = Color(0xFF474747);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LocationController>();

    return Obx(() {
      final isSelecting = controller.isSelectingLocation.value;

      return PopScope(
        canPop: !isSelecting,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && isSelecting) {
            controller.disableSelectingLocation();
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              NaverMap(
                options: NaverMapViewOptions(
                  consumeSymbolTapEvents:
                      false, // 심볼 여부와 상관없이 onMapTapped 이벤트가 trigger 되도록 설정
                ),
                onMapReady: controller.setMapController,
                onMapTapped: (npoint, nlatlng) {
                  print("지도 탭됨");
                  if (isSelecting) {
                    controller.selectLocationToLatLng(nlatlng);
                  }
                },
              ),
              if (isSelecting)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _PanelLikeBottomSheet(),
                ),

              // 팁 메시지 - 지도 위 중앙에 표시
              Positioned(
                top: MediaQuery.of(context).size.height * 0.8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFF00D482),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      '꼭 눌러 AI 음성 챗봇을 사용해보세요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 플로팅 버튼
          floatingActionButton: (!isSelecting)
              ? Padding(
                  padding: const EdgeInsets.only(
                    bottom: 50,
                    right: 5,
                  ), // 버튼 위치 조정
                  child: FloatingActionButton(
                    foregroundColor: Colors.white,
                    backgroundColor: gray7.withValues(alpha: 0.85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onPressed: () {
                      controller.enableSelectingLocation();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/write_icon.png',
                          width: 23,
                          height: 23,
                          color: Colors.white,
                        ),
                        Text(
                          '글쓰기',
                          style: TextStyle(fontSize: 9, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : null, // 위치 선택중일 땐 플로팅버튼 비활성화
        ),
      );
    });
  }
}

class _PanelLikeBottomSheet extends StatefulWidget {
  @override
  State<_PanelLikeBottomSheet> createState() => _PanelLikeBottomSheetState();
}

class _PanelLikeBottomSheetState extends State<_PanelLikeBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
      // 패널이 위로 올라가는 건 제한
      if (_dragOffset < 0) _dragOffset = 0;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final screenHeight = MediaQuery.of(context).size.height * 0.35;

    // 드래그가 화면 높이의 25% 이상 내려가면 닫기
    if (_dragOffset > screenHeight * 0.25) {
      final controller = Get.find<LocationController>();
      controller
          .disableSelectingLocation(); // PopScope onPopInvokedWithResult와 동일 로직
    } else {
      // 아니면 다시 원위치 애니메이션
      setState(() {
        _dragOffset = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final panelHeight = MediaQuery.of(context).size.height * 0.35; // 패널 높이

    return SlideTransition(
      position: _offsetAnimation,
      child: Transform.translate(
        offset: Offset(0, _dragOffset),
        child: Material(
          elevation: 8,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: panelHeight,
              width: double.infinity,
              child: Column(
                children: [
                  // 손잡이 + 드래그 감지
                  GestureDetector(
                    behavior: HitTestBehavior.translucent, // 투명 영역도 터치 가능
                    onVerticalDragUpdate: _handleDragUpdate,
                    onVerticalDragEnd: _handleDragEnd,
                    child: Container(
                      height: 40, // 손잡이 터치 영역을 충분히 확보
                      alignment: Alignment.center,
                      child: Container(
                        width: 40,
                        height: 4, // 실제 시각적 손잡이
                        decoration: BoxDecoration(
                          color: MapPage.gray6,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),

                  // 패널 내용
                  Expanded(child: LocationSelectPanel()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
