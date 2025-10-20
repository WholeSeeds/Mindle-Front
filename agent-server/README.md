# Mindle AI Agent 서버

민들레 앱의 실시간 음성 민원 상담 AI Agent

## 🚀 빠른 시작

### 1. Python 환경 설정

```bash
# Python 3.11+ 필요
python --version

# 가상환경 생성
python -m venv venv

# 가상환경 활성화
source venv/bin/activate  # macOS/Linux
# venv\Scripts\activate  # Windows
```

### 2. 의존성 설치

```bash
pip install -r requirements.txt
```

### 3. 환경 변수 설정

```bash
# .env.example을 복사
cp .env.example .env

# .env 파일 편집
nano .env
```

필요한 API 키:
- **LIVEKIT_URL**: LiveKit 서버 URL (이미 설정됨)
- **LIVEKIT_API_KEY**: LiveKit API Key (이미 설정됨)
- **LIVEKIT_API_SECRET**: LiveKit API Secret (이미 설정됨)
- **OPENAI_API_KEY**: OpenAI API Key 필요 ⚠️
- **DEEPGRAM_API_KEY**: Deepgram API Key 필요 ⚠️

### 4. Agent 실행

```bash
# 개발 모드
python agent.py dev

# 프로덕션 모드
python agent.py start
```

## 🔑 API 키 발급

### OpenAI API Key

1. https://platform.openai.com/ 접속
2. "API keys" 메뉴에서 "Create new secret key" 클릭
3. 키 복사 후 `.env`에 추가

### Deepgram API Key

1. https://console.deepgram.com/ 접속 (무료 가입)
2. "API Keys" 메뉴에서 키 생성
3. 무료 크레딧 $200 제공
4. 키 복사 후 `.env`에 추가

## 📋 Agent 기능

### 1. 음성 인식 (STT)
- **Deepgram Nova-2** 사용
- 한국어 음성을 텍스트로 변환
- 실시간 스트리밍 지원

### 2. 대화 처리 (LLM)
- **OpenAI GPT-4** 사용
- 민원 내용 이해 및 분류
- 필요한 정보 수집

### 3. 음성 합성 (TTS)
- **OpenAI TTS** 사용
- 자연스러운 한국어 음성
- 실시간 응답

### 4. 민원 정보 수집
- 민원 내용
- 발생 위치
- 카테고리 (도로, 환경, 시설물, 안전, 기타)
- 긴급도

## 🧪 테스트

### 1. Agent 서버 실행

```bash
python agent.py dev
```

출력 확인:
```
🤖 AI Agent 시작
✅ Room 연결됨: mindle-complaint-room
```

### 2. Flutter 앱에서 테스트

1. Flutter 앱 실행
2. STT 페이지 열기
3. 마이크 버튼 탭
4. 말하기: "길에 구멍이 있어요"
5. AI 응답 확인

### 3. 디버그 로그

Agent 서버 콘솔:
```
👤 참여자 연결: user-123456
🎤 Agent 활성화 - 대화 시작
📝 STT: "길에 구멍이 있어요"
🧠 LLM 처리 중...
💬 AI: "안녕하세요. 불편을 겪으셨군요. 어느 위치에..."
🔊 TTS 재생
```

## 🎯 커스터마이징

### 시스템 프롬프트 수정

`agent.py`의 `initial_ctx` 수정:

```python
initial_ctx = llm.ChatContext().append(
    role="system",
    text="""
    당신의 커스텀 프롬프트...
    """,
)
```

### 음성 변경

```python
# OpenAI TTS 음성 옵션
tts=openai.TTS(
    voice="alloy",  # alloy, echo, fable, onyx, nova, shimmer
    speed=1.0,
)
```

### STT 언어 변경

```python
stt=deepgram.STT(
    language="ko",  # ko, en, ja, zh 등
    model="nova-2",
)
```

## 💰 예상 비용 (월 기준)

**사용량 기준: 월 1000명, 평균 2분 대화**

- LiveKit: 무료 티어 (10,000분/월)
- OpenAI GPT-4: ~$30 (대화 처리)
- OpenAI TTS: ~$15 (음성 합성)
- Deepgram: ~$8 (음성 인식, 2000분)

**총 예상 비용: ~$53/월**

## 🔧 문제 해결

### Agent가 시작되지 않음

```bash
# 의존성 재설치
pip install --upgrade -r requirements.txt

# 환경 변수 확인
python -c "import os; from dotenv import load_dotenv; load_dotenv(); print(os.getenv('OPENAI_API_KEY')[:10])"
```

### Room 연결 실패

- LiveKit URL 확인
- API Key/Secret 확인
- 네트워크 연결 확인

### 음성 인식이 안 됨

- Deepgram API Key 확인
- 마이크 권한 확인 (Flutter 앱)
- 오디오 트랙 발행 확인

## 📚 참고 자료

- [LiveKit Agents 문서](https://docs.livekit.io/agents/)
- [OpenAI API 문서](https://platform.openai.com/docs/)
- [Deepgram API 문서](https://developers.deepgram.com/)

## 🔄 다음 단계

- [ ] OpenAI API Key 발급
- [ ] Deepgram API Key 발급
- [ ] Agent 서버 실행 테스트
- [ ] Flutter 앱과 연동 테스트
- [ ] 시스템 프롬프트 최적화
- [ ] 백엔드 API 연동 (민원 저장)
- [ ] 프로덕션 배포

---

**AI Agent가 실시간으로 민원 상담을 도와줍니다!** 🎉

