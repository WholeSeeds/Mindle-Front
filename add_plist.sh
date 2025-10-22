#!/bin/bash

# GoogleService-Info.plist 파일 경로
PLIST_FILE="ios/Runner/GoogleService-Info.plist"

# pbxproj 파일 경로
PBXPROJ="ios/Runner.xcodeproj/project.pbxproj"

# 파일이 이미 pbxproj에 있는지 확인
if grep -q "GoogleService-Info.plist" "$PBXPROJ"; then
    echo "✅ GoogleService-Info.plist가 이미 프로젝트에 있습니다."
else
    echo "❌ GoogleService-Info.plist를 Xcode에서 수동으로 추가해야 합니다."
    echo ""
    echo "방법:"
    echo "1. Xcode에서 Runner.xcworkspace를 열기"
    echo "2. 왼쪽 네비게이터에서 Runner 폴더를 오른쪽 클릭"
    echo "3. 'Add Files to Runner...' 선택"
    echo "4. ios/Runner/GoogleService-Info.plist 선택"
    echo "5. 'Add to targets: Runner' 체크 확인"
    echo "6. 'Add' 버튼 클릭"
fi
