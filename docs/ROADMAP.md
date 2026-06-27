# Product Roadmap

This roadmap outlines planned enhancements to scale ReturnIT from a sandboxed portfolio demo to a production-ready, cloud-synced campus lost-and-found solution.

---

## 🛠️ Phase 1: Cloud Backend & Auth (High Priority)
* **Centralized Database**: Replace the `DataLoader` sandbox service with **Firebase Firestore** or **Supabase** to support real-time data sync across student devices.
* **Production Authentication**: Integrate **Firebase Auth** (with Google Sign-In and school email validation domains) to verify students.
* **Cloud Storage**: Store uploaded item photos in **Amazon S3** or **Firebase Storage** rather than sandboxing them locally.

## 🧭 Phase 2: User Experience & Utility Features
* **Keyword Search**: Implement a search bar using `UISearchController` to index item titles, descriptions, and locations.
* **In-App Messaging**: Add a secure chat channel enabling finders and owners to coordinate hand-offs without sharing personal emails or telephone numbers.
* **Match Notifications**: Set up push notifications (APNs) that alert a student if a newly registered item matches their reported lost item category and location tags.

## 💎 Phase 3: Platform Upgrades & Integrations
* **SwiftUI Refactor**: Migrate the UI layout from Storyboards and XML files to a declarative **SwiftUI** interface to improve layout speed.
* **QR Code Tags**: Implement a system to generate unique QR codes for reported items that can be printed and attached physically to laptops, textbooks, or bags.
* **Admin Dashboard**: Build a web portal (React/Next.js) for campus safety administration to monitor reports, remove outdated items, and verify ownership transfers.
