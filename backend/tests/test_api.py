import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.main import app
from app.database import Base, get_db
from app.models import User
from app.auth import get_password_hash

# Test database
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base.metadata.create_all(bind=engine)


def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()


app.dependency_overrides[get_db] = override_get_db
client = TestClient(app)


@pytest.fixture
def test_user():
    db = TestingSessionLocal()
    user = User(
        email="test@example.com",
        hashed_password=get_password_hash("testpass"),
        full_name="Test User",
        role="startup_aspirant",
        is_active=True
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    
    # Get token
    response = client.post(
        "/api/token",
        data={"username": "test@example.com", "password": "testpass"}
    )
    token = response.json()["access_token"]
    
    yield {"user": user, "token": token}
    
    db.delete(user)
    db.commit()
    db.close()


def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()


def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_register_user():
    response = client.post(
        "/api/register",
        json={
            "email": "newuser@example.com",
            "password": "password123",
            "full_name": "New User",
            "role": "startup_aspirant"
        }
    )
    assert response.status_code == 200
    assert response.json()["email"] == "newuser@example.com"


def test_login(test_user):
    response = client.post(
        "/api/token",
        data={"username": "test@example.com", "password": "testpass"}
    )
    assert response.status_code == 200
    assert "access_token" in response.json()


def test_get_current_user(test_user):
    token = test_user["token"]
    response = client.get(
        "/api/users/me",
        headers={"Authorization": f"Bearer {token}"}
    )
    assert response.status_code == 200
    assert response.json()["email"] == "test@example.com"


def test_create_idea(test_user):
    token = test_user["token"]
    response = client.post(
        "/api/ideas",
        headers={"Authorization": f"Bearer {token}"},
        json={
            "title": "Test Idea",
            "short_pitch": "A test pitch",
            "problem_statement": "Test problem",
            "target_industry": "tech",
            "proposed_solution": "Test solution"
        }
    )
    assert response.status_code == 200
    assert response.json()["title"] == "Test Idea"


def test_unauthorized_access():
    response = client.get("/api/ideas")
    assert response.status_code == 401
