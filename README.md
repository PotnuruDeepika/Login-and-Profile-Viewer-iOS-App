# Login-and-Profile-Viewer-iOS-App
Login and Profile screen

The app contains **3 screens** as per the Figma design:

1. **Phone Number Screen**  
   - Enter country code and phone number.  
   - On tapping **Continue**, calls Phone Number API.

2. **OTP Verification Screen**  
   - Enter OTP.  
   - On tapping **Continue**, calls OTP API.  
   - On success, retrieves `auth_token`.

3. **Notes Screen**  
   - Uses `auth_token` in API header to fetch user notes.  
   - Displays profile list in a `UITableView`.

---

## 🛠️ Tech Stack

- Swift 5  
- UIKit  
- MVVM Architecture  
- URLSession (Networking)  
- Codable (JSON Parsing)  
- Programmatic UI (no Storyboards)  

---

## 📂 Project Structure

Login&Profile/
├── Model/
 │ ├── NoteModel.swift
│ └── NoteProfile.swift
├── ViewModels/
│ ├── LoginViewModel.swift
│ ├── OTPViewModel.swift
│ └── NotesViewModel.swift
├── Views/
│ ├── PhoneNumberViewController.swift
│ ├── OTPViewController.swift
│ └── NotesViewController.swift
│ └── TableViewCell/
│     ├── NoteCell.swift
│ ├── APIManager.swift
│ ├── APPDelegate.swift
│ ├── SceneDelegate.swift
│ ├── ViewController.swift
│ └── Info.plist
└── Assets.xcassets
