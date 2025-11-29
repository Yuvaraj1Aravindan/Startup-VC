from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List, Dict, Any
from datetime import datetime


# User Schemas
class UserBase(BaseModel):
    email: EmailStr
    full_name: Optional[str] = None
    role: str = Field(..., pattern="^(vc_representative|startup_aspirant|system_admin)$")


class UserCreate(UserBase):
    password: str


class UserResponse(UserBase):
    id: int
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    email: Optional[str] = None


# VC UseCase Schemas
class VCUseCaseBase(BaseModel):
    title: str
    description: str
    industry: Optional[str] = None
    domain: Optional[str] = None
    tags: Optional[List[str]] = []
    importance_weight: float = Field(default=0.5, ge=0, le=1)


class VCUseCaseCreate(VCUseCaseBase):
    pass


class VCUseCaseResponse(VCUseCaseBase):
    id: int
    vc_user_id: int
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    class Config:
        from_attributes = True


class VCUseCaseBulkUpload(BaseModel):
    usecases: List[VCUseCaseCreate]


# Idea Schemas
class IdeaBase(BaseModel):
    title: str
    short_pitch: str
    problem_statement: str
    target_industry: Optional[str] = None
    proposed_solution: str
    differentiators: Optional[str] = None
    market_signals: Optional[str] = None


class IdeaCreate(IdeaBase):
    pass


class IdeaResponse(IdeaBase):
    id: int
    aspirant_user_id: int
    extracted_features: Optional[Dict[str, Any]] = None
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    class Config:
        from_attributes = True


# Evaluation Schemas
class EvaluationRequest(BaseModel):
    idea_id: int
    usecase_id: int


class EvaluationBulkRequest(BaseModel):
    idea_ids: List[int]
    usecase_ids: List[int]


class PerUseCaseScore(BaseModel):
    usecase_id: int
    usecase_title: str
    score: float
    alignment_score: float
    explanation: str
    matched_evidence: List[str]


class EvaluationResponse(BaseModel):
    id: int
    idea_id: int
    usecase_id: int
    overall_score: float
    alignment_score: float
    novelty_score: float
    viability_score: float
    explanation: str
    matched_evidence: Dict[str, Any]
    confidence: float
    recommended_actions: List[str]
    created_at: datetime
    
    class Config:
        from_attributes = True


class SingleIdeaEvaluationResponse(BaseModel):
    idea: IdeaResponse
    overall_score: float
    per_usecase_scores: List[PerUseCaseScore]
    aggregated_explanation: str
    confidence: float
    recommended_actions: List[str]


class BulkEvaluationResponse(BaseModel):
    results: List[SingleIdeaEvaluationResponse]
    total_evaluated: int
    timestamp: datetime


# Evaluation Report
class EvaluationReport(BaseModel):
    idea: IdeaResponse
    evaluations: List[EvaluationResponse]
    average_score: float
    top_matches: List[PerUseCaseScore]
    insights: str
