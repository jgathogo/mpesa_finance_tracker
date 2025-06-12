# M-Pesa SMS Finance Tracker — Planning Document (PRD)

## 🏷️ Project Title: M-Pesa SMS Finance Tracker**

## 📝 Description:**

The M-Pesa SMS Finance Tracker is a mobile application designed to empower individuals with automated and efficient tracking of their M-Pesa transactions. Its core functionality centers on reading and parsing M-Pesa transaction SMS messages on the user's phone. The application will identify relevant M-Pesa SMS messages, extract key financial details such as transaction ID, date, amount, sender/recipient, and transaction type (e.g., PayBill, Till, Money In/Out). Users will have the option to upload associated receipts (photos or screenshots) and categorize their transactions for better financial organization. Initially, all parsed and categorized data will be stored securely on the user's device, with a future phase planned for synchronization to an online database for broader accessibility and backup.

## ❗ Problem:**

M-Pesa users currently face significant challenges in effectively tracking and managing their finances due to the manual and cumbersome nature of M-Pesa SMS messages for financial overview. Sifting through SMS messages to reconcile spending, identify income, or understand transaction types is time-consuming and prone to errors. This often leads to a lack of clear financial oversight, making it difficult for users to budget, analyze spending patterns, or easily retrieve specific transaction details. The current process creates a barrier to personal financial management for millions of M-Pesa users.

## 🤔 Why:**

This is a real and significant problem worth solving due to the widespread use of M-Pesa as a primary financial tool in Kenya, coupled with the inherent difficulty in extracting structured, actionable financial data from free-form SMS messages. There's a clear market need for automated personal financial management tools tailored to the M-Pesa ecosystem. While M-Pesa provides transaction notifications, they are not designed for easy financial analysis or categorization. Anecdotal evidence from countless users highlights the frustration of manually tracking transactions and desire for automation. By automating this process, the application addresses a fundamental need for better financial clarity among M-Pesa users.

## ✅ Success Criteria:**

We will measure the success of this project through several key indicators:

* **Accurate SMS Parsing Rate:** A high percentage of correctly identified and parsed M-Pesa SMS messages, ensuring reliable data capture.  
* **User Satisfaction with Categorization and Insights:** Users can categorise easily and find insights useful.  
* **Smooth Local-to-Online Sync (in future phases):** Efficient and reliable synchronization of local data with the online database, minimizing data discrepancies and ensuring data availability.  
* **Personal Financial Clarity for the Initial User:** As the primary initial user, my ability to consistently and easily track, categorize, and understand my M-Pesa spending and income will be a crucial early measure of success.  
* **User Adoption and Retention (for future public release):** For future broader release, success will also be measured by the number of active users and their continued engagement with the application.

## 🧑‍🤝‍🧑 Target Audience:**

The primary target users for this application are **individuals who heavily rely on M-Pesa for their daily financial transactions** and seek an automated way to track their spending and income.

Initially, the application's first user will be **myself**. This will allow for thorough, hands-on testing and validation of the core SMS parsing, data extraction, local storage, and receipt management flows. This iterative approach ensures the fundamental capabilities are robust before expanding to a wider audience.

Upon successful validation by the initial user, the target audience will expand to individuals seeking an automated M-Pesa expense tracking solution that integrates seamlessly with their mobile device's SMS messages. This includes anyone desiring better personal financial management without the need for manual data entry or reliance on official M-Pesa statements/APIs (which are out of current scope).

## 📱 Product Overview:**

The M-Pesa SMS Finance Tracker will offer a streamlined user experience, primarily focusing on automated transaction capture. Upon initial launch or when the user initiates SMS tracking, the app will request necessary SMS reading permissions with a clear explanation of its purpose. Once granted, it will access the SMS inbox, identify M-Pesa transaction messages, and parse them to extract critical details like transaction ID, amount, date, time, and type. These parsed transactions will be presented to the user in a clean, chronological list. For each transaction, the user will be prompted to optionally upload a corresponding receipt (either by taking a new photo or selecting a screenshot from their gallery). A user-friendly interface will also allow for categorization of each transaction (e.g., "Groceries," "Transport," "Utilities"), and users will be able to manage their custom categories.

**High-Level Architecture Description:**

The application will follow a layered architecture, likely Clean Architecture or MVVM, to ensure separation of concerns and maintainability.

* **Flutter Frontend (Mobile App):** This is the user-facing application built with Flutter, responsible for UI, user interaction, SMS permission handling, local data display, and receipt upload initiation.  
* **Local Database (Isar):** All parsed M-Pesa transaction data, including categories and receipt references, will first be stored securely and efficiently on the device using Isar Database.  
* **Backend & Online Database (Firebase):** For future synchronization, **Firebase (Firestore \+ Cloud Functions)** is the recommended backend. Firestore will serve as the online database for synced transaction data, leveraging its real-time capabilities and offline persistence. Cloud Functions will handle any server-side logic, such as data validation or more complex processing.  
* **Cloud Storage for Receipts (Firebase Storage):** User-uploaded receipt images will be securely stored in Firebase Storage, integrated seamlessly with the Firebase backend.

**Proposed Modern Technology Stack:**

* **Frontend Framework:** Flutter (latest stable version)  
* **Local Storage:** Isar Database  
* **Backend & Online Database:** Firebase (Firestore \+ Cloud Functions)  
* **Cloud Storage for Receipts:** Firebase Storage  
* **Authentication & Authorization (for sync phase):** Firebase Authentication

**Crucial Research Findings Integrated:**

