# FestQuest - Festival Ticketing Platform

**FestQuest** is a dynamic mobile application that connects attendees and organizers in one seamless ticketing ecosystem. Built with **Flutter** and powered by **Firebase** and **Stripe**, it allows regular users to browse and purchase event tickets, while enabling organizers to host and manage their own events.

🎉 **Catchphrase:** *Chase the vibe, join the fest.*

---

## 🚀 Key Features

### 👥 For Attendees (Regular Users)
- **Engaging Home Interface** – Explore trending events with a modern, scrollable UI.
- **Browse & Book Tickets** – Purchase tickets via Stripe-integrated checkout.
- **Search & Category Filter** – Find events by keywords and categories (Concerts, Sports, etc.).
- **Personal Dashboard** – View purchased tickets and history with QR code access.
- **User Profile Management** – Update your details and keep your information current.

### 🎤 For Event Organizers
- **Organizer Dashboard** – Access tools to manage events, ticket sales, and view statistics.
- **Create & Publish Events** – Form-based event creation with poster upload and category tagging.
- **Manage Ticket Purchases** – Track buyers and booking info in real time.
- **Profile Customization** – Update organizer branding and contact details.

---

## 🔧 Technical Stack

- **Flutter** – Cross-platform development
- **Firebase** – Authentication, Firestore DB, and Storage
- **Stripe** – Secure payment gateway
- **Provider** – State management solution
- **Material 3** – Modern UI with consistent design system

---

## 🗂 Project Structurefestquest/
├── lib/
│ ├── main.dart
│ ├── models/
│ │ ├── event_model.dart
│ │ ├── organizer_model.dart
│ │ ├── ticket_model.dart
│ │ ├── user_model.dart
│ ├── routing/
│ │ ├── festquest.dart
│ ├── services/
│ │ ├── event_service.dart
│ │ ├── notification_service.dart
│ │ ├── organizer_service.dart
│ │ ├── paymentGateaway_service.dart
│ │ ├── service.dart
│ │ ├── shared_preference.dart
│ │ ├── ticket_service.dart
│ │ ├── user_service.dart
│ ├── viewmodels/
│ │ ├── createEvent_viewModel.dart
│ │ ├── dashboaard_viewModel.dart
│ │ ├── editProfile_viewModel.dart
│ │ ├── forgot_viewModel.dart
│ │ ├── login_viewModel.dart
│ │ ├── my_event_viewModel.dart
│ │ ├── notification_viewModel.dart
│ │ ├── profile_viewModel.dart
│ │ ├── purchase_viewModel.dart
│ │ ├── register_viewModel.dart
│ │ ├── search_viewModel.dart
│ │ ├── ticket_viewModel.dart
│ ├── views/
│ │ ├── core/themes
│ │ ├── dashboard
│ │ ├── login
│ │ ├── notification
│ │ ├── profile
│ │ ├── purchase
│ │ ├── register
│ │ ├── search
│ │ ├── ticket
---

## ⚙️ Getting Started

### 🧾 Requirements
- Flutter SDK (latest stable)
- Dart SDK
- Firebase project
- Android Studio or VS Code

### 📥 Setup Guide

1. **Clone this repository**
   ```bash
   git clone https://github.com/Tharalikh/MAP-Project.git
   cd MAP-Project
2. **Install Package**
   ```bash
   flutter pub get
3. **Configure Firebase**
   ```bash
   - Create Firebase Project
   - Enable Email/Password Authentication
   - Enable Firestore and Storage
   - Download google-services.json and place it in android/app/
   - Download GoogleService-Info.plist and place in ios/Runner/   
4. **Run app**
   ```bash
   flutter run

### 📡 State Management with Provider

```bash
MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => CreateEventViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => EditProfileViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => TicketViewModel()),
        ChangeNotifierProvider(create: (_) => PurchaseViewModel()),
        ChangeNotifierProvider(create: (_) => MyEventsViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
      ],
      child: const FestQuestApp(),
    ),
```
### 🗄 Firestore Schema

1. Events
   ```bash
   {
   'id': id,
   'title': title,
   'description': description,
   'date': date,
   'time': time,
   'price': price,
   'location': location,
   'poster': poster,
   'category': category,
   'creatorId': creatorId,
   'capacity': capacity,
   'bookedCount': bookedCount,
   }
2. Organizer
   ```bash
   {
    'username': username,
    'password': password,
    'name': name,
    'email': email,
    'phone': phone,
    'profilePic': profilePic,
   }
3. Ticket
   ```bash
   {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'name': name,
      'location': location,
      'date': date,
      'time': time,
      'price': price,
      'quantity': quantity,
      'poster': poster,
      'createdAt': Timestamp.fromDate(createdAt),
      'qrCode': qrCode,
      'rating' : rating,
      'feedback' : feedback,
    }
4. User
   ```bash
   {
    'uid' : uid,
    'username': username,
    'password': password,
    'name': name,
    'email': email,
    'phone': phone,
    'profilePic': profilePic,
   }

### 🚀 Deployment
Click link below:
```bash
https://drive.google.com/uc?export=download&id=17KqDeiFYLKA5q1igvJLdyAEVzobn2shE
