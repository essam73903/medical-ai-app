from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Medical AI Diagnostic API", version="1.0")

class SymptomRequest(BaseModel):
    patient_name: str
    age: int
    symptoms: str

@app.post("/diagnose")
async def diagnose_symptom(data: SymptomRequest):
    symptom_lower = data.symptoms.lower()
    if "fever" in symptom_lower or "حمى" in symptom_lower or "حرارة" in symptom_lower:
        diagnosis = "احتمال الإصابة بعكة أو عدوى فيروسية. يُنصح بالراحة وشرب السوائل ومراجعة الطبيب."
        urgency = "متوسطة"
    elif "chest" in symptom_lower or "صدر" in symptom_lower or "قلب" in symptom_lower:
        diagnosis = "تحذير: أعراض تتعلق بمنطقة الصدر تتطلب فحصاً طبياً فورياً لاستبعاد أي طارئ قلبي."
        urgency = "عالية جداً - طارئ"
    else:
        diagnosis = "الأعراض عامة. يفضل مراقبة الحالة واستشارة طبيب مختص للتأكد."
        urgency = "منخفضة"

    return {
        "status": "success",
        "patient": data.patient_name,
        "age": data.age,
        "initial_diagnosis": diagnosis,
        "urgency_level": urgency
    }

@app.get("/")
def home():
    return {"message": "Medical AI Backend is running successfully!"}
