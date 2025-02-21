// View model: MVVM

import Foundation
import SwiftUI
// import Firebase
import FirebaseAuth
// import FirebaseCore
import FirebaseFirestore

// "ObservableObject" -> changes of the object's data is directly observed by the views that have access to it.
// Changes of the variables are "published" to the other views with the Published wrapper.
class MileageLogViewModel: ObservableObject {
    @Published var userSignedIn: Bool = false
    @Published var path = NavigationPath() // Used to build a NavigationStack with different destinations.
    
    let auth = Auth.auth()
    
    @Published var isPresentAlert = false
    @Published var customAlertInfo = CustomAlertInfo(title: "", description: "")

    @Published var mainUser = User(id: "", firstName: "", lastName: "", email: "")
    let db = Firestore.firestore()

    @Published var allLogs = [Log]() // Array with elements of type Log
    @Published var isRunInitLogs = true
    
    // Format Date
    let formatDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    // Check if user is signed in.
    func isUserSignedIn() {
        let result = auth.currentUser != nil // If true -> user is signed in
        
        if result {
            // isRunInitLogs is a boolean value determining whether user has ever taken logs.
            if isRunInitLogs {
                takeUserData()
                takeLogList()
                isRunInitLogs.toggle() // We have taken the logs!
            }
        }
        
        DispatchQueue.main.async {
            [weak self] in
            self?.userSignedIn = result // depending on boolean, any view observing userSignedIn will update
        }
    }
    
    // Back to RootContentView
    func backToRootScreen() {
        DispatchQueue.main.async {
            [weak self] in
            self?.path = .init()
        }
    }
    
