---

# 📱 Comic Spoiler Detection Mobile App

## 📌 Overview

**Comic Spoiler Detection Mobile App** is a Flutter-based mobile application that allows users to upload comic panel images and detect whether the panel contains spoilers.
The app connects to a backend machine learning API that uses **NLP and Computer Vision** models to analyze text and characters in comic panels.

This mobile app is the frontend interface for the ComicSpoilerDetection ML backend project.

---

# 🧠 How It Works

1. User uploads/selects a comic panel image from the mobile app.
2. The app sends the image to the backend API.
3. Backend processes the image:

   * Detects characters using **YOLOv8**
   * Extracts text-related features
   * Uses **TF-IDF + XGBoost** to classify spoiler or non-spoiler
4. Backend returns prediction.
5. App displays result to the user.

---

# 🏗️ Project Structure

```
comic_spoiler_mobile_frontend/
│
├── android/
├── ios/
├── lib/              # Flutter source code
├── linux/
├── macos/
├── web/
├── test/
│
├── pubspec.yaml
├── README.md
└── .gitignore
```

### Backend Folder (Inside Repo)

```
comic_spoiler_mobile_backend/
│
├── models/
│   ├── genre_encoder.pkl
│   ├── tfidf_vectorizer.pkl
│   ├── xgboost_spoiler_classifier.pkl
│   └── yolo8_comic_characters_detector.pt
│
├── app.py
├── m_spoiler_detector.py
├── requirements.txt
```

---

# 🛠️ Tech Stack

## Mobile App

* Flutter
* Dart
* Android Studio / VS Code

## Backend

* Python
* Flask / FastAPI
* YOLOv8 (Ultralytics)
* OpenCV
* Scikit-learn
* XGBoost
* Pandas / NumPy

## Machine Learning

* TF-IDF Vectorization
* XGBoost Classification
* YOLOv8 Object Detection

---

# 🚀 How to Run the Project

## 1️⃣ Run Backend Server

Navigate to backend folder:

```
cd comic_spoiler_mobile_backend
```

Install dependencies:

```
pip install -r requirements.txt
```

Run backend server:

```
python app.py
```

Server will start at:

```
http://127.0.0.1:5000
```

---

## 2️⃣ Run Flutter App

Navigate to frontend folder:

```
cd comic_spoiler_mobile_frontend
```

Get dependencies:

```
flutter pub get
```

Run app:

```
flutter run
```

---

# 📱 App Features

* Upload comic panel image
* Send image to ML backend
* Detect comic characters
* Spoiler / Non-spoiler prediction
* Display prediction result
* Cross-platform (Android, iOS, Web)

---

# 🔄 System Architecture

```
Mobile App (Flutter)
        ↓
   Backend API
        ↓
 ┌─────────────────────┐
 │ YOLOv8 Character     │
 │ Detection            │
 └─────────────────────┘
        ↓
 ┌─────────────────────┐
 │ TF-IDF + XGBoost     │
 │ Spoiler Classification│
 └─────────────────────┘
        ↓
     Prediction
        ↓
   Mobile App Result
```

---

# 📂 Models Used

| Model              | Purpose                 |
| ------------------ | ----------------------- |
| YOLOv8             | Character detection     |
| TF-IDF Vectorizer  | Text feature extraction |
| Genre Encoder      | Encoding comic genre    |
| XGBoost Classifier | Spoiler classification  |

---

# 📌 Future Improvements

* Deploy backend to cloud
* Add user login
* Store scan history
* Real-time camera detection
* Improve model accuracy
* UI improvements
* Add more comic datasets

---

# 👨‍💻 Author

Your Name

---

# ⭐ Related Project

Backend ML Project:
**ComicSpoilerDetection (NLP + Computer Vision Project)**

---


