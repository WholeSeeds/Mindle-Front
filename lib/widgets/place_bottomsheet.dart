import 'package:flutter/material.dart';
import 'package:mindle/models/public_place.dart';
import 'package:mindle/pages/complaint_form_page.dart';
import 'package:mindle/widgets/complaint_card.dart';
import 'package:get/get.dart';

// 임시 민원 데이터
final List<Map<String, dynamic>> _complaintData = const [
  {
    "title": "횡단보도 선이 거의 지워졌어요",
    "content":
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    "numLikes": 45,
    "numComments": 2,
    "status": "no",
    "hasImage": true,
  },
  {
    "title": "Test",
    "content": "test",
    "numLikes": 100,
    "numComments": 21,
    "status": "solved",
    "hasImage": false,
  },
  {
    "title": "Test 2",
    "content": "test",
    "numLikes": 10,
    "numComments": 1,
    "status": "accepted",
    "hasImage": false,
  },
  {
    "title": "횡단보도 선이 거의 지워졌어요",
    "content":
        "근처 초등학교 앞 횡단보도의 흰색 선이 다 닳아 없어졌습니다. 아이들 통학길인데 매우 위험해 보여요. 빠른 재도색 요청드립니다.",
    "numLikes": 45,
    "numComments": 2,
    "status": "no",
    "hasImage": false,
  },
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
            Text(label),
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
        return Stack(
          children: [
            // 스크롤 가능한 컨테이너
            SingleChildScrollView(
              controller: scrollController,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(place.address),
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
                    const SizedBox(height: 10),
                    Column(
                      children: _complaintData.map((complaint) {
                        return ComplaintCard(
                          title: complaint["title"] as String,
                          content: complaint["content"] as String,
                          numLikes: complaint["numLikes"] as int,
                          numComments: complaint["numComments"] as int,
                          status: complaint["status"] as String,
                          hasImage: complaint["hasImage"] as bool,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            // 민원 작성 버튼
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 민원 작성 로직
                    Get.to(() => ComplaintFormPage(place: place));
                  },
                  child: const Text('민원 작성하기', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
