import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var mileageLogVM: MileageLogViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        List {
            Section {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            Section {
                Button {
                    mileageLogVM.signIn(email: email, password: password)
                } label: {
                    Text("Sign In")
                }
                .disabled(!mileageLogVM.checkSignInFields(email: email, password: password))
            }
        }.navigationTitle("Sign In")
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
