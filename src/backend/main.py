from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from ingestion.router import router as ingestion_router
from replay.router import router as replay_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup - schema is owned by Alembic (alembic/), not created here.
    # Run `alembic upgrade head` before starting the app against a fresh database.
    print("Starting Incident Replay System")
    yield
    # Shutdown
    print("Shutting down Incident Replay System")


app = FastAPI(
    title="Incident Replay System",
    description="Event store and timeline reconstruction for incident analysis",
    version="0.1.0",
    lifespan=lifespan
)

# CORS for React frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Restrict this in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def health():
    return {"status": "ok"}


app.include_router(ingestion_router)
app.include_router(replay_router)


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
