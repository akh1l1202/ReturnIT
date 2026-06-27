# Product Requirement Document (PRD)

## 🎯 Project Objective
The objective of **ReturnIT** is to build a lightweight, native iOS application that acts as a centralized database for lost and found items inside a university campus. The app must deliver an intuitive interface for students to report lost items, log found items, and manage verification states locally.

## 👥 Target Users
* **University Students**: Frequently misplace personal items in libraries, classrooms, cafeterias, and labs.
* **Campus Administration / Security**: Receive found items daily and need an organized catalog to register findings.

---

## 📌 Feature Scope

### 4.1 In Scope (Functional Requirements)
1. **User Accounts (UI-Only Mock)**
   * Register with campus email, full name, and password.
   * Log in using registered credentials.
   * Simulate user session status locally.
2. **Item Feed View**
   * Table list of all reported lost and found items.
   * Filter controls to toggling views between All, Lost, and Found.
   * Floating Action Button (FAB) to trigger item report.
3. **Item Submission Form**
   * Input name, choose category, write details/description, set location, and date.
   * Toggle between Lost and Found reports.
   * Open camera roll / photo library to associate an image with the report.
4. **Item Details Page**
   * View full details of the item.
   * Show contact button with the poster's email.
   * Double-resolution verification: An item is only resolved when both the poster and the finder mark the item as resolved.
5. **Data Engine**
   * Parse structured JSON from local resources at boot.
   * Save newly posted items and updated resolution states into the document sandbox.

### 4.2 Out of Scope (Future Enhancements)
* Cloud authentication (Firebase/Supabase).
* Real-time backend database sync.
* Push notification matching systems.
* In-app messaging/chats between users.
* Admin/moderation panel to flag malicious posts.
* Android/Web cross-platform builds.

---

## ⚙️ Requirements Matrix

### Functional Requirements
* **FR-1**: The application must load default items from the bundled `items.json` file when launched for the first time.
* **FR-2**: Users must be able to view details of any item by selecting it directly from the Home Feed table view.
* **FR-3**: Selecting a row in the Home Feed table view must push the `ItemDetailViewController` programmatically in the navigation controller stack (storyboard segues on selection are prohibited).
* **FR-4**: New items must be added to the top of the Home Feed list immediately upon submission.
* **FR-5**: A claim can only switch to a "Resolved" state when both the poster and finder mark it.

### Non-Functional Requirements
* **Performance**: The app must load the items list under 50ms from local sandbox storage.
* **Compatibility**: The application must run on iOS 15.6+ and adapt to multiple screen layouts (iPhone SE, Pro, Max).
* **UI Fidelity**: All view elements must follow Apple's Human Interface Guidelines, prioritizing clean layouts, semantic colors, and descriptive typography.
* **Reliability**: Force unwraps must be avoided to prevent runtime crashes during data loading and navigation.
