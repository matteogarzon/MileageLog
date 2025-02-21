import SwiftUI

struct SelectedContentView: View {
    // Wrapper @EnvironmentObject allows for the data of the VM to be accessed by the views, and update them when data changes.
    @EnvironmentObject private var mileageLogVM: MileageLogViewModel
    
    var body: some View {
        // "userSignedIn" is a function from the VM, returns boolean value. 
        // Since it uses "@Published" wrapper, with any change to it SelectedContentView will react accordingly (i.e., showing TabView or MainLoginView())
        if mileageLogVM.userSignedIn {
            TabView {
                LogsView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                SortView()
                    .tabItem{
                        Label("Sort", systemImage: "folder.fill")
                    }
                StatisticsView()
                    .tabItem {
                        Label("Statistics", systemImage: "chart.bar.fill")
                    }
            }
        } else {
            // If not logged in, MainLoginView is shown, where users can choose to Sign up or Log in.
            MainLoginView()
        }
    }
}

struct SelectedContentView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedContentView()
    }
}
