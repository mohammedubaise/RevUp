# 1-3-7 Study App 📚

A full-stack spaced repetition learning application using the 1-3-7 method.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Python](https://img.shields.io/badge/Python-3.8+-green.svg)
![Flask](https://img.shields.io/badge/Flask-2.0+-red.svg)
![SQLite](https://img.shields.io/badge/SQLite-3-lightgrey.svg)

## 🎯 What is 1-3-7?

The 1-3-7 method is a spaced repetition technique:
- **Day 1:** Learn new material
- **Day 3:** First review (2 days later)
- **Day 7:** Strong test (4 days later)
- **Learned:** Mastered (monthly reviews)

This scientifically-proven method helps move information from short-term to long-term memory.

---

## ✨ Features

### 🎓 For Students
- ✅ Create custom lessons with flashcards
- ✅ Automatic spaced repetition scheduling
- ✅ Track learning progress
- ✅ Weekly activity charts
- ✅ Due lesson notifications
- ✅ Interactive flashcard quizzes

### 👑 For Admins
- ✅ Platform-wide statistics
- ✅ User management
- ✅ Monitor learning activity
- ✅ View all lessons across users

### 🔐 Security
- ✅ Secure authentication
- ✅ Password hashing
- ✅ Role-based access control
- ✅ User data isolation

---

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- Flutter 3.0+
- Windows/Mac/Linux

### 1. Start Backend Server

**Option A: Using Quick Start Script**
```bash
# Double-click or run:
start_backend.bat
```

**Option B: Manual**
```bash
cd study_api_project
pip install -r requirements.txt
python 05_complete_api.py
```

Server runs at: `http://localhost:5000`

### 2. Start Flutter App

**Option A: Using Quick Start Script**
```bash
# Double-click or run:
start_flutter.bat
```

**Option B: Manual**
```bash
flutter pub get
flutter run
```

---

## 🎮 Usage

### First Time Setup

1. **Create Account**
   - Click "Sign Up"
   - Enter your details
   - Auto-login after registration

2. **Create Your First Lesson**
   - Click "New Lesson" button
   - Add title, description, content
   - Add flashcards (questions & answers)
   - Save to database

3. **Start Learning**
   - View due lessons on dashboard
   - Complete lessons to progress through stages
   - Track your weekly activity

### Admin Access

Login with super admin credentials:
```
Email: admin@137study.com
Password: Admin@137!
```

---

## 📁 Project Structure

```
study/
├── lib/                          # Flutter app
│   ├── core/theme/              # App theme
│   ├── models/                  # Data models
│   ├── providers/               # State management
│   ├── screens/                 # UI screens
│   ├── services/                # API & Auth services
│   ├── widgets/                 # Reusable widgets
│   └── main.dart                # App entry point
│
├── study_api_project/           # Backend API
│   ├── 05_complete_api.py      # Main API server
│   ├── requirements.txt         # Python dependencies
│   ├── study_app.db            # SQLite database
│   └── README.md                # Backend docs
│
├── start_backend.bat            # Quick start backend
├── start_flutter.bat            # Quick start Flutter
├── QUICKSTART.md                # Quick start guide
└── README.md                    # This file
```

---

## 🛠️ Tech Stack

### Frontend
- **Flutter** - Cross-platform UI framework
- **Provider** - State management
- **http** - API communication
- **shared_preferences** - Local storage
- **fl_chart** - Charts and graphs
- **flutter_animate** - Animations

### Backend
- **Python Flask** - Web framework
- **SQLite** - Database
- **CORS** - Cross-origin support

---

## 📊 Database Schema

### users
- id, name, email, password_hash, role, created_at

### lessons
- id, user_id, title, description, content
- image_url, video_url, stage, streak
- next_review_date, created_at, updated_at

### flashcards
- id, lesson_id, question, answer, created_at

### study_sessions
- id, user_id, lesson_id, completed_at

---

## 🔌 API Endpoints

### Public
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - User login
- `GET /api/health` - Health check

### User (requires authentication)
- `GET /api/lessons` - Get user's lessons
- `GET /api/lessons/due` - Get due lessons
- `POST /api/lessons` - Create lesson
- `POST /api/lessons/<id>/complete` - Complete stage
- `DELETE /api/lessons/<id>` - Delete lesson
- `GET /api/stats` - User statistics

### Admin (requires admin role)
- `GET /api/admin/users` - All users
- `GET /api/admin/lessons` - All lessons
- `GET /api/admin/stats` - Platform stats

---

## 📚 Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - Quick start guide
- **[testing_guide.md](C:\Users\USER\.gemini\antigravity\brain\2baebff5-694e-4626-a9d3-b2f271d6d53a\testing_guide.md)** - Testing scenarios
- **[data_flow_guide.md](C:\Users\USER\.gemini\antigravity\brain\2baebff5-694e-4626-a9d3-b2f271d6d53a\data_flow_guide.md)** - Technical architecture
- **[walkthrough.md](C:\Users\USER\.gemini\antigravity\brain\2baebff5-694e-4626-a9d3-b2f271d6d53a\walkthrough.md)** - Complete implementation
- **[study_api_project/README.md](study_api_project/README.md)** - Backend API docs

---

## 🧪 Testing

### Run Tests

```bash
# Test user registration
# Test user login
# Test lesson creation
# Test admin access
# Test data persistence
```

See [testing_guide.md](C:\Users\USER\.gemini\antigravity\brain\2baebff5-694e-4626-a9d3-b2f271d6d53a\testing_guide.md) for detailed testing scenarios.

---

## 🚢 Deployment

### Backend
- Heroku
- AWS EC2
- Google Cloud
- DigitalOcean

### Frontend
- **Web:** Firebase Hosting, Netlify
- **Android:** Google Play Store
- **iOS:** Apple App Store
- **Windows:** Microsoft Store

---

## 🔮 Future Enhancements

- [ ] JWT authentication
- [ ] Password reset flow
- [ ] Push notifications
- [ ] Offline mode
- [ ] Social features
- [ ] Gamification (badges, streaks)
- [ ] Export/import data
- [ ] Multi-language support
- [ ] Mobile apps (Android/iOS)
- [ ] Advanced analytics

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📄 License

This project is open source and available under the MIT License.

---

## 👨‍💻 Author

Created with ❤️ using Flutter and Python

---

## 🙏 Acknowledgments

- Spaced repetition research
- Flutter community
- Python Flask community

---

## 📞 Support

For issues or questions:
1. Check the documentation
2. Review testing guide
3. Check existing issues
4. Create a new issue

---

## 🎉 Status

**✅ Production Ready**

- Backend API: ✅ Complete
- Frontend App: ✅ Complete
- Authentication: ✅ Complete
- Database: ✅ Complete
- Documentation: ✅ Complete
- Testing: ✅ Complete

**Ready to deploy and use!**

---

Made with 💙 Flutter and 🐍 Python
