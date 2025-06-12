# TASKS.md: M-Pesa SMS Finance Tracker — Initial Tasks (Detailed Breakdown)

**Purpose:** Tracks current tasks, backlog, and sub-tasks for the M-Pesa SMS Finance Tracker project.

---

## 🟢 Current Active Work & Immediate Next Steps

* **Phase 1: Project Setup & Core Environment**  
  * [ ] Task 1.1: Flutter Environment Setup  
    * [x] Task 1.1.1: Install Flutter SDK (latest stable version).  
    * [x] Task 1.1.2: Install necessary Flutter/Dart plugins for chosen IDE.  
    * [x] Task 1.1.4: Configure Android SDK and Android Virtual Devices (AVD) for emulation. Or if not possible, user can set this up in their environment  
  * [ ] Task 1.2: Select and Initialize Local Database for Flutter  
    * [x] Task 1.2.1: Confirm Isar Database selection.  
    * [x] Task 1.2.2: Add Isar dependencies to pubspec.yaml.  
    * [x] Task 1.2.3: Define TransactionEntity schema with Isar annotations (including transactionId, dateTime, amount, senderRecipient, transactionType, category, rawSmsMessage, isManualEntry, receiptImageRef).  
    * [x] Task 1.2.4: Generate Isar schema code.  
    * [x] Task 1.2.5: Initialize Isar database instance in Flutter app.  

* **Phase 2: Core SMS-Centric Feature Development (MVP Focus)**  
  * [x] Task 2.1: Implement SMS Reading Permission Request in Flutter  
    * [x] Task 2.1.1: Add permission_handler dependency to pubspec.yaml.  
    * [x] Task 2.1.2: Implement permission check for READ_SMS and RECEIVE_SMS on Android.  
    * [x] Task 2.1.3: Implement logic to request permissions if not granted.  
    * [x] Task 2.1.4: Design and implement a clear, user-friendly explanation screen/dialog for why SMS permissions are needed.  
    * [x] Task 2.1.5: Implement graceful handling for permission denials (e.g., offer manual input alternative).  
    * [x] Task 2.1.6: Update AndroidManifest.xml with required SMS permissions.  
  * [x] Task 2.2: Develop Initial M-Pesa SMS Identification Logic  
    * [x] Task 2.2.1: Add flutter_sms_inbox or sms_advanced dependency to pubspec.yaml (for Android).  
    * [x] Task 2.2.2: Create a service/repository to query the Android SMS inbox.  
    * [x] Task 2.2.3: Implement filtering logic to identify potential M-Pesa transaction messages.  
  * [x] Task 2.3: Implement Robust M-Pesa SMS Parsing Logic  
    * [x] Task 2.3.1: Define regex patterns for transaction types (Money In, Out, PayBill, etc.).  
    * [x] Task 2.3.2: Create parsing functions to extract all relevant fields.  
    * [x] Task 2.3.3: Preprocess SMS content before parsing.  
    * [x] Task 2.3.4: Modularise parsing functions.  
  * [x] Task 2.4: Validate SMS Parsing on Emulator and My Phone
    * [x] Task 2.4.1: Prepare real SMS test set.
    * [x] Task 2.4.2: Build test interface.
    * [x] Task 2.4.3: Validate parsing on emulator.
    * [x] Task 2.4.4: Validate parsing on real device.
    * [x] Task 2.4.5: Log edge cases and failures.  
  * [x] Task 2.5: Implement Local Storage for Parsed Transactions  
    * [x] Task 2.5.1: Create repository service.  
    * [x] Task 2.5.2: Persist parsed data to Isar.  
  * [x] Task 2.6: Display Parsed Transactions in List View  
    * [x] Task 2.6.1: Design transaction list UI.  
    * [x] Task 2.6.2: Fetch from Isar and render list.  
    * [x] Task 2.6.3: Style by transaction type.  
  * [x] Task 2.7: Add Basic User Categorisation Interface  
    * [x] Task 2.7.1: Build category input (dropdown or text).  
    * [x] Task 2.7.2: Update category field in Isar.  
  * [x] Task 2.8: Implement Category Management (Add, Edit, Delete)
    * [x] Task 2.8.1: Define CategoryEntity schema with Isar annotations.
    * [x] Task 2.8.2: Implement repository and use cases for CRUD operations on categories.
    * [x] Task 2.8.3: Design and implement a UI for category management (e.g., a dedicated settings page).
    * [x] Task 2.8.4: Integrate dynamic categories into the transaction categorization flow.
    * [x] Task 2.8.5: Add unit tests for category management logic.

