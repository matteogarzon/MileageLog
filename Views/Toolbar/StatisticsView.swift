import Foundation
import SwiftUI

struct StatisticsView: View {
    
    @EnvironmentObject private var mileageLogVM: MileageLogViewModel
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var isDatePossible = Bool()
    
    // columns -> GPL, and Petrol
    // rows -> [distance, price, liters]
    @State private var statArray : [[Float]] = [[0, 0, 0], [0, 0, 0]]  // Two dimensional array,
    @State private var statAvgGPL = "0"
    @State private var statAvgPetrol = "0"
    @State private var statEnabled = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Section {
                        DatePicker(
                            "Start Date",
                            selection: $startDate,
                            displayedComponents: [.date]
                        ).onChange(of: startDate) { newDate in
                            statEnabled = false
                        }
                        DatePicker(
                            "End Date",
                            selection: $endDate,
                            displayedComponents: [.date]
                        ).onChange(of: endDate) { newDate in
                            statEnabled = false
                        }
                        Button {
                            calculateDate(startDate: startDate, endDate: endDate, isDatePossible: isDatePossible)
                        } label: {
                            Text("Calculate")
                                .font(.system(.title3, weight: .medium))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .mask {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                }
                        }
                    }
                    Divider()
                        .padding()
                    if statEnabled {
                        VStack(spacing: 10) {
                            CardView(statTitle: "Distance", statGPL: "GPL: \(statArray[0][0]) km", statPetrol: "Petrol: \(statArray[1][0]) km", statIcon: "location.fill")
                            CardView(statTitle: "Price", statGPL: "GPL: \(statArray[0][1]) €", statPetrol: "Petrol: \(statArray[1][1]) €", statIcon: "creditcard.fill")
                            CardView(statTitle: "Liters", statGPL: "GPL: \(statArray[0][2]) €", statPetrol: "Petrol: \(statArray[1][2]) l", statIcon: "drop.fill")
                            CardView(statTitle: "Average", statGPL: "GPL: \(statAvgGPL) km/l", statPetrol: "Petrol: \(statAvgPetrol) km/l", statIcon: "chart.line.uptrend.xyaxis")
                        }
                    }
                }.padding()
                    .navigationTitle("Statistics")
            }
        }
    }
    
    private func calculateDate(startDate: Date, endDate: Date, isDatePossible: Bool) {
        let numberFormatter = NumberFormatter() // To round the average cost per litre to 2 decimal places.
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        
        if (mileageLogVM.allLogs.count == 0) { // If allLogs array has size 0:
            mileageLogVM.showAlertWith(title: "Insert your first log.", description: "")
        }
        else {
            if (startDate < endDate || startDate == endDate) { // Check input validity.
                // Each time user clicks on the statistics button, values in the array are set to zero for new calculations.
                for i in (0...1) { // Looping through rows
                    for j in (0...2) { // Looping through columns
                        statArray[i][j] = 0
                    }
                }
                for log in mileageLogVM.allLogs {
                    if (log.date >= startDate && log.date <= endDate) { // Date is within the range chosen.
                        // [distance, cost, liters]
                        if (log.fuel == "GPL") {
                            statArray[0][0] = statArray[0][0] + log.distance
                            statArray[0][1] = statArray[0][1] + log.cost
                            statArray[0][2] = statArray[0][2] + log.liters
                        }
                        else if (log.fuel == "Petrol") {
                            statArray[1][0] = statArray[1][0] + log.distance
                            statArray[1][1] = statArray[1][1] + log.cost
                            statArray[1][2] = statArray[1][2] + log.liters
                        }
                    }
                }
                if (statArray[0][0] == 0 && statArray[1][0] == 0) { // i.e., there are no logs.
                    mileageLogVM.showAlertWith(title: "There are no logs during this time interval.", description: "")
                }
                else if (statArray[0][0] != 0 && statArray[1][0] != 0) { // There are non-zero values for both fuels
                    statAvgGPL = numberFormatter.string(from: NSNumber(value: (statArray[0][0] / statArray[0][2]))) ?? "0"
                    statAvgPetrol = numberFormatter.string(from: NSNumber(value: (statArray[1][0] / statArray[1][2]))) ?? "0"
                    statEnabled = true
                }
                else if (statArray[0][0] != 0) { // Non-zero values for GPL only
                    statAvgGPL = numberFormatter.string(from: NSNumber(value: (statArray[0][0] / statArray[0][2]))) ?? "0" // ? "0" is default value, required for Swift's syntax
                    statAvgPetrol = "0"
                    statEnabled = true
                }
                else if (statArray[1][0] != 0) { // Non-zero values for Petro only
                    statAvgPetrol = numberFormatter.string(from: NSNumber(value: (statArray[1][0] / statArray[1][2]))) ?? "0"
                    statAvgGPL = "0"
                    statEnabled = true
                }
            }
            else if (startDate > endDate) {
                mileageLogVM.showAlertWith(title: "Choose correct dates.", description: "")
            }
            else {
                mileageLogVM.showAlertWith(title: "Something went wrong, try again.", description: "")
            }
        }
    }
}
