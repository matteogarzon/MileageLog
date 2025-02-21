import SwiftUI

struct RootContentView: View {
    @EnvironmentObject private var mileageLogVM: MileageLogViewModel
    
    var body: some View {
        NavigationStack(path: $mileageLogVM.path) {
            // SelectedContentView is shown first, but then...
            SelectedContentView()
            // Two types of navigationDestination (String and Log) based on what is passed to as the value of the NavigationLink in other views.
                // Example: NavigationLink(value: String) -> avigationLink(value: "signUp")
                .navigationDestination(for: String.self) { value in
                    switch value {
                    case "signIn":
                        SignInView()
                    case "signUp":
                        SignUpView()
                    case "setting":
                        UserView()
                    case "add":
                        AddLogsView()
                    default: Text("Default View")
                    }
                // If navigationLink(value: Log) -> this is called in the LogsView, when clicking on a log to edit it.
                }.navigationDestination(for: Log.self, destination: { log in
                    // Passes log data to EditLogsView, together with the log itself for its ID to be updated in the database.
                    EditLogsView(log: log, logDate: log.date, logCost: log.cost, logDistance: log.distance, logLiters: log.liters, logFuel: log.fuel)
                })
                .alert(mileageLogVM.customAlertInfo.title, isPresented: $mileageLogVM.isPresentAlert, actions: { // For customAlertInfo implementation.
                    // action
                }, message: {
                    Text(mileageLogVM.customAlertInfo.description)
                })
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    mileageLogVM.isUserSignedIn() // When RootContentView "opens", checks whether user is signed in. If yes, SelectedContentView will show home page, otherwise MainLoginView()
                }
        }
    }
}

struct RootContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootContentView()
    }
}
