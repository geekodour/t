import os
from typing import Literal
from pydantic_settings import BaseSettings
from enum import StrEnum

class Environment(StrEnum):
    PRODUCTION = "production"
    DEVELOPMENT = "development"

class Settings(BaseSettings):
    app_env: str = os.getenv("APP_ENV", Environment.DEVELOPMENT)
    debug: bool = app_env == Environment.DEVELOPMENT
    reload: bool = app_env == Environment.DEVELOPMENT
    log_level: str = "DEBUG" if app_env == Environment.DEVELOPMENT else "INFO"

    # API settings
    # api_prefix: str = "/api/v1"

    # Database settings (add as needed)
    # database_url: str = os.getenv("DATABASE_URL", "")


settings = Settings()
