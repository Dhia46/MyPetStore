from fastapi import FastAPI, Depends, HTTPException, Header
from sqlalchemy.orm import Session
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from typing import Optional
import uuid
import models, schemas
from database import SessionLocal, engine

models.Base.metadata.create_all(bind=engine)

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_headers=["*"],
    allow_methods=["*"]
)


app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_headers=["*"], allow_methods=["*"])
app.mount("/images", StaticFiles(directory="images"), name="images")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_user(session_id: Optional[str] = Header(None, alias="session-id"), db: Session = Depends(get_db)):
    if not session_id:
        raise HTTPException(401, "Non authentifié")
    s = db.query(models.Session).filter(models.Session.session_id == session_id).first()
    if not s:
        raise HTTPException(401, "Session invalide")
    return s.user_id

@app.post("/register")
def register(user: schemas.RegisterSchema, db: Session = Depends(get_db)):
    print(f"📝 Inscription: {user.username}")
    
    # Vérifier si username existe
    existing = db.query(models.User).filter(models.User.username == user.username).first()
    if existing:
        print(f"❌ Username {user.username} existe déjà")
        raise HTTPException(400, "Username déjà utilisé")
    
    # Vérifier si CIN existe
    existing_cin = db.query(models.User).filter(models.User.cin == user.cin).first()
    if existing_cin:
        print(f"❌ CIN {user.cin} existe déjà")
        raise HTTPException(400, "CIN déjà utilisé")
    
    # Créer nouvel utilisateur
    new_user = models.User(username=user.username, cin=user.cin, password=user.password)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    print(f"✅ Utilisateur {user.username} créé avec ID {new_user.id}")
    
    # Créer session
    sid = str(uuid.uuid4())
    db.add(models.Session(user_id=new_user.id, session_id=sid))
    db.commit()
    print(f"✅ Session créée: {sid}")
    
    return {"session_id": sid, "message": "Inscription réussie"}

@app.post("/login")
def login(user: schemas.LoginSchema, db: Session = Depends(get_db)):
    u = db.query(models.User).filter(models.User.username == user.username, models.User.password == user.password).first()
    if not u:
        raise HTTPException(401, "Login incorrect")
    sid = str(uuid.uuid4())
    db.add(models.Session(user_id=u.id, session_id=sid))
    db.commit()
    return {"session_id": sid}

@app.get("/pets", response_model=list[schemas.PetResponse])
def get_pets(db: Session = Depends(get_db)):
    return db.query(models.Pet).all()

@app.get("/pets/{pet_id}", response_model=schemas.PetResponse)
def pet_detail(pet_id: int, db: Session = Depends(get_db)):
    pet = db.query(models.Pet).filter(models.Pet.id == pet_id).first()
    if not pet:
        raise HTTPException(404, "Non trouvé")
    return pet

@app.post("/pets")
def add_pet(pet: schemas.PetCreate, uid: int = Depends(get_user), db: Session = Depends(get_db)):
    new_pet = models.Pet(**pet.dict(), owner_id=uid)
    db.add(new_pet)
    db.commit()
    db.refresh(new_pet)
    return {"message": "Ajouté", "id": new_pet.id}

@app.delete("/pets/{pet_id}")
def buy_pet(pet_id: int, uid: int = Depends(get_user), db: Session = Depends(get_db)):
    pet = db.query(models.Pet).filter(models.Pet.id == pet_id).first()
    if not pet:
        raise HTTPException(404, "Non trouvé")
    db.delete(pet)
    db.commit()
    return {"message": "Supprimé"}