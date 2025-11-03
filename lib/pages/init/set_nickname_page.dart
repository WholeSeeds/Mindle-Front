import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/pages/init/set_nbhd_page.dart';
import 'package:mindle/services/token_service.dart';
import 'package:mindle/widgets/mindle_textbutton.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';

class SetNicknamePage extends StatefulWidget {
  const SetNicknamePage({super.key});

  @override
  State<SetNicknamePage> createState() => _SetNicknamePageState();
}

class _SetNicknamePageState extends State<SetNicknamePage> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _isNicknameValid = false;
  bool _isDuplicateChecked = false;
  bool _isLoading = false;
  late final Dio _dio;
  late final TokenService _tokenService;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_validateNickname);
    _tokenService = Get.find<TokenService>();
    _initDio();
  }

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl:
            "${dotenv.env['SERVER_HOST']!}:${dotenv.env['SERVER_PORT']!}/api",
        connectTimeout: const Duration(seconds: 30),
      ),
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _validateNickname() {
    setState(() {
      _isNicknameValid = _nicknameController.text.trim().isNotEmpty;
      _isDuplicateChecked = false; // 닉네임이 변경되면 중복확인 재설정
    });
  }

  void _checkDuplicate() {
    if (_nicknameController.text.trim().isNotEmpty) {
      // TODO: 중복확인 로직 구현
      setState(() {
        _isDuplicateChecked = true;
      });
      // 임시로 성공 처리
      // Get.snackbar('확인', '사용 가능한 닉네임입니다.');
    }
  }

  Future<void> _onComplete() async {
    if (_isNicknameValid && _isDuplicateChecked && !_isLoading) {
      await _saveNickname();
    }
  }

  Future<void> _saveNickname() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('🏷️ 닉네임 저장 요청: ${_nicknameController.text.trim()}');

      final response = await _dio.patch(
        '/member/nickname',
        data: {'nickname': _nicknameController.text.trim()},
        options: Options(headers: _tokenService.getAuthHeaders()),
      );

      if (response.statusCode == 200) {
        print('✅ 닉네임 저장 성공: ${response.data}');
        // Get.snackbar('성공', '닉네임이 설정되었습니다.');
        Get.to(() => SetNbhdPage());
      } else {
        throw Exception('닉네임 저장 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 닉네임 저장 오류: $e');
      Get.snackbar('오류', '닉네임 저장에 실패했습니다.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MindleTopAppBar(title: '닉네임 설정'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.vertical30,
            Text('뭐라고 부르면 좋을까요?', style: MindleTextStyles.headline1()),
            Spacing.vertical8,
            Text(
              '앱에서 사용할 닉네임을 설정해주세요',
              style: MindleTextStyles.body1(color: MindleColors.gray1),
            ),
            Spacing.vertical30,
            const SizedBox(height: 16),

            // 닉네임 입력 영역
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: MindleColors.gray6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _nicknameController,
                      decoration: InputDecoration(
                        hintText: '닉네임을 입력하세요',
                        hintStyle: MindleTextStyles.body1(
                          color: MindleColors.gray8,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      style: MindleTextStyles.body1(color: MindleColors.black),
                    ),
                  ),
                ),
                Spacing.horizontal12,
                SizedBox(
                  width: 100,
                  child: TextButton(
                    onPressed: _isNicknameValid ? _checkDuplicate : null,
                    style: TextButton.styleFrom(
                      foregroundColor: _isNicknameValid
                          ? MindleColors.white
                          : MindleColors.gray5,
                      backgroundColor: _isNicknameValid
                          ? MindleColors.mainGreen
                          : MindleColors.gray4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: Text(
                      '중복확인',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  //  MindleTextButton(
                  //   label: '중복확인',
                  //   onPressed: _isNicknameValid ? _checkDuplicate : null,
                  //   textColor: _isNicknameValid
                  //       ? MindleColors.white
                  //       : MindleColors.gray5,
                  //   backgroundColor: _isNicknameValid
                  //       ? MindleColors.mainGreen
                  //       : MindleColors.gray4,
                  //   fontSize: 14,
                  //   fontWeight: FontWeight.w500,
                  //   hasBorder: true,
                  // ),
                ),
              ],
            ),
            Spacing.vertical8,
            Text(
              _isDuplicateChecked ? '사용가능한 닉네임입니다' : '',
              style: MindleTextStyles.body3(color: MindleColors.infoBlue),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: MindleTextButton(
                label: _isLoading ? '저장 중...' : '완료',
                onPressed:
                    (_isNicknameValid && _isDuplicateChecked && !_isLoading)
                    ? _onComplete
                    : null,
                textColor:
                    (_isNicknameValid && _isDuplicateChecked && !_isLoading)
                    ? MindleColors.white
                    : MindleColors.gray5,
                backgroundColor:
                    (_isNicknameValid && _isDuplicateChecked && !_isLoading)
                    ? MindleColors.mainGreen
                    : MindleColors.gray4,
              ),
            ),
            Spacing.vertical20,
            Spacing.vertical20,
          ],
        ),
      ),
    );
  }
}
