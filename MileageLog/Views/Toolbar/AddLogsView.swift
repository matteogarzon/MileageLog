import SwiftUI

struct AddLogsView: View {
    @EnvironmentObject private var mileageLogVM: MileageLogViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var logDate = Date()
    @State private var logCost = Float()
    @State private var logDistance = Float()
    @State private var logLiters = Float()
    
    @State private var logFuel = "GPL"
    @State private var logFuelOptions = ["GPL", "Petrol"]
    
    var body: some View {
        
        VStack {
            Label("Add Log", systemImage: "fuelpump.fill")
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
            Button("Add Log") {
                // let logDate 
                mileageLogVM.addNewLog(logDate: logDate, logLiters: logLiters, logDistance: logDistance, logCost: logCost, logFuel: logFuel)
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
    }
}

struct AddLogsView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogsView()
    }
}
