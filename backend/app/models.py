from sqlalchemy import Column, Integer, String, Float, DateTime, Text, ForeignKey, JSON, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base


class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    full_name = Column(String)
    role = Column(String, nullable=False)  # vc_representative, startup_aspirant, system_admin
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    vc_usecases = relationship("VCUseCase", back_populates="vc_user")
    ideas = relationship("Idea", back_populates="aspirant_user")


class VCUseCase(Base):
    __tablename__ = "vc_usecases"
    
    id = Column(Integer, primary_key=True, index=True)
    vc_user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    title = Column(String, nullable=False)
    description = Column(Text, nullable=False)
    industry = Column(String)
    domain = Column(String)
    tags = Column(JSON)  # Array of tags
    importance_weight = Column(Float, default=0.5)  # 0-1
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    vc_user = relationship("User", back_populates="vc_usecases")
    evaluations = relationship("Evaluation", back_populates="usecase")


class Idea(Base):
    __tablename__ = "ideas"
    
    id = Column(Integer, primary_key=True, index=True)
    aspirant_user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    title = Column(String, nullable=False)
    short_pitch = Column(Text, nullable=False)
    problem_statement = Column(Text, nullable=False)
    target_industry = Column(String)
    proposed_solution = Column(Text, nullable=False)
    differentiators = Column(Text)
    market_signals = Column(Text)
    extracted_features = Column(JSON)  # Cached NLP features
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    aspirant_user = relationship("User", back_populates="ideas")
    evaluations = relationship("Evaluation", back_populates="idea")


class Evaluation(Base):
    __tablename__ = "evaluations"
    
    id = Column(Integer, primary_key=True, index=True)
    idea_id = Column(Integer, ForeignKey("ideas.id"), nullable=False)
    usecase_id = Column(Integer, ForeignKey("vc_usecases.id"), nullable=False)
    overall_score = Column(Float, nullable=False)  # 0-100
    alignment_score = Column(Float)  # 0-1
    novelty_score = Column(Float)  # 0-1
    viability_score = Column(Float)  # 0-1
    explanation = Column(Text)
    matched_evidence = Column(JSON)  # Text spans and features
    confidence = Column(Float)  # 0-1
    recommended_actions = Column(JSON)  # Array of next steps
    evaluation_metadata = Column(JSON)  # Model version, params, etc.
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    idea = relationship("Idea", back_populates="evaluations")
    usecase = relationship("VCUseCase", back_populates="evaluations")


class AuditLog(Base):
    __tablename__ = "audit_logs"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    action = Column(String, nullable=False)
    resource_type = Column(String)
    resource_id = Column(Integer)
    details = Column(JSON)
    ip_address = Column(String)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
