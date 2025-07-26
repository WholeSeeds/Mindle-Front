import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/complaint_detail_controller.dart';
import 'package:mindle/models/comment.dart';

class ComplaintDetailPage extends StatelessWidget {
  final ComplaintDetailController controller = Get.put(
    ComplaintDetailController(),
  );
  final String complaintId;

  ComplaintDetailPage({Key? key, required this.complaintId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.loadComplaintDetail(complaintId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text('민원 상세', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.complaint.value == null) {
          return const Center(child: Text('민원 정보를 불러올 수 없습니다.'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildLocationInfo(),
              _buildAuthorInfo(),
              _buildComplaintContent(),
              _buildImageSection(),
              _buildInteractionSection(),
              _buildResolutionSection(),
              _buildCommentsSection(),
              _buildCommentInput(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLocationInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.green, size: 20),
              const SizedBox(width: 4),
              Obx(
                () => Text(
                  controller.place.value?.name ?? '위치 정보 없음',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(
              '${controller.category.value} 관련 신고',
              style: TextStyle(color: Colors.green[300], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 16,
            child: Icon(Icons.person, color: Colors.grey[400], size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.author.value?.name ?? '익명',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  '05/17 23:14', // 임시 하드코딩
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    controller.complaint.value?.title ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Obx(
                  () => Text(
                    controller.isResolved.value ? '해결됨' : '처리중',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(
            () => Text(
              controller.complaint.value?.content ?? '',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Obx(() {
      if (controller.complaintImages.isEmpty) return SizedBox.shrink();

      return Container(
        height: 200,
        margin: const EdgeInsets.all(16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: PageView.builder(
                onPageChanged: (index) =>
                    controller.currentImageIndex.value = index,
                itemCount: controller.complaintImages.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    controller.complaintImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey[500],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (controller.complaintImages.length > 1)
              Positioned(
                right: 16,
                bottom: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(
                    () => Text(
                      '${controller.currentImageIndex.value + 1}/${controller.complaintImages.length}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildInteractionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildInteractionButton(
            Icons.comment_outlined,
            controller.complaint.value?.numComments ?? 0,
            () {},
          ),
          const SizedBox(width: 12),
          _buildInteractionButton(
            Icons.favorite_border,
            controller.complaint.value?.numLikes ?? 0,
            () => controller.toggleComplaintLike(complaintId),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(IconData icon, int count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 4),
          Text('$count', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildResolutionSection() {
    return Obx(() {
      if (controller.isResolved.value) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    '해결된 민원이에요!',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_up, color: Colors.green),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildBeforeAfterImage('Before', 'before_image_url'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildBeforeAfterImage('After', 'after_image_url'),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Obx(
                () => Checkbox(
                  value: controller.isComplaintResolvedCheckboxSelected.value,
                  onChanged: (value) {
                    controller.isComplaintResolvedCheckboxSelected.value =
                        value ?? false;
                  },
                  activeColor: Colors.green,
                ),
              ),
              Icon(Icons.star, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                '민원이 해결되었나요?',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }
    });
  }

  Widget _buildBeforeAfterImage(String label, String imageUrl) {
    return Column(
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Text(label)),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Obx(() {
      if (controller.comments.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text('댓글이 없습니다', style: TextStyle(color: Colors.grey)),
          ),
        );
      }

      return Column(
        children: controller.comments
            .map((comment) => _buildCommentItem(comment))
            .toList(),
      );
    });
  }

  Widget _buildCommentItem(Comment comment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 14,
                child: Icon(Icons.person, color: Colors.grey[400], size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                comment.author.name,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              Text(
                '${comment.createdAt.month}/${comment.createdAt.day} ${comment.createdAt.hour}:${comment.createdAt.minute.toString().padLeft(2, '0')}',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment.content),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () => controller.toggleCommentLike(comment.id),
                child: Row(
                  children: [
                    Icon(Icons.favorite_border, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${comment.numLikes}',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text('답글 3', style: TextStyle(color: Colors.blue, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.commentInputController,
              decoration: InputDecoration(
                hintText: '댓글을 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () => controller.addComment(
              complaintId,
              controller.commentInputController.text,
            ),
          ),
        ],
      ),
    );
  }
}
