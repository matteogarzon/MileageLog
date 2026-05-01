import Foundation
import Firebase

// AppDelegate is root object of the app, where it launches. Here it's used to configure Firebase.
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
            // RemoteConfigManager.configure(exprationDuration: 0)
        return true
    }
}
