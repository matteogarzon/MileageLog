import SwiftUI

struct EditLogsView: View {
    @EnvironmentObject private var mileageLogVM: MileageLogViewModel
    @Environment(\.dismiss) private var dismiss

    var log: Log?
    @State var logDate = Date()
    @State var logCost = Float()
    @State var logDistance = Float()
    @State var logLiters = Float()
    
    @State var logFuel = String()
    @State private var logFuelOptions = ["GPL", "Petrol"]
    
    var body: some View {
        VStack {
            Label("Edit Log", systemImage: "fuelpump.fill")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            HStack {
                DatePicker(selection: $logDate, displayedComponents: .date, label: { Text("Date") })
            }
            .padding()
            HStack {
                Text("Cost")
                TextField("Cost", value: $logCost, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
            }
            .padding()
            HStack {
                Text("Distance")
                TextField("Distance", value: $logDistance, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
            }
            .padding()
            HStack {
                Text("Liters")
                TextField("Liters", value: $logLiters, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
            }
            .padding()
            HStack {
                Text("Fuel")
                Picker("Type", selection: $logFuel) {
                    ForEach(logFuelOptions, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            Spacer()
            Button("Edit Log") {
                if let log {
                    let newLog = Log(id: log.id, date: logDate, liters: logLiters, distance: logDistance, cost: logCost, fuel: logFuel)
                    mileageLogVM.updateLog(updateLog: newLog)
                }
            }
            .disabled(logCost <= 0 || logCost >= 1000 || logLiters <= 0 || logLiters >= 1000 || logDistance <= 0 || logDistance >= 1000)
            .font(.system(.title3, weight: .medium))
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background((logCost <= 0 || logCost >= 1000 || logLiters <= 0 || logLiters >= 1000 || logDistance <= 0 || logDistance >= 1000) == true ? Color.gray : Color.orange)
            .foregroundColor(.white)
            .mask {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
            }
        }
        .padding()
        .toolbar(content: {
            Button("Dismiss") {
                dismiss()
            }
        })
    }
}
