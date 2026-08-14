# Gamified Syllabus Tracker 🎓🎮

**Cross Platform Mobile Application Development — Project Proposal**  
**GLS University | Faculty of Computer Applications & Information Technology | BCA(Reg) Semester V**

- **Project Title:** Gamified Syllabus Tracker
- **Team Members:**
  1. Kagdi Rehan Shoab (Enroll: `202400319010029`, Div A Roll 29)
  2. Vaja Mital Mansukhbhai (Enroll: `202400319010104`, Div B Roll 34)
  3. Shaikh Yusrabanu Abdulhabib (Enroll: `202400319010124`, Div B Roll 54)
- **Frontend Technologies:** Flutter Framework (Dart)
- **State Management:** Provider
- **Backend Technologies:** Node.js & Express REST API / Dart
- **Database Technologies:** MySQL

---

## 🌟 Key Features

1. **User & Authentication Module**
   - Student & Admin Role Support
   - Sign Up, Login, Password Reset, Profile Management
   - Role-based dashboard navigation

2. **Syllabus Management Module (3-Tier Hierarchy)**
   - Subject ➔ Chapter / Unit ➔ Study Topic breakdown
   - Real-time progress calculation per subject & overall
   - Priority tagging (`HIGH`, `MEDIUM`, `LOW`), target dates, status toggling

3. **Gamified Study Planner**
   - 7-Day interactive calendar strip & study scheduler
   - **Smart Suggestions Engine**: Automatically prioritizes overdue topics, approaching deadlines, and high-priority pending topics
   - Instant XP reward on task completion

4. **Gamification & Reward System**
   - **XP Points Engine**: Earn XP for completing topics, high-priority tasks, quizzes, and streaks.
   - **6-Tier Level Progression**:
     - Level 1: Beginner 🌱 (0 - 100 XP)
     - Level 2: Learner 📚 (100 - 250 XP)
     - Level 3: Explorer 🚀 (250 - 500 XP)
     - Level 4: Achiever ⭐ (500 - 900 XP)
     - Level 5: Scholar 🎓 (900 - 1500 XP)
     - Level 6: Pro 👑 (1500+ XP)
   - **Daily Streak System**: Tracks continuous study consistency with burning flame UI (`🔥 7 Day Streak`) and calendar-day protection.
   - **Achievement Badges Gallery**: First Step, 3-Day Streak, 7-Day Streak, Math Master, Quiz Champion, Perfect Score, Syllabus Crusher, Scholar.

5. **Chapter-wise Quizzes & Weak Topic Revision**
   - Question-by-question quiz runner with instant scoring & XP rewards
   - Weak topic detection algorithm identifying questions answered incorrectly with actionable revision recommendations

6. **Reports & Analytics Module**
   - Weekly & Monthly performance summaries
   - Study time allocation by subject
   - Export official academic reports as PDF / Text dossier

7. **Class Leaderboard**
   - Top-3 podium and full semester ranking by total XP & badges

8. **Admin & Faculty Portal**
   - Manage syllabus templates
   - View student directory & academic metrics
   - Broadcast official announcements

---

## 📂 Project Architecture

```
gamified_syllabus_tracker/
├── backend/
│   ├── config/db.js               # MySQL Connection Pool
│   ├── database/
│   │   ├── schema.sql             # 15 normalized tables & foreign keys
│   │   └── seed.sql               # BCA Sem V sample dataset
│   ├── middleware/auth.js         # JWT validation & Admin guard
│   ├── routes/api.js              # Express REST API routes
│   ├── server.js                  # Node.js backend entry
│   └── package.json
│
├── lib/
│   ├── app/
│   │   ├── app.dart               # MultiProvider root & routing
│   │   ├── routes.dart            # Named navigation routes
│   │   └── theme.dart             # Material 3 Academic Light Theme
│   ├── core/
│   │   ├── constants/             # AppColors, AppConstants, ApiEndpoints
│   │   ├── network/               # ApiClient, ApiResponse
│   │   ├── storage/               # LocalStorageService
│   │   └── utils/                 # DateFormatter, LevelCalculator
│   ├── models/                    # Domain models with JSON serialization
│   ├── providers/                 # Provider state management
│   ├── screens/                   # Student & Admin screens
│   ├── services/                  # Network & Mock services
│   ├── widgets/                   # Reusable UI widgets
│   └── main.dart                  # Flutter entry point
└── pubspec.yaml
```

---

## 🚀 Running the Project

### 1. Running the Flutter App
Make sure Flutter is installed, then run:

```powershell
cd C:\Users\Admin\.gemini\antigravity\scratch\gamified_syllabus_tracker
flutter pub get
flutter run -d chrome     # Or: flutter run -d windows / android
```

### 2. Running the REST API & MySQL Backend (Optional / Production)
1. Start MySQL (e.g. from XAMPP Control Panel at `C:\xampp`).
2. Import database schema & seed:
```powershell
mysql -u root < backend/database/schema.sql
mysql -u root < backend/database/seed.sql
```
3. Run the Node.js REST API:
```powershell
cd backend
npm install
npm start
```
The server will start on `http://localhost:5000/api`.

---

## 🔑 Demo Login Credentials

- **Student Login:**
  - Email: `mital.vaja@glsuniversity.ac.in`
  - Password: `student123`
- **Admin / Faculty Login:**
  - Email: `admin@glsuniversity.ac.in`
  - Password: `admin123`
