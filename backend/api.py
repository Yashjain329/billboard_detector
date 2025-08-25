from fastapi import FastAPI, UploadFile, File, HTTPException
import numpy as np
import cv2
import onnxruntime as ort

app = FastAPI()

# Load ONNX model once at startup
session = ort.InferenceSession("models/best.onnx", providers=["CPUExecutionProvider"])

@app.get("/")
async def root():
    return {"message": "Billboard Detection API is running"}

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    try:
        # Read image contents as bytes asynchronously
        contents = await file.read()
        nparr = np.frombuffer(contents, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        if img is None:
            raise HTTPException(status_code=400, detail="Invalid image data")

        # Preprocess image: resize to 640x640, transpose, normalize
        img_resized = cv2.resize(img, (640, 640))
        img_input = img_resized.transpose(2, 0, 1).astype(np.float32) / 255.0
        img_input = np.expand_dims(img_input, axis=0)

        # Run inference
        # Confirm input name matches model input
        input_name = session.get_inputs()[0].name
        outputs = session.run(None, {input_name: img_input})

        # Convert outputs (assumed to be numpy array) to list for JSON serialization
        result = outputs.tolist()

        return {"detections": result}

    except Exception as e:
        # Log error if you have a logger, here just raise 500 with detail
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")
