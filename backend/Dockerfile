# ========= Base image =========
FROM python:3.11-slim AS base

WORKDIR /app

# Install system dependencies for OpenCV & ONNX Runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 libgl1 libopencv-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy code and models
COPY api.py /app/api.py
COPY infer.py /app/infer.py
COPY models/ /app/models/

# Expose FastAPI port
EXPOSE 8000

# Run FastAPI with uvicorn
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]