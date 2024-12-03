from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base

DATABASE_URL = 'sqlite:///employee_mgmt.db'  # Using SQLite for simplicity

engine = create_engine(DATABASE_URL, echo=True)
Session = sessionmaker(bind=engine)

def init_db():
    Base.metadata.create_all(engine)
