# Known Limitations

ReturnIT is designed as a native iOS student portfolio project. It demonstrates iOS client-side architecture and UIKit layouts rather than cloud service integrations. Below are the limitations of the current codebase.

---

## 🔒 1. Local Sandboxed Persistence Only
* **No Database**: All reports, images, and user details are written locally to the app's sandboxed file system (`FileManager.default`).
* **Session Persistence**: Data is saved across app restarts but will be deleted if the app is uninstalled or if the device simulator is reset.

## 🔑 2. Simulated Authentication
* **UI Mock Only**: The registration and login screens simulate credentials validation using local user collections on disk.
* **No Server Verification**: Password hashes are calculated locally using `SHA256` but do not connect to a centralized IAM provider or OAuth gateways.

## 🗺️ 3. No Text Search
* **Category Filtering Only**: The Home Feed currently depends exclusively on segment control tabs (All, Lost, Found) and does not support full-text keyword searches across item names or descriptions.

## 🖼️ 4. Local Image Mocking
* **Sandboxed Images**: Photos taken or selected inside `PostItemViewController` are saved as JPEG files directly in the simulator's sandboxed Documents folder. They cannot be shared with other devices.
* **Fallback Images**: Default items bundle generic system SF symbols ("photo") because stock graphics are loaded programmatically.

## 📲 5. Platform Constraint
* **iOS Exclusive**: The app is built specifically using native Apple Swift and UIKit APIs. There is no web dashboard, Android companion, or cross-platform framework wrapper.
