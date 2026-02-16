from database import SessionLocal
from models import User

db = SessionLocal()

print("🔍 Test de connexion à la base de données...")

try:
    # Compte le nombre d'utilisateurs
    count = db.query(User).count()
    print(f"✅ Connexion réussie ! Nombre d'utilisateurs: {count}")
    
    # Liste tous les utilisateurs
    users = db.query(User).all()
    print("\n📋 Liste des utilisateurs:")
    for user in users:
        print(f"  - ID: {user.id}, Username: {user.username}, Password: {user.password}, CIN: {user.cin}")
    
    # Teste avec admin
    print("\n🔍 Recherche de l'utilisateur 'admin'...")
    admin = db.query(User).filter(User.username == "admin").first()
    if admin:
        print(f"✅ Utilisateur 'admin' trouvé!")
        print(f"   ID: {admin.id}")
        print(f"   Username: {admin.username}")
        print(f"   Password: {admin.password}")
        print(f"   CIN: {admin.cin}")
        
        # Teste la connexion avec le mot de passe
        test_user = db.query(User).filter(
            User.username == "admin",
            User.password == "admin123"
        ).first()
        
        if test_user:
            print(f"\n✅✅✅ LOGIN TEST REUSSI avec admin/admin123 !")
        else:
            print(f"\n❌❌❌ LOGIN TEST ECHOUE ! Le mot de passe 'admin123' ne correspond pas !")
            print(f"   Mot de passe dans la DB: '{admin.password}'")
    else:
        print("\n❌ Utilisateur 'admin' NOT FOUND dans la base !")
        
except Exception as e:
    print(f"❌ Erreur: {e}")
    import traceback
    traceback.print_exc()
finally:
    db.close()