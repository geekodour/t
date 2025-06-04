import signal
import sys
from typing import Any, Dict

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
import time
import uvicorn

from pasoli.config import Environment, settings
from pasoli.telemetry.log import get_logger, init_logger

init_logger()
logger = get_logger(__name__)

app = FastAPI(
    title="Pasoli API",
    description="Pasoli Backend API",
    version="0.1.0",
)


@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time
    logger.info(
        path=request.url.path,
        method=request.method,
        status_code=response.status_code,
        processing_time_ms=round(process_time * 1000, 2),
    )
    return response


@app.middleware("http")
async def add_security_headers(request: Request, call_next):
    response = await call_next(request)
    if settings.app_env == Environment.PRODUCTION:
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["X-Frame-Options"] = "DENY"
        response.headers["X-XSS-Protection"] = "1; mode=block"
        response.headers["Strict-Transport-Security"] = (
            "max-age=31536000; includeSubDomains"
        )
    return response


@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled exception: {str(exc)}", exc_info=exc)
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error"}
        if settings.app_env == "production"
        else {"detail": str(exc)},
    )


@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "environment": settings.app_env,
    }


@app.get("/")
async def root() -> Dict[str, str]:
    return {"message": "Welcome to Pasoli API"}


def handle_shutdown(signum: int, frame: Any) -> None:
    logger.info("Received SIGTERM. Shutting down gracefully...")
    sys.exit(0)


def start() -> None:
    signal.signal(signal.SIGTERM, handle_shutdown)
    signal.signal(signal.SIGINT, handle_shutdown)
    uvicorn.run(
        "pasoli.main:app",
        host="0.0.0.0",
        port=8000,
        reload=settings.reload,
        access_log=False,
        log_level=settings.log_level.lower(),
    )


if __name__ == "__main__":
    start()
