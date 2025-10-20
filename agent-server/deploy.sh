#!/bin/bash

# Mindle AI Agent 배포 스크립트
# LiveKit Cloud에 Agent 배포

set -e  # 에러 발생 시 중단

echo "🚀 Mindle AI Agent 배포 시작..."

# 색상 코드
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. LiveKit CLI 설치 확인
echo ""
echo "📋 1단계: LiveKit CLI 확인..."
if ! command -v lk &> /dev/null; then
    echo -e "${RED}❌ LiveKit CLI가 설치되지 않았습니다.${NC}"
    echo "다음 명령어로 설치하세요:"
    echo "  brew install livekit-cli"
    exit 1
fi
echo -e "${GREEN}✅ LiveKit CLI 설치 확인${NC}"

# 2. 프로젝트 디렉토리 확인
echo ""
echo "📋 2단계: 프로젝트 디렉토리 확인..."
if [ ! -f "agent.py" ]; then
    echo -e "${RED}❌ agent.py 파일을 찾을 수 없습니다.${NC}"
    echo "agent-server 디렉토리에서 실행하세요."
    exit 1
fi
echo -e "${GREEN}✅ agent.py 파일 확인${NC}"

# 3. .env 파일 확인
echo ""
echo "📋 3단계: 환경 변수 확인..."
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  .env 파일이 없습니다.${NC}"
    echo ".env.example을 복사하여 .env 파일을 생성하세요:"
    echo "  cp .env.example .env"
    echo "  nano .env  # API 키 입력"
    exit 1
fi

# API 키 확인
if ! grep -q "OPENAI_API_KEY=sk-" .env; then
    echo -e "${YELLOW}⚠️  OpenAI API Key가 설정되지 않았습니다.${NC}"
    echo ".env 파일에서 OPENAI_API_KEY를 설정하세요."
fi

if ! grep -q "DEEPGRAM_API_KEY=" .env && grep -q "DEEPGRAM_API_KEY=your-deepgram-key-here" .env; then
    echo -e "${YELLOW}⚠️  Deepgram API Key가 설정되지 않았습니다.${NC}"
    echo ".env 파일에서 DEEPGRAM_API_KEY를 설정하세요."
fi

echo -e "${GREEN}✅ .env 파일 확인${NC}"

# 4. 인증 확인
echo ""
echo "📋 4단계: LiveKit Cloud 인증 확인..."
if ! lk project list &> /dev/null; then
    echo -e "${YELLOW}⚠️  LiveKit Cloud 인증이 필요합니다.${NC}"
    echo "다음 명령어로 인증하세요:"
    echo "  lk cloud auth"
    read -p "지금 인증하시겠습니까? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        lk cloud auth
    else
        exit 1
    fi
fi
echo -e "${GREEN}✅ LiveKit Cloud 인증 완료${NC}"

# 5. livekit.toml 확인 (이미 생성되었는지)
echo ""
echo "📋 5단계: Agent 설정 확인..."
if [ ! -f "livekit.toml" ]; then
    echo -e "${YELLOW}⚠️  livekit.toml 파일이 없습니다. Agent를 처음 생성합니다.${NC}"
    echo "Agent 이름을 입력하세요 (예: mindle-complaint-bot):"
    read agent_name
    
    # Agent 생성
    echo ""
    echo "🔨 Agent 생성 중..."
    lk agent create
    
    echo -e "${GREEN}✅ Agent 생성 완료${NC}"
else
    echo -e "${GREEN}✅ livekit.toml 파일 확인 (기존 Agent)${NC}"
    
    # 기존 Agent 재배포
    echo ""
    echo "🔨 Agent 재배포 중..."
    lk agent deploy
    
    echo -e "${GREEN}✅ Agent 재배포 완료${NC}"
fi

# 6. Secrets 설정 확인
echo ""
echo "📋 6단계: Secrets 설정..."
echo "API 키를 LiveKit Cloud Secrets으로 설정하시겠습니까?"
echo "  - OPENAI_API_KEY"
echo "  - DEEPGRAM_API_KEY"
read -p "설정하시겠습니까? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "OpenAI API Key를 입력하세요:"
    read -s openai_key
    echo "$openai_key" | lk agent secret set OPENAI_API_KEY
    
    echo ""
    echo "Deepgram API Key를 입력하세요:"
    read -s deepgram_key
    echo "$deepgram_key" | lk agent secret set DEEPGRAM_API_KEY
    
    echo -e "${GREEN}✅ Secrets 설정 완료${NC}"
fi

# 7. 배포 완료 및 상태 확인
echo ""
echo "📋 7단계: Agent 상태 확인..."
lk agent status

echo ""
echo "📋 실시간 로그 확인..."
echo "로그를 보려면 다음 명령어를 실행하세요:"
echo "  lk agent logs --follow"

echo ""
echo -e "${GREEN}✨ 배포 완료! ✨${NC}"
echo ""
echo "다음 단계:"
echo "  1. Agent Playground에서 테스트: https://cloud.livekit.io/"
echo "  2. Flutter 앱에서 테스트"
echo "  3. 로그 모니터링: lk agent logs --follow"
echo ""

