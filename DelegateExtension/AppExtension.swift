import Foundation
import Firebase

// second way to initialize firebase. adding extension to app structure (struct)
extension MileageLogApp {
    
    func setupFirebase() {
        FirebaseApp.configure()
    }
}
