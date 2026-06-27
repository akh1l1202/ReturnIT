# ReturnIT – Campus Lost & Found App

ReturnIT is a high-fidelity native iOS application built using **Swift 5.9** and **UIKit**. It serves as a centralized, structured lost-and-found registry designed specifically for university campuses, replacing disorganized notice boards, chat groups, and campus emails.

---

## 📖 Table of Contents
1. [Problem Statement](#-problem-statement)
2. [Visual Walkthrough & Screens](#-visual-walkthrough--screens)
3. [Key Architecture & Data Flow](#️-key-architecture--data-flow)
4. [Key Swift & UIKit Concepts Demonstrated](#-key-swift--uikit-concepts-demonstrated)
5. [Reorganized Repository Structure](#-reorganized-repository-structure)
6. [Local Sandbox Data Engine](#-local-sandbox-data-engine)
7. [How to Run Locally](#️-how-to-run-locally)
8. [Project Limitations](#️-project-limitations)
9. [Detailed Project Documentation](#-detailed-project-documentation)
10. [License](#-license)

---

## 📱 Problem Statement

University campuses misplace thousands of personal belongings daily (student IDs, textbooks, water bottles, keys, electronics). The current recovery mechanisms—such as physical bulletin boards, chat groups, or word-of-mouth—are highly inefficient:
* **Low Visibility**: Postings in large chat channels are quickly buried under newer messages.
* **No Categorization**: Searching for a specific item requires scanning endless text logs.
* **No Audit Trail**: Active items are not logged or tracked to resolution.
* **No Ownership Verification**: There is no secure or structured validation to confirm item recovery.

ReturnIT addresses these issues by offering a dedicated lost-and-found registry. The application features category filters, real-time status tabs (Lost, Found, Resolved), and double-resolution verification (requiring both the finder and owner to confirm resolution).

---

## 📸 Visual Walkthrough & Screens

### 1. Interface Builder & Storyboard Layout
The interface is designed using **UINavigationController** and Storyboards. It conforms to Apple's Human Interface Guidelines (HIG) for iOS 17+, using Auto Layout constraints to adapt seamlessly to multiple screen formats (iPhone SE, Pro, Max).

<img width="1431" height="760" alt="image" src="https://github.com/user-attachments/assets/d2d8bc53-ad90-40d2-92b1-d2b91de15a6f"/>
<br>
<br>
<br>
<img width="1432" height="703" alt="image" src="https://github.com/user-attachments/assets/9a151e4c-b247-45b1-99c3-94364a53674e" />


### 2. User Authentication & Core Home Feed
* **Authentication**: Login and Registration screens styled with custom text fields, SF Symbol icons (envelope, lock), and secure entry toggles.
* **Home Feed**: Displays lost and found records inside a custom `UITableView` using card-styled cells. A Floating Action Button (FAB) at the bottom-right allows users to quickly report new items.

<img width="486" height="832" alt="Screenshot 2026-06-27 161957-Photoroom" src="https://github.com/user-attachments/assets/1856748b-8f03-414e-a0e3-40ee48098865" />


### 3. Modal Item Submission Form
* **Post Item Form**: Presented as a modal bottom sheet with top-rounded corners.
* **Category Picker**: The category field opens a custom action sheet (`UIAlertController`) showing campus categories.
* **Date & Time Picker**: The date field opens an action sheet with an integrated `UIDatePicker` in wheels style.
* **Photo Attachment**: Implemented using `UIImagePickerController` to let users select a photo from their photo library.

<img width="515" height="453" alt="Screenshot 2026-06-27 183012-Photoroom" src="https://github.com/user-attachments/assets/619b9416-0440-4eb3-b178-1671b7eb646c" />


### 4. Feed Filtering & Detail View
* **Status Toggles**: A segment control filter swaps table data in real-time (All / Lost / Found).
* **Item Details**: Displays the item image, title, description, location details, post date, and contact links. Clicking the poster's email opens the system mail composer.

<img width="496" height="428" alt="Screenshot 2026-06-27 183309-Photoroom" src="https://github.com/user-attachments/assets/8478a339-ef8d-4889-9067-bfa42b770409" />


### 5. Double-Resolution Claim Verification
To prevent false claims or single-sided closures, ReturnIT implements a **double-verification resolution system**:
1. When the current user (e.g., owner) clicks **Mark as Resolved**, the status updates to `Waiting for Finder...` and disables the action.
2. When the other user (e.g., finder) logs in and clicks **Mark as Resolved**, the status updates to `Waiting for Poster...`.
3. Once both parties have confirmed the resolution, the badge transitions to a green **RESOLVED** state, locking the item on disk.

<img width="481" height="856" alt="Screenshot 2026-06-27 183526-Photoroom" src="https://github.com/user-attachments/assets/fc8c3f87-99ea-4985-8f20-889674fdc847" />


---

## 🏛️ Key Architecture & Data Flow

ReturnIT follows a strict **Model-View-Controller (MVC)** architectural design:
1. **Model**: Pure data objects ([LostFoundItem.swift](ReturnIT/Models/LostFoundItem.swift), [User.swift](ReturnIT/Models/User.swift)) and the persistence helper ([DataLoader.swift](ReturnIT/Services/DataLoader.swift)).
2. **View**: UI templates configured inside [Main.storyboard](ReturnIT/Storyboards/Main.storyboard) and programmatically styled cells ([ItemCardCell.swift](ReturnIT/Views/ItemCardCell.swift)).
3. **Controller**: Coordinate UI updates, handle table view delegates, and process form submissions.

```
[JSON File on Disk] ➔ [DataLoader Engine] ➔ [LostFoundItem Array]
                                                    │
                                                    ▼
[ItemCardCell (View)] ◀── [HomeFeedViewController (Controller)]
```

---

## 🎓 Key Swift & UIKit Concepts Demonstrated

This codebase showcases clean native iOS development standards:
* **Custom TableView Cells**: [ItemCardCell.swift](ReturnIT/Views/ItemCardCell.swift) implements Auto Layout anchors programmatically to render rounded corners, shadow elevations, and image constraints without Interface Builder clutter.
* **Safe Decodable Mapping**: Custom decoding inside [LostFoundItem.swift](ReturnIT/Models/LostFoundItem.swift) automatically translates legacy JSON keys (like `title`) into the updated properties (`name`) and maps raw string states to a type-safe `ItemStatus` enum.
* **Outlets Audit & Fixes**: Removed fragile, hacky view-tree traversals (`findUIElements`) in form submissions and details controllers. All UI bindings are handled using compiler-checked `@IBOutlet` properties.
* **Programmatic Routing**: Selecting a row in the Home Feed triggers [HomeFeedViewController.swift](ReturnIT/Controllers/HomeFeedViewController.swift#L92-L105) to programmatically instantiate and push the detail view controller rather than relying on storyboard segues.
* **Programmatic CALayers**: Renders dashed photo upload boxes via `CAShapeLayer` and `lineDashPattern`, and pill badges using layer corner clips.

---

## 📂 Reorganized Repository Structure

The files have been structured in a clean, industry-standard layout:

* **[Models/](ReturnIT/Models)**: [LostFoundItem.swift](ReturnIT/Models/LostFoundItem.swift), [ItemStatus.swift](ReturnIT/Models/ItemStatus.swift), [User.swift](ReturnIT/Models/User.swift)
* **[Controllers/](ReturnIT/Controllers)**: [LoginViewController.swift](ReturnIT/Controllers/LoginViewController.swift), [RegisterViewController.swift](ReturnIT/Controllers/RegisterViewController.swift), [HomeFeedViewController.swift](ReturnIT/Controllers/HomeFeedViewController.swift), [PostItemViewController.swift](ReturnIT/Controllers/PostItemViewController.swift), [ItemDetailViewController.swift](ReturnIT/Controllers/ItemDetailViewController.swift), [MyPostsViewController.swift](ReturnIT/Controllers/MyPostsViewController.swift)
* **[Views/](ReturnIT/Views)**: [ItemCardCell.swift](ReturnIT/Views/ItemCardCell.swift)
* **[Services/](ReturnIT/Services)**: [DataLoader.swift](ReturnIT/Services/DataLoader.swift)
* **[Resources/](ReturnIT/Resources)**: [items.json](ReturnIT/Resources/items.json)
* **[Storyboards/](ReturnIT/Storyboards)**: [Main.storyboard](ReturnIT/Storyboards/Main.storyboard), [LaunchScreen.storyboard](ReturnIT/Storyboards/LaunchScreen.storyboard)

---

## 💾 Local Sandbox Data Engine

ReturnIT uses a file-based data engine:
1. At boot, [DataLoader.swift](ReturnIT/Services/DataLoader.swift) checks the app's sandboxed documents directory (`.items.json`).
2. If it is the first launch, it reads the bundled [items.json](ReturnIT/Resources/items.json) file, caches it in memory, and writes it to the documents folder.
3. Newly reported items are saved instantly to documents using `JSONEncoder` and persist across application restarts.

---

## ⚙️ How to Run Locally

### Prerequisites
* Mac running **macOS Sonoma** or higher.
* **Xcode 16.0+** installed.
* **iOS Simulator** or device running iOS 15.6+.

### Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/akh1l1202/ReturnIT.git
   ```
2. Open `ReturnIT.xcodeproj` in Xcode.
3. Select your target simulator (e.g. iPhone 16 Pro) and press `Cmd + R` to compile and run.

---

## ⚠️ Project Limitations
This project is an **academic showcase** and does not include:
* **Cloud Database Sync**: Postings are saved to local sandbox file systems and are not shared with other active devices.
* **Real Authentication**: User sessions are validated against simulated collections saved locally.
* **Image Hosting**: Uploaded images are stored as JPEGs inside the local documents sandbox.

---

## 📖 Detailed Project Documentation
Additional project design details are stored in the **[docs/](docs)** folder:
* **[Product Requirement Document (PRD)](docs/PRD.md)** — User stories, feature matrix, and constraints.
* **[Tech Stack Choices](docs/TECH_STACK.md)** — Architectural design and framework details.
* **[System Architecture Diagram & Flow](docs/ARCHITECTURE.md)** — UML data and navigation flows.
* **[Known Limitations](docs/KNOWN_LIMITATIONS.md)** — Constraints and design trade-offs.
* **[Future Roadmap](docs/ROADMAP.md)** — Phase roadmap for production and SwiftUI refactoring.

---

## 📄 License
This project is licensed under the **[MIT License](LICENSE)**.
