# cpims_flutter_test_app

This documentation provides an overview of the Flutter mobile application developed to handle Workflow 1. Workflow 1 involves a login page where users can log in using their username and password. After successful authentication, the application fetches dashboard data using a Bearer token and presents the summaries on a landing page.

### 2. Installation
To set up and run the application, follow these steps:

Clone the project repository: `git clone git@github.com:wekesa360/cpims-flutter-test-app.git`

Navigate to the project directory: `cd project-directory`

#### Install `Flutter and Dart` by following the official installation guide

---
##### Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
---


Install project dependencies: `flutter pub get`

Connect your device or start an emulator

Run the application: `flutter run`

### 3. Login Page
The login page allows users to log in using their credentials. Upon tapping the "Log In" button, the application sends a POST request to the login endpoint with the provided username and password. If the authentication is successful, the user is navigated to the dashboard page.

### 4. Dashboard Page
The dashboard page displays summary information fetched from the dashboard endpoint. It uses a Bearer token obtained during the login process to authenticate the request. The page showcases relevant data points retrieved from the server.

### 5. Navigation
The application uses Flutter's built-in navigation to switch between the login page and the dashboard page. After successful login, the user is automatically directed to the dashboard.

### 6. Screenshots
Screenshots of the Android application's key screens are provided below:

**Login Page**
![image](https://drive.google.com/file/d/1zdCxemHugjdi9AnX93NvvrSo8PWNi41V)

**Login Page 2**
![image](https://drive.google.com/file/d/1Z1mTizyAnOVqBe3VifdIK_vBDsn66KNa)



**Landing Page**
![image](https://drive.google.com/file/d/1SHafpZelaPL8Hvf7FZsvXJc8gkraAfFL)

