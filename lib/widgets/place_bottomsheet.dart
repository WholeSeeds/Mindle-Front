import 'package:flutter/material.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/models/complaint.dart';
import 'package:mindle/models/complaint_status.dart';
import 'package:mindle/models/public_place.dart';
import 'package:mindle/models/region_info.dart';
import 'package:mindle/pages/complaint_form_page.dart';
import 'package:mindle/services/naver_maps_service.dart';
import 'package:mindle/widgets/complaint_card.dart';
import 'package:get/get.dart';

// 임시 민원 데이터
final List<Complaint> _complaintData = [
  Complaint(
    title: '도로 신호등이 고장났어요',
    content: '우리 동네 메인 도로 신호등이 고장나서 위험해요. 빨리 수리해 주세요!',
    numLikes: 120,
    numComments: 45,
    complaintStatus: ComplaintStatus.solved,
    hasImage: true,
  ),
  Complaint(
    title: "횡단보도 선이 거의 지워졌어요",
    content:
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    numLikes: 45,
    numComments: 2,
    complaintStatus: ComplaintStatus.waiting,
    hasImage: true,
  ),
  Complaint(
    title: "횡단보도 선이 거의 지워졌어요",
    content:
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    numLikes: 45,
    numComments: 2,
    complaintStatus: ComplaintStatus.solving,
    hasImage: true,
  ),
  Complaint(
    title: "횡단보도 선이 거의 지워졌어요",
    content:
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    numLikes: 45,
    numComments: 2,
    complaintStatus: ComplaintStatus.waiting,
    hasImage: true,
  ),
  Complaint(
    title: "횡단보도 선이 거의 지워졌어요",
    content:
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    numLikes: 45,
    numComments: 2,
    complaintStatus: ComplaintStatus.waiting,
    hasImage: true,
  ),
];

class ComplaintStatCard extends StatelessWidget {
  final String label; // ex) "오늘의 민원"
  final int count;

  const ComplaintStatCard({
    super.key,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: [
            Text(
              label,
              style: MindleTextStyles.body2(color: MindleColors.gray1),
            ),
            const SizedBox(height: 5),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceBottomSheet extends StatelessWidget {
  final PublicPlace place;

  const PlaceBottomSheet({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Text(place.address),
                          FutureBuilder<RegionInfo>(
                            future: Get.find<NaverMapsService>().reverseGeoCode(
                              place.latitude,
                              place.longitude,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text(
                                  '주소를 불러오는 중...',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              } else if (snapshot.hasError) {
                                return const Text(
                                  '주소를 불러오는 데 실패했습니다.',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null) {
                                return const Text(
                                  '주소 정보가 없습니다.',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              } else {
                                final region = snapshot.data!;
                                return Text(region.fullAddressString());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        Get.to(
                          () => ComplaintFormPage(
                            place: place,
                            regionInfo: RegionInfo.empty(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10), // 버튼 크기 결정
                        decoration: BoxDecoration(
                          color: MindleColors.gray3,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: MindleColors.mainGreen,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // 콘텐츠 크기에 맞춤
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/write_icon.png',
                              width: 22,
                              height: 22,
                              color: MindleColors.mainGreen,
                            ),
                            Text(
                              '글쓰기',
                              style: MindleTextStyles.body5(
                                color: MindleColors.mainGreen,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: (place.photoUrl.isEmpty)
                      ?
                        // 사진이 없을 경우 대체 컨테이너
                        Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(Icons.no_sim, size: 30),
                          ),
                        )
                      : Image.network(
                          place.photoUrl,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover, // 비율 변경 X, 설정한 크기를 덮는다
                        ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const <Widget>[
                    ComplaintStatCard(label: "오늘의 민원", count: 5),
                    ComplaintStatCard(label: "처리중인 민원", count: 20),
                    ComplaintStatCard(label: "나의 민원", count: 10000),
                  ],
                ),
                const SizedBox(height: 30),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _complaintData.length,
                  itemBuilder: (context, index) {
                    final complaint = _complaintData[index];
                    return Column(
                      children: [
                        ComplaintCard(complaint: complaint),
                        const SizedBox(height: 12),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
