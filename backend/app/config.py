from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    # Database
    DATABASE_URL: str = "postgresql://vc_user:vc_password@localhost:5432/vc_scoring_db"
    
    # Redis
    REDIS_URL: str = "redis://localhost:6379/0"
    
    # JWT
    SECRET_KEY: str = "your-secret-key-change-this-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # NLP
    NLP_MODEL: str = "sentence-transformers/all-MiniLM-L6-v2"
    USE_LOCAL_MODEL: bool = True
    OPENROUTER_API_KEY: str = ""
    GROQ_API_KEY: str = ""
    
    # App
    DEBUG: bool = True
    API_VERSION: str = "v1"
    CORS_ORIGINS: List[str] = ["http://localhost:5173", "http://localhost:3000"]
    
    class Config:
        env_file = ".env"


settings = Settings()
