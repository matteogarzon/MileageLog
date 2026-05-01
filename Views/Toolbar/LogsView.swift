import SwiftUI

struct LogsView: View {
    @EnvironmentObject private var mileageLogVM: MileageLogViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if mileageLogVM.allLogs.count == 0 { // if array is 0, then...
                    Text("Add your first log!")
                }
                else {
                    List {
                        ForEach(mileageLogVM.allLogs, id: \.id) { log in // iterates through the Logs array
                            NavigationLink(value: log) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 0.6) {
                                        Text("\(Int(log.cost))") + Text(" €")
                                            .bold()
                                        Text("\(Int(log.distance))") + Text(" km")
                                    }
                                    Spacer()
                                    Text("\(log.date, formatter: mileageLogVM.formatDate)")
                                }
                            }
                        }
                        .onDelete(perform: deleteLog(at:))
                    }
                }
            }.navigationTitle("Mileage Log")
            .toolbar(content: {
                ToolbarItem() {
                    NavigationLink(value: "add") {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                ToolbarItem() {
                    NavigationLink(value: "setting") { // NavigationLink is used for navigationDestination
                        Image(systemName: "gear")
                    }
                }
            })
        }
    }
    
    private func deleteLog(at offsets: IndexSet) { // IndexSet -> type to represent set of integer indices
        let selectedLog = offsets.map { index in // Create an array
            self.mileageLogVM.allLogs[index]
        }
        
        if selectedLog.count == 1 { // Can perform deletion when the array has one item!
            mileageLogVM.deleteUsersLog(selectedLog: selectedLog[0])
        }
    }
    
    struct LogsView_Previews: PreviewProvider {
        static var previews: some View {
            LogsView()
        }
    }
}
