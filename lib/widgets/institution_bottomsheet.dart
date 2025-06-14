import 'package:flutter/material.dart';
import 'package:mindle/models/public_institution.dart';

class InstitutionBottomSheet extends StatelessWidget {
  final PublicInstitution institution;

  const InstitutionBottomSheet({super.key, required this.institution});

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
                Text(institution.name, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text('위도: ${institution.latitude}'),
                Text('경도: ${institution.longitude}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
