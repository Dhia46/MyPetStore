from pydantic import BaseModel

class LoginSchema(BaseModel):
    username: str
    password: str

class RegisterSchema(BaseModel):
    username: str
    cin: str
    password: str

class PetCreate(BaseModel):
    name: str
    type: str
    description: str
    price: int
    image: str

class PetResponse(BaseModel):
    id: int
    name: str
    type: str
    description: str
    price: int
    image: str

    class Config:
        orm_mode = True