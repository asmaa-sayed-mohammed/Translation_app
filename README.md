# 🌍 Flutter Translation App

A Flutter translation app that supports multiple languages. It checks a local Hive database for cached translations before calling the API, ensuring faster lookups and offline access. The app validates that the two selected languages are different and that the user enters a word before translating.

---

## 🚀 Features

* 🔤 Translate words between multiple languages
* ⚡ Smart caching using **Hive** for offline access
* 🌐 Uses an **API** for accurate translations
* 🧩 Validates input (languages must differ, and input word is required)
* 💾 Reduces API calls by storing translations locally

---

## 🛠️ Tech Stack

* **Flutter** (Frontend & UI)
* **Dart**
* **Hive** (Local database)
* **Dio** (API integration)

---

## 📲 How It Works

1. User selects **source** and **target** languages.
2. Enters a word to translate.
3. The app first checks if the translation exists in **Hive**.

    * ✅ If found → returns from cache.
    * 🔄 If not → calls the **translation API**, shows the result, and saves it locally for future use.

---

## 🧑‍💻 Setup Instructions

1. Clone this repository:

   ```bash
   git clone https://github.com/your-username/your-repo-name.git
   ```
2. Navigate to the project folder:

   ```bash
   cd your-repo-name
   ```
3. Install dependencies:

   ```bash
   flutter pub get
   ```
4. Run the app:

   ```bash
   flutter run
   ```
---

🎥 **Demo Video**

<iframe src="https://drive.google.com/file/d/1n8gkjW_ktEg3oFTeebP-yVmYTFs__Y8q/preview" width="640" height="360" allow="autoplay"></iframe>

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to improve.

---
