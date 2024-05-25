import SwiftUI
import Firebase

@main
struct SmartCameraLBTAApp: App {
    
    
    init() {
            do {
                try FirebaseApp.configure()
                print("Firebase configured")
            } catch {
                print("Error connecting to Firebase: \(error.localizedDescription)")
            }
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
