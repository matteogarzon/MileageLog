import SwiftUI

// @main --> means MileageLogApp struct/class provides entry point for program.
@main
struct MileageLogApp: App {
    
    // Attaching appDelegate to app through UIApplicationDelegateAdaptor (used to create apDelegates)
    // AppDelegate --> Root of the app
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    // StateObject -> data is stored in and owned by the views
    @StateObject private var mileageLogVM = MileageLogViewModel()
    
    var body: some Scene {
        WindowGroup {
            // View that is shown
            RootContentView()
                .environmentObject(mileageLogVM) // Thus, mileageLog can be used by the other views, by using @EnvironmentObject
        }
    }
}

