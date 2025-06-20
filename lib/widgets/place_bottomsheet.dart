import 'package:flutter/material.dart';
import 'package:mindle/models/public_place.dart';

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
                      child: Image.network(
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
                    const SizedBox(height: 15),
                    const Text(
                      '민원글목록입니다민원글목록입니다민원글목록입니다민원글목록입니다민원글목록입니다민원글목록입니다',
                      style: TextStyle(fontSize: 60),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 민원 작성 로직
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
