import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var mileageLogVM: MileageLogViewModel
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        List {
            Section {
                TextField("Name", text: $firstName)
                TextField("Surname", text: $lastName)
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } header: {
                Text("User details")
            } footer: {
                Text("Password must be minimum six chatacters, one number, and one special character.")
            }
            
            Section {
                Button {
                    // Action called when clicking the button
                    mileageLogVM.signUp(firstName: firstName, lastName: lastName, email: email, password: password)
                } label: {
                    Text("Sign Up")
                }
                // Disabled property  is based on boolean value (true -> disabled; false -> enabled)
                .disabled(!mileageLogVM.checkSignUpFields(firstName: firstName, lastName: lastName, email: email, password: password))
            }
        }
        .navigationTitle("Sign Up")
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
