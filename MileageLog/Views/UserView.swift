
import SwiftUI

struct UserView: View {
    @EnvironmentObject var myAppVM: MyAppViewModel
    
    var body: some View {
        Form {
            Text("Login Succeeded")
        }.toolbar {
            ToolbarItem {
                Button {
                    myAppVM.signOut()
                } label: {
                    Text("SignOut")
                }
            }
        }
        .navigationTitle("Users Screen")
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
