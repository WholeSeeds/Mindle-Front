import asyncio
import logging
import json
import re
from dotenv import load_dotenv

from livekit.agents import (
    Agent,
    AgentSession,
    JobContext,
    RoomInputOptions,
    WorkerOptions,
    cli,
    function_tool,
)
from livekit.plugins import openai

logger = logging.getLogger("mindle-agent")
load_dotenv(".env")


class MindleAssistant(Agent):
    """민원 접수를 도와주는 AI 상담원"""
    
    def __init__(self, ctx: JobContext) -> None:
        self.ctx = ctx
        self.complaint_data = {
            "title": "",
            "content": "",
            "category": "",
        }
        
        super().__init__(
            instructions="""당신은 민원 접수를 도와주는 친절한 AI 상담원입니다.

주요 역할:
1. 사용자의 민원 내용을 경청하고 정확히 이해합니다
2. 필요한 정보(제목, 내용, 카테고리)를 자연스럽게 수집합니다
3. 간결하고 명확한 한국어로 응답합니다
4. 공감하고 친절한 태도를 유지합니다

응답 스타일:
- 짧고 자연스러운 대화체 사용 (2-3문장 이내)
- 이모지나 특수문자 사용 안 함
- 한 번에 한 가지만 질문
- 사용자의 말을 끊지 않고 경청

민원 유형 (category):
- 도로: 도로/보도 파손, 포장 문제
- 치안: 가로등/신호등 고장, 불법주차, 안전 문제
- 환경: 쓰레기/청소, 소음/진동, 악취
- 기타: 기타 생활 불편사항

대화 흐름:
1. 인사 및 민원 유형 파악
2. 간단한 제목 수집 (예: "홍대입구역 앞 도로 파손" 같은 짧은 요약)
3. 상세 내용 수집 (구체적인 설명)
4. 정보 확인 및 민원 데이터 전송 (save_complaint 함수 사용)

중요 사항:
- 위치 정보는 자동으로 수집되므로 사용자에게 위치를 물어보지 마세요
- 사용자가 자연스럽게 위치를 언급하면 제목이나 내용에 포함하면 됩니다
- 충분한 정보를 수집했다면 반드시 save_complaint 함수를 호출하여 민원 정보를 저장하세요

첫 인사: "안녕하세요! 민원 접수를 도와드리겠습니다. 어떤 불편사항이 있으신가요?"
""",
        )
    
    @function_tool
    async def save_complaint(
        self,
        title: str,
        content: str,
        category: str,
    ):
        """
        수집한 민원 정보를 저장하고 클라이언트에 전송합니다.
        
        Args:
            title: 민원 제목 (간단한 요약)
            content: 민원 상세 내용
            category: 민원 카테고리 (도로/치안/환경/기타 중 하나)
        """
        logger.info(f"💾 민원 정보 저장: title={title}, category={category}")
        
        # 카테고리 검증 및 매핑
        category_map = {
            "도로": "도로",
            "보도": "도로",
            "치안": "치안",
            "가로등": "치안",
            "신호등": "치안",
            "환경": "환경",
            "쓰레기": "환경",
            "소음": "환경",
            "기타": "기타",
        }
        
        mapped_category = category_map.get(category, "기타")
        
        self.complaint_data = {
            "title": title,
            "content": content,
            "category": mapped_category,
        }
        
        # 클라이언트에 JSON 데이터 전송
        try:
            data_json = json.dumps(self.complaint_data, ensure_ascii=False)
            await self.ctx.room.local_participant.publish_data(
                data_json.encode('utf-8'),
                reliable=True,
            )
            logger.info(f"✅ 민원 데이터 전송 완료: {data_json}")
            
            return f"민원 정보가 저장되었습니다. 제목: {title}, 카테고리: {mapped_category}"
        except Exception as e:
            logger.error(f"❌ 데이터 전송 실패: {e}")
            return f"민원 정보 저장 중 오류가 발생했습니다: {str(e)}"


async def entrypoint(ctx: JobContext):
    """Agent 진입점"""
    
    logger.info("🤖 Mindle AI Agent 시작")
    
    # Room 연결
    await ctx.connect()
    logger.info("✅ Room 연결 완료")
    
    # MindleAssistant 인스턴스 생성 (ctx 전달)
    assistant = MindleAssistant(ctx)
    
    # OpenAI Realtime API를 사용한 세션 설정
    session = AgentSession(
        llm=openai.realtime.RealtimeModel(
            voice="alloy",
            temperature=0.5,  # 응답 안정성 향상 (0.7 → 0.5)
            modalities=["audio", "text"],
            # Turn detection 설정 (사용자 발화 감지)
            turn_detection={
                "type": "server_vad",  # Server-side Voice Activity Detection
                "threshold": 0.5,      # 음성 감지 임계값 (기본값)
                "prefix_padding_ms": 300,   # 발화 시작 전 버퍼 (300ms)
                "silence_duration_ms": 500,  # 침묵 지속 시간 (500ms → 끊김 방지)
            },
        )
    )
    
    logger.info("🎤 AgentSession 생성 완료")
    
    # 세션 시간 제한 (3분)
    session_timeout = asyncio.create_task(asyncio.sleep(180))
    
    # 세션 시작 태스크
    async def start_session():
        try:
            await session.start(
                agent=assistant,
                room=ctx.room,
                room_input_options=RoomInputOptions(),
            )
            
            # 세션 시작 후 AI가 먼저 인사
            logger.info("👋 AI가 먼저 인사합니다")
            await session.say(
                "안녕하세요! 민원 접수를 도와드리겠습니다. "
                "도로 파손, 가로등 고장, 쓰레기 처리 등 어떤 불편사항이 있으신가요?",
                allow_interruptions=True,
            )
        except Exception as e:
            logger.error(f"❌ 세션 에러: {e}")
    
    session_task = asyncio.create_task(start_session())
    
    # 세션 또는 타임아웃 중 먼저 완료되는 것을 대기
    done, pending = await asyncio.wait(
        [session_task, session_timeout],
        return_when=asyncio.FIRST_COMPLETED
    )
    
    # 타임아웃이 먼저 완료되었는지 확인
    if session_timeout in done:
        logger.warning("⏱️ 세션 시간 초과 (3분) - 종료합니다")
        # 진행 중인 세션 취소
        for task in pending:
            task.cancel()
        await ctx.room.disconnect()
    else:
        # 세션이 정상 종료됨
        logger.info("✅ 세션이 정상적으로 종료되었습니다")
        session_timeout.cancel()
    
    logger.info("👋 Agent 종료")


if __name__ == "__main__":
    cli.run_app(WorkerOptions(entrypoint_fnc=entrypoint))