* **Flutter SMS Reading Permissions (Android & iOS):**  
  * **Android:** Highly feasible. Android offers robust support for applications to read SMS messages, utilizing packages like flutter\_sms\_inbox and sms\_advanced to query the inbox and listen for incoming messages. Permissions like READ\_SMS and RECEIVE\_SMS are required and must be requested at runtime for Android 6.0+. Best practices include requesting permissions "just-in-time" with clear explanations to build user trust.  
  * **iOS:** In stark contrast, iOS imposes stringent restrictions on third-party applications' direct access to a user's SMS inbox due to privacy and security. Packages like flutter\_sms\_inbox are Android-only for SMS reading. This means the core SMS reading functionality **cannot be delivered uniformly on iOS**, necessitating alternative data input methods like manual entry or OCR on screenshots.  
* **Flutter SMS Parsing Libraries/Techniques:**  
  * **Techniques:** A hybrid approach combining simple String.contains() checks for initial classification and precise **regular expressions (regex)** for targeted data extraction is highly effective for M-Pesa SMS messages. Preprocessing messages (e.g., toLowerCase()) and splitting them into words can aid parsing.  
  * **Adaptability:** The dynamic nature of M-Pesa SMS formats (which can evolve over time) mandates designing parsing logic for easy updates. This includes **externalizing parsing rules** (e.g., in a JSON file or via Firebase Remote Config) to allow dynamic updates without requiring app store redeployments. Modularizing parsing functions into small, single-responsibility units and rigorous unit testing are crucial for maintainability and reliability.

## 🛠️ Implementation Plan:**

The project will adopt an agile, iterative approach, with an initial focus on delivering a Minimum Viable Product (MVP) for the Android platform, given the SMS reading limitations on iOS.

**MVP Scope (Android Focus):**

1. **Core SMS Reading & Parsing:**  
   * Securely request and handle Android SMS reading permissions.  
   * Implement initial logic to identify M-Pesa SMS messages.  
   * Develop robust parsing logic using regex and string manipulation to extract transaction ID, amount, date, time, sender/recipient, and transaction type.  
   * **Crucially, validate parsing accuracy on both emulator and a physical Android device (my phone) using real M-Pesa SMS messages.**  
2. **Local Data Storage:**  
   * Define the Isar schema for M-Pesa transactions (including rawSmsMessage, isManualEntry, category, receiptImageRef).  
   * Implement saving of parsed transactions to the local Isar database.  
3. **Basic Transaction Listing & Categorization:**  
   * Display a chronological list of locally stored M-Pesa transactions.  
   * Provide a basic UI for users to manually assign categories to each transaction.  
   * Implement functionality for users to add, edit, and delete custom categories.
4. **Initial UI/UX:**  
   * Design clean and intuitive screens for permission requests, transaction listing, and categorization.

**Phased Approach for Features Beyond MVP:**

* **Phase 2: Receipt Management & Enhanced Local Features:**  
  * Implement receipt image capture/selection using image\_picker.  
  * Integrate flutter\_image\_compress for efficient image compression before storage.  
  * Implement local storage of receipt images or references.  
  * Develop filtering and basic reporting of local transactions (e.g., spending by category).  
* **Phase 3: Online Synchronization & Authentication:**  
  * Integrate Firebase Authentication for user sign-up/login.  
  * Implement secure synchronization of local Isar data with Firebase Firestore, including client-side encryption for sensitive fields.  
  * Implement Firebase Storage for cloud storage of receipt images, with robust security rules.  
  * Address data integrity and conflict resolution during sync.  
* **Phase 4: Advanced Analytics & Budgeting:**  
  * Develop more sophisticated spending insights and visualizations.  
  * Implement budgeting features based on categorized transactions.  
  * Explore notifications for exceeding budget limits or unusual spending.  
* **Phase 5: iOS Alternative Strategy (if pursued):**  
  * Develop an alternative data input method for iOS (e.g., manual entry with streamlined forms, or OCR on user-uploaded screenshots of SMS/statements), integrating with the existing Firebase backend.

## 🗓️ Timeline & Implementation Steps (LLM-Driven Build)

This project is being implemented by an LLM and will follow a tightly sequenced, stepwise execution process. Each step unlocks the next and is validated before proceeding.

### 🟩 Step 1: Environment Setup & Local Database
- Setup Flutter SDK and IDE
- Configure Android Virtual Device (AVD)
- Initialise local Isar database
- ✅ *Exit criteria:* Flutter app builds and can store dummy transactions locally

### 🟩 Step 2: SMS Reading & Parsing MVP
- Request SMS permissions
- Read inbox and filter M-Pesa messages
- Apply regex-based parsing logic
- Store parsed transactions in Isar
- ✅ *Exit criteria:* App correctly parses and stores transactions from real SMS (tested on emulator and device)

### 🟩 Step 3: Basic UI for Listing & Categorising Transactions
- Display parsed transactions
- Add user interface for category selection
- ✅ *Exit criteria:* Transactions can be browsed and categorised

### 🟩 Step 4: Receipt Capture & Local Image Handling
- Implement image picker (camera/gallery)
- Compress and save image locally
- Link image to transaction
- ✅ *Exit criteria:* Receipts captured and viewable per transaction

### 🟩 Step 5: Firebase Integration
- Setup Firebase project
- Configure Firestore, Storage, Auth
- Apply security rules and test access
- ✅ *Exit criteria:* App stores/retrieves transaction data and images securely per user

### 🟩 Step 6: Sync Logic & Final Testing
- Implement sync between Isar and Firestore
- Handle conflicts, encryption, offline scenarios
- ✅ *Exit criteria:* Multi-device, secure sync functioning reliably

### ⚠️ Notes
- Documentation and inline comments will be maintained throughout
- Each step will have its own testing screen or visual debug feedback to validate progress
- This replaces monthly milestones with task-driven gates suitable for AI-augmented build execution