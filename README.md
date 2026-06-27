# ReturnIT – Campus Lost & Found App

ReturnIT is a native iOS application built using Swift and UIKit. It serves as a centralized lost-and-found portal specifically designed for university campuses, replacing disorganized notice boards, chats, and emails with a structured digital registry.

## 📱 Problem Statement

University campuses misplace thousands of items daily (student IDs, textbooks, water bottles, keys, electronics). The current recovery mechanisms—such as physical notice boards, random WhatsApp groups, or word-of-mouth—have critical drawbacks:
* **Low visibility**: Chat messages are quickly buried.
* **No categorization**: Finding items requires scrolling through endless chat logs.
* **No verification**: There is no secure or structured confirmation to verify ownership.
* **No audit trail**: Active items are not logged or tracked to completion.

ReturnIT resolves these challenges by providing a dedicated, structured mobile lost-and-found feed with categories, status states (Lost, Found, Resolved), and double-resolution verification.

---

## 🔁 User Flow & Screens

1. **Authentication (UI-Only)**
   * A clean, secure login and registration portal styled matching campus branding.
2. **Home Feed**
   * A feed rendering active lost and found records inside a custom `UITableView` with card styling.
   * Real-time segment control filtering (**All / Lost / Found**).
   * A Floating Action Button (FAB) to report new items.
3. **Report / Post Item**
   * A modal bottom sheet form for reporting items.
   * Prompts fields for Item Name, Category, Description, Location, and Date.
   * Integrates photo attachment using `UIImagePickerController`.
4. **Item Details**
   * Detailed breakdown of the item containing metadata, description, and status.
   * Contact details connecting direct actions.
   * "Mark as Resolved" action requiring double validation (both the poster and finder must acknowledge the resolution to close the claim).

---

## 🛠️ Tech Stack Summary

* **Language**: Swift 5.9
* **UI Framework**: UIKit (Storyboard + Auto Layout constraints)
* **Architecture**: Model-View-Controller (MVC)
* **Data Storage**: Local JSON bundle resources & Documents directory sandbox
* **Layout**: Adaptive constraints conforming to Apple's Human Interface Guidelines (HIG)

---

## ⚙️ How to Run Locally

### Prerequisites
* Mac with Xcode 16.0+ installed.
* iOS Simulator or iOS Device running iOS 15.6+.

### Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/akh1l1202/ReturnIT.git
   ```
2. Open `ReturnIT.xcodeproj` in Xcode:
   ```bash
   open ReturnIT.xcodeproj
   ```
3. Select your target simulator (e.g., iPhone 16 Pro) and press `Cmd + R` to compile and run.

---

## 🎓 Key Competencies Demonstrated

This project is an academic and portfolio-ready showcase demonstrating proficiency in core iOS development practices:
* **UI Construction**: Utilizing Auto Layout, programmatically constructed custom `UITableViewCell` layout constraints, modal view presentations, and programmatic layer stylings (`CALayer`, `CAShapeLayer`).
* **Design Pattern**: Adherence to the UIKit Model-View-Controller (MVC) separation of concerns.
* **Codable Parsing**: Direct serialization and deserialization of nested JSON records from local bundle files and files saved dynamically in the app's documents folder.
* **Navigation Flow**: Standard programmatic navigation controller transitions (using `pushViewController` and segues) separating entry screens from detail screens.

## 📖 Project Documentation

To learn more about the product design, architecture, and technology stack of ReturnIT, review the following files inside the [docs](file:///d:/GitHub/ReturnIT/docs) folder:
* **[Product Requirement Document (PRD)](file:///d:/GitHub/ReturnIT/docs/PRD.md)** — Core scope, user stories, and requirements.
* **[Tech Stack Choices](file:///d:/GitHub/ReturnIT/docs/TECH_STACK.md)** — Architectural design and framework details.
* **[System Architecture Diagram & Flow](file:///d:/GitHub/ReturnIT/docs/ARCHITECTURE.md)** — Class relationships and unidirectional data flow.
* **[Known Limitations](file:///d:/GitHub/ReturnIT/docs/KNOWN_LIMITATIONS.md)** — Details on simulation limits.
* **[Future Roadmap](file:///d:/GitHub/ReturnIT/docs/ROADMAP.md)** — Feature expansions, Swift/SwiftUI transitions, and push notices.

## ⚠️ Important Project Note & Limitations
This project is an **academic demo** aimed at portfolio presentation. It does not connect to a live backend cloud database, and user accounts are simulated locally for test convenience. Active postings and resolutions are saved locally to the simulator's sandboxed document store and will not persist across fresh device setups.

