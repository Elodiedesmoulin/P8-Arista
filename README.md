# 🧘 Arista – Health & Wellness App (Project P8)

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [CoreData Model](#coredata-model)

---

### Introduction

**Arista** is a health and wellness iOS app developed for the startup Arista.  
The project was built as part of the **OpenClassrooms iOS Developer Path (Project 8)**.  
It focuses on securely managing **local user data** using **CoreData**, while applying the **MVVM** pattern to keep the code clean, scalable, and testable.

---

### Features

- **User Data View** (pre-filled, read-only)
- **Sleep Data View** (pre-filled, read-only)
- **Exercise List View**:
  - Add a new exercise
  - Delete an existing exercise
- **All data persisted locally** using CoreData
- **Structured UI with navigation**
- **Improved UI/UX respecting mobile design best practices**

---

### Architecture

The app uses a clean **MVVM (Model-View-ViewModel)** structure combined with **CoreData** for persistence:

#### View
SwiftUI views that handle user interaction and react to model updates.

#### ViewModel
Responsible for business logic, data formatting, and CoreData interactions (CRUD operations).

#### Model
Represents the CoreData entities: `User`, `Sleep`, `Exercise`. All conform to `NSManagedObject`.

---

## Getting Started

### Prerequisites

- Xcode 15 or later
- iOS 17 or later

---

### Installation

1. Clone the repository:
`git clone https://github.com/your-username/AristaHealthApp.git`

![simulator_screenshot_2E34FA00-9AAA-47B2-8F94-CF742935714A](https://github.com/user-attachments/assets/fa3e3200-3557-48a9-9a01-adddf60f7182)
![simulator_screenshot_88E2B60F-7676-4A6B-AB1C-9FBF209E27D0](https://github.com/user-attachments/assets/51a060e3-09eb-4bd4-9507-f16235a35a27)
