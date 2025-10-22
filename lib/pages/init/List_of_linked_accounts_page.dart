import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindle/designs.dart';
import 'package:mindle/widgets/mindle_top_appbar.dart';

class LinkedAccountInfo {
  final String providerId;
  final String? email;
  final String? displayName;

  LinkedAccountInfo({required this.providerId, this.email, this.displayName});
}

class ListOfLinkedAccountsPage extends StatelessWidget {
  final String phoneNumber;
  final List<LinkedAccountInfo> existingAccounts;
  final Map<String, dynamic> currentSocialUser;

  const ListOfLinkedAccountsPage({
    Key? key,
    required this.phoneNumber,
    required this.existingAccounts,
    required this.currentSocialUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MindleTopAppBar(title: '연동된 계정 확인'),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.vertical20,

            // 제목
            Text(
              '$phoneNumber\n이 전화번호에 연동된 계정들',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),

            Spacing.vertical30,

            // 기존 연동된 계정들
            Text(
              '현재 연동된 계정들',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Spacing.vertical16,

            // 기존 계정 리스트
            Expanded(
              child: ListView.builder(
                itemCount: existingAccounts.length,
                itemBuilder: (context, index) {
                  final account = existingAccounts[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getProviderColor(
                            account.providerId,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _getProviderIcon(account.providerId),
                          color: _getProviderColor(account.providerId),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        _getProviderName(account.providerId),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        account.email ??
                            account.displayName ??
                            account.providerId,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  );
                },
              ),
            ),

            Spacing.vertical20,

            // 구분선
            Divider(thickness: 1, color: Colors.grey[300]),
            Spacing.vertical20,

            // 새로 추가하려던 계정
            Text(
              '새로 로그인한 계정',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Spacing.vertical16,

            Card(
              color: Colors.amber[50],
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getProviderColor(
                      currentSocialUser['providerId'],
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _getProviderIcon(currentSocialUser['providerId']),
                    color: _getProviderColor(currentSocialUser['providerId']),
                    size: 20,
                  ),
                ),
                title: Row(
                  children: [
                    Text(
                      _getProviderName(currentSocialUser['providerId']),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Spacing.horizontal8,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '새로운',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  currentSocialUser['email'] ??
                      currentSocialUser['displayName'] ??
                      '',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),

            Spacing.vertical30,

            // 안내 메시지
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                      Spacing.horizontal8,
                      Text(
                        '계정 정보 확인',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  Spacing.vertical8,
                  Text(
                    '이 전화번호에는 이미 여러 계정이 연동되어 있습니다.\n어떻게 처리할지 결정해주세요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            Spacing.vertical20,

            // 🔥 단순한 확인 버튼만
            ElevatedButton(
              onPressed: () {
                Get.back(); // 그냥 뒤로 가기
                Get.snackbar(
                  '알림',
                  '계정 정보를 확인했습니다. 필요하면 다시 로그인해주세요.',
                  backgroundColor: Colors.grey[100],
                  colorText: Colors.grey[800],
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                minimumSize: Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '확인했습니다',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),

            Spacing.vertical20,
          ],
        ),
      ),
    );
  }

  // 헬퍼 함수들 (동일)
  String _getProviderName(String providerId) {
    switch (providerId) {
      case 'phone':
        return '전화번호';
      case 'google.com':
        return '구글';
      case 'oidc.kakao':
        return '카카오';
      default:
        return '기타';
    }
  }

  IconData _getProviderIcon(String providerId) {
    switch (providerId) {
      case 'phone':
        return Icons.phone;
      case 'google.com':
        return Icons.account_circle;
      case 'oidc.kakao':
        return Icons.chat_bubble;
      default:
        return Icons.account_box;
    }
  }

  Color _getProviderColor(String providerId) {
    switch (providerId) {
      case 'phone':
        return Colors.blue[600]!;
      case 'google.com':
        return Colors.red[600]!;
      case 'oidc.kakao':
        return Colors.yellow[700]!;
      default:
        return Colors.grey[600]!;
    }
  }
}
