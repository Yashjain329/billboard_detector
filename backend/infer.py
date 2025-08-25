import os
import glob
from ultralytics import YOLO
import cv2

def run_inference():
    # Paths
    ROOT_DIR = "D:/BillBoard-Detection"
    MODEL_PATH = os.path.join(ROOT_DIR, "models", "best.pt")
    DATASET_DIR = os.path.join(ROOT_DIR, "data", "valid", "images")
    OUTPUT_DIR = os.path.join(ROOT_DIR, "runs", "inference")

    os.makedirs(OUTPUT_DIR, exist_ok=True)

    # Load trained model
    model = YOLO(MODEL_PATH)

    # Get list of images
    image_paths = glob.glob(os.path.join(DATASET_DIR, "*.jpg")) + glob.glob(os.path.join(DATASET_DIR, "*.png"))
    print(f"[INFO] Found {len(image_paths)} images for inference.")

    # Run inference
    for img_path in image_paths:
        results = model.predict(source=img_path, conf=0.25, save=False, verbose=False)

        # Annotated frame
        for r in results:
            annotated = r.plot()  # returns a numpy array with annotations

            # Save result
            fname = os.path.basename(img_path)
            save_path = os.path.join(OUTPUT_DIR, fname)
            cv2.imwrite(save_path, annotated)
            print(f"[INFO] Saved: {save_path}")

    print(f"[DONE] Inference results saved in {OUTPUT_DIR}")

if __name__ == "__main__":
    run_inference()
