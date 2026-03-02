from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
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


# helper loader to avoid repeating logic

def _load_json(name: str):
    base = Path(__file__).resolve().parent.parent
    data_path = base / 'data' / name
    if not data_path.exists():
        raise HTTPException(status_code=404, detail=f"{name} not found")
    try:
        with data_path.open('r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/dishes")
async def list_dishes():
    """
    Returns the dishes JSON so the website can fetch the Food-101-like list.
    """
    data = _load_json('dishes.json')
    return JSONResponse(content=data, media_type="application/json")


# simple in-memory caching for repeated queries
_cached_dishes = None
_cached_ingredients = None

@app.get("/ingredients")
async def list_ingredients():
    """Return list of all known ingredients with nutrition and conversion data."""
    global _cached_ingredients
    if _cached_ingredients is None:
        _cached_ingredients = _load_json('ingredients.json')
    return JSONResponse(content=_cached_ingredients, media_type="application/json")

@app.get("/ingredient/{name}")
async def get_ingredient(name: str):
    """Lookup an ingredient by name (case-insensitive) and include dishes that use it."""
    ing_list = await list_ingredients()
    # simple case-insensitive match
    match = next((i for i in ing_list if i['name'].lower() == name.lower()), None)
    if not match:
        match = next((i for i in ing_list if name.lower() in i['name'].lower()), None)
    if not match:
        raise HTTPException(status_code=404, detail="ingredient not found")
    # add recipes using it
    global _cached_dishes
    if _cached_dishes is None:
        _cached_dishes = await list_dishes()
    uses = []
    needle = match['name'].lower()
    for dish in _cached_dishes:
        if any(needle in ing.lower() for ing in dish.get('ingredients', [])):
            uses.append(dish['name'])
    result = dict(match)
    result['used_in_dishes'] = uses
    return result

@app.get("/recipes")
async def recipes_have(have: str):
    """Given a comma-separated list of ingredients the user has, return dishes that can be made.
    The check is naive: every non-quantity word in the recipe must appear as a substring of one of the provided items.
    """
    inventory = [x.strip().lower() for x in have.split(',') if x.strip()]
    if not inventory:
        raise HTTPException(status_code=400, detail="provide at least one ingredient in 'have' query")
    global _cached_dishes
    if _cached_dishes is None:
        _cached_dishes = await list_dishes()
    def dish_ok(dish):
        for ing in dish.get('ingredients', []):
            base = ''.join(ch for ch in ing if not ch.isdigit()).strip()
            matched = any(inv in base.lower() for inv in inventory)
            if not matched:
                return False
        return True
    matches = [d['name'] for d in _cached_dishes if dish_ok(d)]
    return {"available": inventory, "possible_recipes": matches}


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