from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from typing import Annotated
import uvicorn
import json
from pathlib import Path

app = FastAPI()

# Allow cross-origin requests from local file servers or other ports during development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 1. Load your trained model here
# my_model = load_model('path/to/food101_model.h5') 

@app.post("/analyze-food")
async def analyze_food(file: Annotated[UploadFile, File()]):
    """
    Receives an image from the Flutter app and returns nutritional data.
    """
    # 2. Read the image sent from the Flutter app
    image_bytes = await file.read()
    
    # Logic to fix the "Unused variable" warning
    # In a real scenario, you'd pass image_bytes to your model here
    print(f"Processing image: {file.filename} ({len(image_bytes)} bytes)")
    
    # 3. MOCK DATA (Replace this with my_model.predict logic later)
    food_name = "Pepperoni Pizza"
    calories = 290
    protein = 12.0

    # 4. Return the results as a JSON response
    return {
        "food_name": food_name,
        "nutritional_info": {
            "calories": calories,
            "protein_g": protein,
            "carbs_g": 35.0,
            "fat_g": 10.0
        },
        "status": "success"
    }


@app.get("/dishes")
async def list_dishes():
    """
    Returns the dishes JSON so the website can fetch the Food-101-like list.
    """
    # resolve path relative to project root
    base = Path(__file__).resolve().parent.parent
    data_path = base / 'data' / 'dishes.json'
    if not data_path.exists():
        raise HTTPException(status_code=404, detail="dishes.json not found")
    try:
        with data_path.open('r', encoding='utf-8') as f:
            data = json.load(f)
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# Serve static site from project root so you can run a single server with uvicorn
try:
    project_root = Path(__file__).resolve().parent.parent
    from fastapi.staticfiles import StaticFiles
    # mount at root; html=True makes index-like files served
    app.mount("/", StaticFiles(directory=str(project_root), html=True), name="static")
except Exception:
    # if StaticFiles isn't available or mount fails, ignore — static files can still be served separately
    pass

if __name__ == "__main__":
    # Binding to 127.0.0.1 fixes the SonarLint security warning
    uvicorn.run(app, host="127.0.0.1", port=8000)