# Tech Stack Documentation

This document detail the core technologies, layout practices, and architectural strategies chosen for the ReturnIT application.

## 📱 Technology Overview

* **Programming Language**: Swift 5.9
  * Chosen for type safety, modern syntax, and absolute compatibility with native iOS APIs.
* **UI Framework**: UIKit
  * Chosen to showcase proficiency in standard iOS UI development, view lifecycles, and controller delegate patterns.
* **Layout Design**: Storyboards + Programmatic Auto Layout
  * Standard Interface Builder storyboard is used to define the view skeleton and layout hierarchies.
  * Programmatic Auto Layout constraints and `CALayer` manipulations are used for custom styling (drop shadows, rounded corners, custom badge pills) to ensure dynamic responsiveness.

---

## 🏛️ Architectural Choices

### 1. Model-View-Controller (MVC)
The application strictly follows the MVC pattern, which is the native architecture for iOS UIKit:
* **Model**: Represented by simple, clean Swift structures (`LostFoundItem`, `User`) and data loaders (`DataLoader`). Conforms to the `Codable` protocol for serialization.
* **View**: Represented by storyboard templates and custom layout cells (`ItemCardCell`). Views are updated exclusively by controller bindings.
* **Controller**: View Controllers (`HomeFeedViewController`, `PostItemViewController`, etc.) govern user events, handle delegate protocols, and keep models and views in sync.

### 2. Local Sandboxed JSON Data Storage
A local JSON solution (`DataLoader`) was chosen over database integrations to prioritize:
* **Academic Portability**: The app builds and runs instantly in any Xcode simulator environment without requiring API keys, cloud credential setups, or internet dependencies.
* **Sandboxed Persistence**: Uses the file system's `documentDirectory` to read/write `.items.json` and `.users.json`. This demonstrates how native Swift APIs write to device disk space.
* **Decoupled Structure**: The data service uses standard CRUD methods (`addItem`, `saveItems`) that can be replaced with database queries in future production upgrades.

---

## 🧭 Navigation Architecture

* **Container**: `UINavigationController`
  * Manages the hierarchical screen stack, providing native back gesture support and custom navigation bars.
* **Programmatic Routing**:
  * Home Feed cell selections instantiate and push `ItemDetailViewController` programmatically in code:
    ```swift
    let detailVC = storyboard.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
    detailVC.item = selectedItem
    navigationController?.pushViewController(detailVC, animated: true)
    ```
  * Preserves separation between storyboard layout definition and run-time controller configurations.
