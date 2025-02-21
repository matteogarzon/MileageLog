import Foundation

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with:
                 self)
    }
    
    // Must be at least 6 chatacters, one upper char, one smaller char, one special character
    var isValidPassword: Bool {
        NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{6,}$").evaluate(with: self)
    }
}
