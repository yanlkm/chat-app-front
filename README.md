# Flutter Chat App

## Overview

This is a Flutter-based chat application that allows users to sign up, sign in, join chat rooms, and communicate in real-time. The app uses various state management techniques and integrates with backend services for authentication, user management, and real-time messaging.

## Features

- User authentication (sign up, sign in, sign out)
- Real-time messaging
- Chat rooms
- User profile management
- Admin Panel for User and Chat Room Management

## Project Structure

The project is structured as follows:

- lib/ : Contains the main source application code. 
    - data/ : Data sources, models and repositories.
    - domain/ : Business logic and use cases.
    - presentation/ : UI and state management.
    - utils/ Utility constants, functions and classes.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio / Visual Studio Code

### Installation

1. Clone the repository
```bash
git clone https://github.com/yanlkm/chat-app-front.git
cd chat-app-front
```

2. Install dependencies
```bash
flutter pub get
```

3. Set up environment variables : Create a .env file in the root directory and add the following environment variables :
```bash
BASE_URL=BACKEND_URL
SOCKET_URL=SOCKET_URL
```

4. Run the app
```bash
flutter run
```

## USAGE

### Authentication
- Sign Up : Navigate to the Sign-Up page and create a new account using a CODE.
- Sign In :  Navigate to the Sign-In page and log in with your credential

### Chat 
- Join a Chat Room : Navigate to the Rooms page and join a chat room by selecting it.
- Send a Message : Send a message to the chat room by typing it in the text field and pressing the send button.
- Receive Messages : View messages from other users in the chat room in real-time.

### User Profile
- View Profile : Navigate to the Profile page to view your user profile.
- Edit Profile : Edit your user profile by clicking on the edit button : username, password.

### Admin Panel
- User Management : View all users, ban and unban users and create registration codes.
- Chat Room Management : View all chat rooms, create new chat rooms, add and delete hashtags.

### Acknowledgements
- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [WebSocket](https://pub.dev/packages/web_socket_channel)
- [Dio](https://pub.dev/packages/dio)
- [Equatable](https://pub.dev/packages/equatable)
- [Flutter Bloc](https://pub.dev/packages/flutter_bloc)
- [Either](https://pub.dev/packages/dartz)
- [JWT](https://pub.dev/packages/jwt)
- [Json Decode](https://pub.dev/packages/json_decode)
- [Dotenv](https://pub.dev/packages/dotenv)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)


