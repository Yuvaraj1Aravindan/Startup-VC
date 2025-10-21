from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from datetime import timedelta, datetime
from typing import List

from app.config import settings
from app.database import get_db, engine, Base
from app.models import User, VCUseCase, Idea, Evaluation
from app.schemas import (
    UserCreate, UserResponse, Token,
    VCUseCaseCreate, VCUseCaseResponse, VCUseCaseBulkUpload,
    IdeaCreate, IdeaResponse,
    EvaluationRequest, EvaluationBulkRequest, SingleIdeaEvaluationResponse,
    BulkEvaluationResponse, EvaluationReport, PerUseCaseScore
)
from app.auth import (
    get_password_hash, verify_password, create_access_token,
    get_current_active_user
)
from app.scoring_engine import NLPScoringEngine

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="VC UseCase Scoring API",
    description="API for evaluating startup ideas against VC use cases",
    version=settings.API_VERSION
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize scoring engine
scoring_engine = NLPScoringEngine()


@app.get("/")
async def root():
    return {
        "message": "VC UseCase Scoring API",
        "version": settings.API_VERSION,
        "status": "running"
    }


@app.get("/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.utcnow()}


# Authentication endpoints
@app.post("/api/register", response_model=UserResponse)
async def register(user: UserCreate, db: Session = Depends(get_db)):
    # Check if user exists
    db_user = db.query(User).filter(User.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Create new user
    hashed_password = get_password_hash(user.password)
    db_user = User(
        email=user.email,
        hashed_password=hashed_password,
        full_name=user.full_name,
        role=user.role
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


@app.post("/api/token", response_model=Token)
async def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    user = db.query(User).filter(User.email == form_data.username).first()
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.email}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}


@app.get("/api/users/me", response_model=UserResponse)
async def read_users_me(current_user: User = Depends(get_current_active_user)):
    return current_user


# VC UseCase endpoints
@app.post("/api/vc/usecases", response_model=VCUseCaseResponse)
async def create_usecase(
    usecase: VCUseCaseCreate,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    if current_user.role not in ["vc_representative", "system_admin"]:
        raise HTTPException(status_code=403, detail="Not authorized")
    
    db_usecase = VCUseCase(
        vc_user_id=current_user.id,
        **usecase.dict()
    )
    db.add(db_usecase)
    db.commit()
    db.refresh(db_usecase)
    return db_usecase


@app.post("/api/vc/usecases/bulk", response_model=List[VCUseCaseResponse])
async def create_usecases_bulk(
    data: VCUseCaseBulkUpload,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    if current_user.role not in ["vc_representative", "system_admin"]:
        raise HTTPException(status_code=403, detail="Not authorized")
    
    created_usecases = []
    for usecase in data.usecases:
        db_usecase = VCUseCase(
            vc_user_id=current_user.id,
            **usecase.dict()
        )
        db.add(db_usecase)
        created_usecases.append(db_usecase)
    
    db.commit()
    for uc in created_usecases:
        db.refresh(uc)
    
    return created_usecases


@app.get("/api/vc/usecases", response_model=List[VCUseCaseResponse])
async def get_usecases(
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    if current_user.role == "vc_representative":
        return db.query(VCUseCase).filter(VCUseCase.vc_user_id == current_user.id).all()
    elif current_user.role == "system_admin":
        return db.query(VCUseCase).all()
    else:
        # Startup aspirants can see all usecases
        return db.query(VCUseCase).all()


# Idea endpoints
@app.post("/api/ideas", response_model=IdeaResponse)
async def create_idea(
    idea: IdeaCreate,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    if current_user.role not in ["startup_aspirant", "system_admin"]:
        raise HTTPException(status_code=403, detail="Not authorized")
    
    # Extract features
    features = scoring_engine.extract_features(idea.dict())
    
    db_idea = Idea(
        aspirant_user_id=current_user.id,
        extracted_features=features,
        **idea.dict()
    )
    db.add(db_idea)
    db.commit()
    db.refresh(db_idea)
    return db_idea


@app.get("/api/ideas", response_model=List[IdeaResponse])
async def get_ideas(
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    if current_user.role == "startup_aspirant":
        return db.query(Idea).filter(Idea.aspirant_user_id == current_user.id).all()
    else:
        return db.query(Idea).all()


@app.get("/api/ideas/{idea_id}", response_model=IdeaResponse)
async def get_idea(
    idea_id: int,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    idea = db.query(Idea).filter(Idea.id == idea_id).first()
    if not idea:
        raise HTTPException(status_code=404, detail="Idea not found")
    
    # Check permissions
    if current_user.role == "startup_aspirant" and idea.aspirant_user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized")
    
    return idea


# Evaluation endpoints
@app.post("/api/evaluate", response_model=SingleIdeaEvaluationResponse)
async def evaluate_idea(
    request: EvaluationRequest,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    # Get idea and usecase
    idea = db.query(Idea).filter(Idea.id == request.idea_id).first()
    usecase = db.query(VCUseCase).filter(VCUseCase.id == request.usecase_id).first()
    
    if not idea or not usecase:
        raise HTTPException(status_code=404, detail="Idea or UseCase not found")
    
    # Check permissions
    if current_user.role == "startup_aspirant" and idea.aspirant_user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized")
    
    # Get or extract features
    if not idea.extracted_features:
        features = scoring_engine.extract_features({
            'title': idea.title,
            'short_pitch': idea.short_pitch,
            'problem_statement': idea.problem_statement,
            'proposed_solution': idea.proposed_solution,
            'differentiators': idea.differentiators or '',
            'market_signals': idea.market_signals or ''
        })
        idea.extracted_features = features
        db.commit()
    else:
        features = idea.extracted_features
    
    # Compute scores
    alignment_score, evidence = scoring_engine.compute_alignment_score(
        features,
        {
            'title': usecase.title,
            'description': usecase.description,
            'industry': usecase.industry,
            'tags': usecase.tags
        }
    )
    
    novelty_score = scoring_engine.compute_novelty_score(features)
    viability_score = scoring_engine.compute_viability_score(features)
    
    # Weighted overall score
    overall_score = (
        alignment_score * 0.5 * usecase.importance_weight +
        novelty_score * 0.3 +
        viability_score * 0.2
    ) * 100
    
    scores = {
        'overall': overall_score,
        'alignment': alignment_score,
        'novelty': novelty_score,
        'viability': viability_score
    }
    
    # Generate explanation
    explanation = scoring_engine.generate_explanation(
        idea.__dict__,
        usecase.__dict__,
        scores,
        evidence
    )
    
    # Recommend actions
    actions = scoring_engine.recommend_actions(scores)
    
    # Save evaluation
    db_eval = Evaluation(
        idea_id=idea.id,
        usecase_id=usecase.id,
        overall_score=overall_score,
        alignment_score=alignment_score,
        novelty_score=novelty_score,
        viability_score=viability_score,
        explanation=explanation,
        matched_evidence={'evidence': evidence},
        confidence=0.85,
        recommended_actions=actions,
        evaluation_metadata={'model': settings.NLP_MODEL}
    )
    db.add(db_eval)
    db.commit()
    
    # Return response
    return SingleIdeaEvaluationResponse(
        idea=idea,
        overall_score=overall_score,
        per_usecase_scores=[PerUseCaseScore(
            usecase_id=usecase.id,
            usecase_title=usecase.title,
            score=overall_score,
            alignment_score=alignment_score,
            explanation=explanation,
            matched_evidence=evidence
        )],
        aggregated_explanation=explanation,
        confidence=0.85,
        recommended_actions=actions
    )


@app.post("/api/evaluate/bulk", response_model=BulkEvaluationResponse)
async def evaluate_bulk(
    request: EvaluationBulkRequest,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    results = []
    
    for idea_id in request.idea_ids:
        idea = db.query(Idea).filter(Idea.id == idea_id).first()
        if not idea:
            continue
        
        # Check permissions
        if current_user.role == "startup_aspirant" and idea.aspirant_user_id != current_user.id:
            continue
        
        per_usecase_scores = []
        total_score = 0
        
        for usecase_id in request.usecase_ids:
            usecase = db.query(VCUseCase).filter(VCUseCase.id == usecase_id).first()
            if not usecase:
                continue
            
            # Evaluate
            eval_result = await evaluate_idea(
                EvaluationRequest(idea_id=idea_id, usecase_id=usecase_id),
                current_user,
                db
            )
            
            per_usecase_scores.extend(eval_result.per_usecase_scores)
            total_score += eval_result.overall_score
        
        if per_usecase_scores:
            avg_score = total_score / len(per_usecase_scores)
            results.append(SingleIdeaEvaluationResponse(
                idea=idea,
                overall_score=avg_score,
                per_usecase_scores=per_usecase_scores,
                aggregated_explanation=f"Average score across {len(per_usecase_scores)} use cases",
                confidence=0.85,
                recommended_actions=scoring_engine.recommend_actions({'overall': avg_score, 'alignment': 0.7, 'novelty': 0.6, 'viability': 0.6})
            ))
    
    return BulkEvaluationResponse(
        results=sorted(results, key=lambda x: x.overall_score, reverse=True),
        total_evaluated=len(results),
        timestamp=datetime.utcnow()
    )


@app.get("/api/ideas/{idea_id}/report", response_model=EvaluationReport)
async def get_evaluation_report(
    idea_id: int,
    current_user: User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    idea = db.query(Idea).filter(Idea.id == idea_id).first()
    if not idea:
        raise HTTPException(status_code=404, detail="Idea not found")
    
    # Check permissions
    if current_user.role == "startup_aspirant" and idea.aspirant_user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized")
    
    # Get all evaluations
    evaluations = db.query(Evaluation).filter(Evaluation.idea_id == idea_id).all()
    
    if not evaluations:
        raise HTTPException(status_code=404, detail="No evaluations found for this idea")
    
    # Calculate average score
    avg_score = sum(e.overall_score for e in evaluations) / len(evaluations)
    
    # Get top matches
    top_matches = []
    for eval in sorted(evaluations, key=lambda x: x.overall_score, reverse=True)[:3]:
        usecase = db.query(VCUseCase).filter(VCUseCase.id == eval.usecase_id).first()
        if usecase:
            top_matches.append(PerUseCaseScore(
                usecase_id=usecase.id,
                usecase_title=usecase.title,
                score=eval.overall_score,
                alignment_score=eval.alignment_score,
                explanation=eval.explanation,
                matched_evidence=eval.matched_evidence.get('evidence', [])
            ))
    
    # Generate insights
    insights = f"This idea has been evaluated against {len(evaluations)} VC use cases with an average score of {avg_score:.1f}%."
    
    return EvaluationReport(
        idea=idea,
        evaluations=evaluations,
        average_score=avg_score,
        top_matches=top_matches,
        insights=insights
    )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