    // Sign Up
    func signUp(firstName: String, lastName: String, email: String, password: String) {
        
        guard checkEmailAndPassword(email: email, password: password) == true else {
            // Error while check an email and password
            return
        }
        
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            
            // Once we create a user, result and error is returned
            guard error == nil else {
                self?.showAlertWith(title: "Error with Sign up", description: "Error: \(String(describing: error))")
                print("Error with SignUp \(String(describing: error))")
                return
            }
            
            guard let mainResult = result else {
                self?.showAlertWith(title: "Result is nil", description: "The result with users data is nil")
                return
            }
            
            let userUID = mainResult.user.uid
            
            guard let userEmail = result?.user.email else {
                self?.showAlertWith(title: "Error with 'result.user", description: "Error: 'result?.user.email == nil' ")
                return
            }
            
            // Add user to Firestore database
            self?.db.collection("users").document(userUID).setData(["firstName": firstName, "lastName": lastName, "email": userEmail], merge: true) { error in
                guard error == nil else {
                    self?.showAlertWith(title: "Error set users data to the Firestore", description: "Error: \(String(describing: error))")
                    return
                }
            }
            self?.backToRootScreen()
        }
    }
    
    // Sign In
    func signIn(email: String, password: String) {
        
        guard checkEmailAndPassword(email: email, password: password) == true else {
            return // exit the scope
        }
        
        // Call imported Firebase method, passing user inputted email and password.
        auth.signIn(withEmail: email, password: password) { [weak self]
            result, error in
            
            // nil is the absence of a value, it's the equivalent of "null" in other languages.
            guard error == nil else {
                self?.showAlertWith(title: "Something went wrong.", description: "Error: \(String(describing: error))")
                return
            }
            
            // Checks whether the user has registred correctly by making sure the user's email is not nil.
            // guard let userEmail = result?.user.email else
            guard (result?.user.email) != nil else {
                self?.showAlertWith(title: "Error with result.user", description: "Error: 'result?.user.email == nil'")
                return
            }
            
            self?.backToRootScreen() // At the end, the app will show LogsView.
        }
    }
    
    // Sign out
    func signOut() {
        do {
            try auth.signOut() // tries to signOut
        } catch {
            showAlertWith(title: "Something went wrong.", description: "Error: \(error)") // If cannot signOut, then shows alert.
        }
    
        backToRootScreen()
        isRunInitLogs = true
    }
    
    // Delete account
    func deleteAccount() {
        let currentUserUID = auth.currentUser?.uid ?? ""
        let docPath = db.collection("users").document(currentUserUID)
        
        // This approach doesn't allow to delete documents within the LogsList collection, since it is highly discouraged by Firebase.
        docPath.delete() { [weak self] err in // Delete document
            if let err = err {
                self?.showAlertWith(title: "Something went wrong deleting your logs.", description: "Error: \(err)")
            } else {
                self?.auth.currentUser?.delete { [weak self] error in // Delete user
                    if let error = error {
                        self?.showAlertWith(title: "Something went wrong deleting your account.", description: "Error: \(error)")
                    } else {
                        self?.backToRootScreen()
                        self?.isRunInitLogs = true
                    }
                  }
            }
        }

    }
    
    // Show Alert
    func showAlertWith(title: String, description: String) {
        DispatchQueue.main.async {
            [weak self] in
            self?.customAlertInfo.title = title // The title of the customAlertInfo
            self?.customAlertInfo.description = description // The description of customAlertInfo
            self?.isPresentAlert = true // Whether the alert is showing
        }
    }
    
    // Check Email and Password
    func checkEmailAndPassword(email: String, password: String) -> Bool {
        
        let isValidEmail = email.isValidEmail
        let isValidPassword = password.isValidPassword
        
        switch (isValidEmail, isValidPassword) {
        case (true, true):
            return true
        case (false, false):
            showAlertWith(title: "Email & Password are invalid", description: "Email is invalid & password must be at least 8 characters.")
            return false
        case (false, _):
            showAlertWith(title: "Email is invalid", description: "Incorrect email format")
            return false
        case (_, false):
            showAlertWith(title: "Password is invalid", description: "The password must be at least 6 characters.")
            return false
        }
        
    }
    
    // User Data from Firebase
    func takeUserData() {
        let currentUserUID = auth.currentUser?.uid ?? ""
        let currentUserEmail = auth.currentUser?.email ?? ""
        
        let docRef = db.collection("users").document(currentUserUID)
        docRef.getDocument {[weak self] snapshot, error in // snapshot is the document.
            // [weak self] -> Prevent memory leaks
            
            guard error == nil else {
                self?.showAlertWith(title: "Document Info Error", description: "Error \(String(describing: error))")
                return
            }

            guard let userData = snapshot else {
                self?.showAlertWith(title: "Snapshot is Nil", description: "Snapshot with user info is Nil")
                return
            }
            
            let firstName = userData["firstName"] as? String ?? ""
            let lastName = userData["lastName"] as? String ?? ""
            
            let newUser = User(id: currentUserUID, firstName: firstName, lastName: lastName, email: currentUserEmail) // instance of User with data.
            DispatchQueue.main.async { // async -> program can continue executing without waiting for block of code to be completed.
                self?.mainUser = newUser
            }
        }
    }
    
    
    // Add New Log
    func addNewLog(logDate: Date, logLiters: Float, logDistance: Float, logCost: Float, logFuel: String) {

        let currentUserUID = auth.currentUser?.uid ?? "" // User ID
        
        let docPath = db.collection("users").document(currentUserUID).collection("LogsList") // Path of collection LogsList of that specific User (i.e., under it's ID)

        // Create a new document with the passed data.
        // merge: true -> If we have already this document it will be replaced.
        docPath.document().setData(["date": logDate, "liters": logLiters, "distance": logDistance, "cost": logCost, "fuel": logFuel], merge: true) {
            [weak self] error in
            guard error == nil else {
                // If there's an error, show this alert with the error description.
                self?.showAlertWith(title: "Error adding Log.", description: "Error: \(String(describing: error))")
                return // exit function
            }
            self?.showAlertWith(title: "Log added successfully.", description: "") // Otherwise, show the alert for success.
            self?.takeLogList() // Take the updated log list.
        }

    }
    
    // Get List of Log Items
    func takeLogList() {
        
        let currentUserUID = auth.currentUser?.uid ?? "" // Identify user with its ID
        let docPath = db.collection("users").document(currentUserUID).collection("LogsList").order(by: "date", descending: false) // Go through the collection "LogsList" of that user, ordered by date in ascending order.
        
        docPath.getDocuments { [weak self] snapshot, error in // Gets the documents inside the LogsList collection
            
            guard error == nil else {
                // If there's an error, show the alert.
                self?.showAlertWith(title: "Log List Error", description: "Error: \(String(describing: error))")
                return
            }
            
            guard let querySnapshot = snapshot else {
                self?.showAlertWith(title: "Log List Snapshot Error", description: "Snapshot is nil")
                return
            }
            
            var tempLogList = [Log]() // Array of objects
            
            for document in querySnapshot.documents { // foreach loop to iterate logsList
                let documentData = document.data() // .data() is array that contains date, liters, distance, etc.
                let logID = document.documentID // Contains ID of the log
                
                let rawLogData = documentData["date"] as? Timestamp ?? Timestamp(date: Date())
                let logDate = rawLogData.dateValue()
                
                let logLiters = documentData["liters"] as? Float ?? 0
                let logDistance = documentData["distance"] as? Float ?? 0
                let logCost = documentData["cost"] as? Float ?? 0
                let logFuel = documentData["fuel"] as? String ?? ""
                
                let newLog = Log(id: logID, date: logDate, liters: logLiters, distance: logDistance, cost: logCost, fuel: logFuel) // Instance of Log with data
                tempLogList.append(newLog) // Append to array tempLogList
            }
            DispatchQueue.main.async { [weak self] in
                self?.allLogs = tempLogList // allLogs is now tempLogList, which will accessed by the views.
            }
        }
    }

    // Updating Log
    func updateLog(updateLog: Log) {
        let currentUserUID = auth.currentUser?.uid ?? "" // ID of the User
        let docPath = db.collection("users").document(currentUserUID).collection("LogsList") // Path of user's LogsList collection

        // Document with that ID is updated using the Log's data passed to the function.
        docPath.document(updateLog.id).updateData(["date": updateLog.date, "liters": updateLog.liters, "distance": updateLog.distance, "cost": updateLog.cost, "fuel": updateLog.fuel]) {
            [weak self] error in
            
            // If the error is not nil, then show the alert with the error's description.
            guard error == nil else {
                self?.showAlertWith(title: "Error in Updating the Log", description: "Error: \(String(describing: error))")
                return
            }

            self?.showAlertWith(title: "Log Updated Successfully", description: "") // Otherwise, show the log was updated.
            self?.takeLogList() // Retrieves the updated log list.
            self?.backToRootScreen() // Go to home screen.
        }
    }

    // Delete Log
    func deleteUsersLog(selectedLog: Log) {
        let currentUserUID = auth.currentUser?.uid ?? "" // User's ID
        let docPath = db.collection("users").document(currentUserUID).collection("LogsList") // Path of user's LogsList collection
        
        docPath.document(selectedLog.id).delete() { // Delete the log with the selected log's id.
            [weak self] error in
            guard error == nil else { // If there's an error, show the alert with the error.
                self?.showAlertWith(title: "Delete Log Error", description: "Error: \(String(describing: error))")
                return
            }

            self?.allLogs.removeAll(where: { $0.id == selectedLog.id }) // Otherwise, remove the log from the allLogs array
        }
    }

    func checkEmailFields(email: String) -> String {
        let isValidEmail =  email.isValidEmail
        switch isValidEmail {
        case false:
            return "Incorrect Email format"
        case true:
            return ""
        }
    }
    
    // Check fields
    func checkSignInFields(email: String, password: String) -> Bool {
        return password.isValidPassword && email.isValidEmail
    }
    
    func checkSignUpFields(firstName: String, lastName: String, email: String, password: String) -> Bool {
        // Returns a boolean value based on series of "and" conditions which are composed of the boolean value returned
        // by each of the functions and the method associated with the String data type.
        return checkFirstName(firstName: firstName) && checkLastName(lastName: lastName) && password.isValidPassword && email.isValidEmail
    }
    
    func checkFirstName(firstName: String) -> Bool {
        return firstName.count >= 3 // .count -> the number of characters within that string
    }
    
    func checkLastName(lastName: String) -> Bool {
        return lastName.count >= 3
    }

}