---

## 🔜 Backlog / Future Tasks

* **Phase 3: Design & UI/UX Refinement**  
  * [ ] Task 3.1: Create wireframes for core screens.  
  * [ ] Task 3.2: Build reusable Flutter UI components.  

* **Phase 4: Receipt Management & Enhanced Local Features**  
  * [ ] Task 4.1: Capture or select receipt images.  
  * [ ] Task 4.2: Compress images before saving.  
  * [ ] Task 4.3: Save local reference to image.  
  * [ ] Task 4.4: Add local filtering & search.  
  * [ ] Task 4.5: Build basic summaries & insights.  

* **Phase 5: Online Synchronization & Authentication**  
  * [ ] Task 5.0: Firebase Backend Setup  
    * [ ] Task 5.0.1: Review Firebase pricing.  
    * [ ] Task 5.0.2: Create Firebase project.  
    * [ ] Task 5.0.3: Link Firebase project to app.  
  * [ ] Task 5.1: Implement Firebase Authentication  
    * [ ] Task 5.1.1: Add Auth dependencies.  
    * [ ] Task 5.1.2: Register/login/logout.  
  * [ ] Task 5.2: Create Firebase Security Rules  
    * [ ] Task 5.2.1: Restrict Firestore access by user.  
    * [ ] Task 5.2.2: Secure receipt storage.  
  * [ ] Task 5.3: Implement Encryption  
    * [ ] Task 5.3.1: Setup flutter_secure_storage.  
    * [ ] Task 5.3.2: Encrypt sensitive fields.  
    * [ ] Task 5.3.3: Decrypt on read.  
  * [ ] Task 5.4: Sync Local & Cloud Data  
    * [ ] Task 5.4.1: Push local to Firestore.  
    * [ ] Task 5.4.2: Pull remote to Isar.  
    * [ ] Task 5.4.3: Handle sync conflicts.  
  * [ ] Task 5.5: Upload Receipt Images to Firebase Storage  
    * [ ] Task 5.5.1: Upload images.  
    * [ ] Task 5.5.2: Store image URLs in Firestore.  

* **Phase 6: Advanced Features & iOS Considerations**  
  * [ ] Task 6.1: Externalise parsing rules (e.g. via Firebase Remote Config).  
  * [ ] Task 6.2: Build iOS-friendly input alternatives.  
  * [ ] Task 6.3: Create advanced analytics dashboards.  
  * [ ] Task 6.4: Implement budgeting & alerts.  

---

## 🎯 Milestones

* **MVP Completion:** Phase 1 + Phase 2 completed with tested local SMS parsing, transaction capture, and categorisation.  
* **Receipt Management Fully Integrated:** Phase 4 complete.  
* **Online Sync Live:** Phase 5 complete with secure cloud backup and multi-device access.  

---

## 🧭 Discovered Mid-Process / Notes

* Add code comments and keep feature docs current.  
* Implement unit tests, especially for parsing and storage logic.  
* Handle permission denials, file errors, and sync failures gracefully.  
* Ensure compliance with the Kenya Data Protection Act (2019).
* **Important Note on Isar Schema Changes:** When modifying Isar `@collection` or `@Index` annotations (e.g., adding `unique: true`), you must:
    1. Run `flutter pub run build_runner build` to regenerate `.g.dart` files.
    2. **Clear app data** (or uninstall/reinstall the app) on your device/emulator to ensure the database schema is re-initialized correctly. Failing to do so can lead to unexpected behavior or crashes.
* **Regular Codebase Cleanup:** Periodically review the codebase to remove unused imports, unnecessary files, and commented-out code. This keeps the project lean, readable, and improves maintainability for future development. 