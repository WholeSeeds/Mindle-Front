# Mindle AI Agent Dockerfile
# LiveKit Cloud 배포용

FROM python:3.11-slim

# 작업 디렉토리 설정
WORKDIR /app

# 시스템 의존성 설치
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Python 의존성 복사 및 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Agent 코드 복사
COPY agent.py .

# 포트 설정 (선택사항)
EXPOSE 8080

# Health check (선택사항)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "print('healthy')" || exit 1

# Agent 실행
CMD ["python", "agent.py", "start"]

