import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/controllers/complaint_list_controller.dart';
import 'package:mindle/controllers/nbhd_controller.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/widgets/align_options_button.dart';
import 'package:mindle/widgets/complaint_card.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';
import 'package:mindle/widgets/region_select_button.dart';
import 'package:mindle/widgets/category_select_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindle/widgets/resolved_status_button.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final nbhdController = Get.find<NbhdController>();
  final complaintListController = Get.put(ComplaintListController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    complaintListController.loadComplaints(refresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      complaintListController.loadComplaints();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MindleTopAppBar(
        title: "민원목록",
        showBackButton: false,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ✅ 필터 선택 섹션 (하얀 배경)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: MindleColors.gray3,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '관심있는 민원 키워드를 검색해보세요',
                    style: MindleTextStyles.body1(
                      color: MindleColors.gray1,
                    ).copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                Spacing.vertical8,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 지역 필터
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const RegionSelectButton(),
                        Obx(() {
                          final hasFilters = complaintListController
                              .selectedCityCode
                              .value
                              .isNotEmpty;
                          if (!hasFilters) return const SizedBox.shrink();
                          return Container(
                            margin: const EdgeInsets.only(left: 6),
                            child: Wrap(
                              spacing: 8,
                              children: [
                                _buildFilterChip(
                                  complaintListController
                                      .getSelectedRegionText(),
                                  () => complaintListController
                                      .clearRegionFilter(),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                    // 카테고리 필터
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CategorySelectButton(),
                        Obx(() {
                          final hasFilters =
                              complaintListController.selectedCategoryId.value >
                              0;
                          if (!hasFilters) return const SizedBox.shrink();
                          return Container(
                            margin: const EdgeInsets.only(left: 6),
                            child: Wrap(
                              spacing: 8,
                              children: [
                                _buildFilterChip(
                                  complaintListController
                                      .getSelectedCategoryText(),
                                  () => complaintListController
                                      .clearCategoryFilter(),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ 하단 내용
          Spacing.vertical12,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Spacing.vertical16,
                  // 지도에서 보기 + 정렬
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed('/complaint_map');
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/map-01.svg',
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "지도에서 보기",
                              style: MindleTextStyles.body2(
                                color: MindleColors.gray2,
                              ).copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const ResolvedStatusButton(),
                          Spacing.horizontal4,
                          const AlignOptionsButton(),
                        ],
                      ),
                    ],
                  ),
                  Spacing.vertical12,

                  // 민원 목록
                  Expanded(
                    child: Obx(
                      () => RefreshIndicator(
                        onRefresh: () => complaintListController.loadComplaints(
                          refresh: true,
                        ),
                        child:
                            complaintListController.complaints.isEmpty &&
                                !complaintListController
                                    .isLoadingComplaints
                                    .value
                            ? const Center(child: Text('민원이 없습니다.'))
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount:
                                    complaintListController.complaints.length +
                                    (complaintListController
                                            .isLoadingComplaints
                                            .value
                                        ? 1
                                        : 0),
                                itemBuilder: (BuildContext context, int index) {
                                  if (index >=
                                      complaintListController
                                          .complaints
                                          .length) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  final complaint =
                                      complaintListController.complaints[index];
                                  return Column(
                                    children: [
                                      ComplaintCard(
                                        complaint: complaint,
                                        onTap: () {
                                          Get.toNamed(
                                            '/complaint_detail/${complaint.id}',
                                          );
                                        },
                                      ),
                                      Spacing.vertical12,
                                    ],
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MindleColors.gray6, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: MindleTextStyles.body2(
              color: MindleColors.gray2,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14, color: MindleColors.gray2),
          ),
        ],
      ),
    );
  }
}
