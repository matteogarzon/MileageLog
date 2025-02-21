import SwiftUI

struct UserView: View {
    @EnvironmentObject private var mileageLogVM: MileageLogViewModel
    
    var body: some View {
        List {
            Section {
                Text(mileageLogVM.mainUser.firstName)
                Text(mileageLogVM.mainUser.lastName)
            } header: {
                Text("First and Last Name")
            }
            Section {
                Text(mileageLogVM.mainUser.email)
            } header: {
                Text("Email")
            }
            Section {
                Button {
                    mileageLogVM.signOut()
                } label: {
                    Text("Sign Out")
                }
                .foregroundStyle(.red)
                Button {
                    mileageLogVM.deleteAccount()
                } label: {
                    Text("Delete Account")
                }
                .foregroundStyle(.red)
            }
        }
        .navigationTitle("User")
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
