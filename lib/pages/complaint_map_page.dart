import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/complaint_list_controller.dart';
import 'package:mindle/models/complaint.dart';
import 'package:mindle/widgets/complaint_card.dart';

class ComplaintBottomSheet extends StatelessWidget {
  final List<Complaint> complaints;

  const ComplaintBottomSheet({super.key, required this.complaints});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      height: MediaQuery.of(context).size.height * 0.5, // 화면 반 정도
      child: complaints.isEmpty
          ? Center(
              child: Text(
                '표시할 민원이 없습니다.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: complaints.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final complaint = complaints[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed('/complaint_detail/${complaint.id}');
                  },
                  child: ComplaintCard(complaint: complaint),
                );
              },
            ),
    );
  }
}

class ComplaintMapPage extends StatefulWidget {
  const ComplaintMapPage({super.key});

  @override
  State<ComplaintMapPage> createState() => _ComplaintMapPageState();
}

class _ComplaintMapPageState extends State<ComplaintMapPage> {
  final controller = Get.find<ComplaintListController>();
  Complaint? selectedComplaint;

  @override
  void initState() {
    super.initState();
    controller.onMarkerTap = showComplaintBottomSheet;
  }

  void showComplaintBottomSheet(Complaint complaint) {
    final complaintList = [complaint];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ComplaintBottomSheet(complaints: complaintList),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              consumeSymbolTapEvents:
                  false, // 심볼 여부와 상관없이 onMapTapped 이벤트가 trigger 되도록 설정
            ),
            clusterOptions: NaverMapClusteringOptions(
              clusterMarkerBuilder: (info, clusterMarker) {
                controller.buildClusterMarker(info, clusterMarker);
              },
            ),

            onMapReady: controller.setMapController,
            onMapTapped: (npoint, nlatlng) {
              print("지도 탭됨");
            },
          ),
          Obx(() {
            if (controller.isLoadingLocations.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
