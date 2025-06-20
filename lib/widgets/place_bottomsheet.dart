import 'package:flutter/material.dart';
import 'package:mindle/models/public_place.dart';

class PlaceBottomSheet extends StatelessWidget {
  final PublicPlace place;

  const PlaceBottomSheet({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      maxChildSize: 0.95,
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
                Text(place.name, style: const TextStyle(fontSize: 20)),
                Text(place.uniqueId),
                const SizedBox(height: 10),
                Text('주소: ${place.address}'),
                const SizedBox(height: 10),
                Text('유형: ${place.type.join(', ')}'),
                const SizedBox(height: 10),
                Text('위도: ${place.latitude}'),
                Text('경도: ${place.longitude}'),
                const SizedBox(height: 10),
                Text(
                  '사진 URL: ${place.photoUrl.isNotEmpty ? place.photoUrl : '없음'}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
