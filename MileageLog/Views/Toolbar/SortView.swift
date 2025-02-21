import SwiftUI

struct SortView: View {
    @EnvironmentObject private var mileageLogVM: MileageLogViewModel
    @State var tempArray = [Log]()
    
    @State private var sortFuel = "GPL" // Picker selection
    @State private var sortFuelOptions = ["GPL", "Petrol"] // Picker options
    
    @State private var sortCriteria = "Price" // Picker selection
    @State private var sortCriteriaOptions = ["Price", "Distance", "Liters"] // Picker options
    
    @State private var sortOrder = "Ascending" // Picker selection
    @State private var sortOrderOptions = ["Ascending", "Descending"] // Picker options
    @State private var sortedLogArray = [Log]() // Not defined length
    @State private var sortShow = true
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Criteria", selection: $sortCriteria) {
                    ForEach(sortCriteriaOptions, id: \.self) { criteria in
                        Text(criteria)
                    }
                }
                .pickerStyle(.segmented)
                Picker("Fuel", selection: $sortFuel) {
                    ForEach(sortFuelOptions, id: \.self) { fuel in
                        Text(fuel)
                    }
                }
                .pickerStyle(.segmented)
                Picker("Order", selection: $sortOrder) {
                    ForEach(sortOrderOptions, id: \.self) { order in
                        Text(order)
                    }
                }
                .pickerStyle(.segmented)
                Button {
                    tempArray = [Log]() // Array for specific fuel.
                    for log in mileageLogVM.allLogs { // Iterating through array
                        if log.fuel == "GPL" && sortFuel == "GPL" { // If log's fuel and fuel selected are the same (GPL)...
                            tempArray.append(log) // ...append them
                        }
                        else if log.fuel == "Petrol" && sortFuel == "Petrol" { // (Petrol)
                            tempArray.append(log)
                        }
                    }
                    sortedLogArray = mergeSort(tempArray, sortOrder, sortCriteria)
                } label: {
                    Text("Sort")
                        .font(.system(.title3, weight: .medium))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .mask {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                        }
                }
                List {
                    if (tempArray.count == 0) {
                        Text("No logs sorted.")
                    }
                    else {
                        ForEach(sortedLogArray, id: \.id) { log in
                            HStack {
                                VStack(alignment: .leading, spacing: 0.6) {
                                    Text("\(Int(log.cost))") + Text(" €")
                                        .bold()
                                    if (sortCriteria == "Distance" || sortCriteria == "Price") {
                                        Text("\(Int(log.distance))") + Text(" km")
                                    }
                                    else if (sortCriteria == "Liters") {
                                        Text("\(Int(log.liters))") + Text(" l")
                                    }
                                }
                                Spacer()
                                Text("\(log.date, formatter: mileageLogVM.formatDate)")
                            }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding()
            .navigationTitle("Sort")
        }
    }
    
    // "_ array" means that when calling the function, you just pass the parameter, without writing the name "array".
    // instead of mergeSort(array: ...) -> mergeSort(...)
    private func mergeSort(_ array: [Log], _ order: String, _ criteria : String) -> [Log] { // Return the orderded array of Log objects.
        guard array.count > 1 else { // If array has size 1, then it's already ordered!
            return array
        }
        
        let middle = array.count / 2 // It's always going to be int (whole number)
        
        // Recursive call until array is of size 1
        let left = mergeSort(Array(array[0..<middle]), order, criteria) // passed array from index 0 to middle (exclusive)
        let right = mergeSort(Array(array[middle..<array.count]), order, criteria) // middle to final index (exclusive)
        
        return merge(left, right, order, criteria)
    }
    
    private func merge(_ left: [Log], _ right: [Log], _ order: String, _ criteria : String) -> [Log] { // Returns an array of Log objects.
        var leftInd = 0
        var rightInd = 0
        var result = [Log]()
        
        // Capacity that we need -> sum of the two array sizes -> efficiency
        result.reserveCapacity(left.count + right.count)
        
        while leftInd < left.count && rightInd < right.count {
            if order == "Ascending" { // Order based on the order
                if criteria == "Distance" { // Order based on the criteria too
                    if left[leftInd].distance < right[rightInd].distance { // If element of left index bigger than right, append the left (i.e., the smaller element)
                        leftAppend(&result, left, &leftInd)
                    }
                    else if left[leftInd].distance > right[rightInd].distance {
                        rightAppend(&result, right, &rightInd)
                    }
                    else { // Values are equal -> Append both
                        equalAppend(&result, left, right, &leftInd, &rightInd)
                    }
                }
                else if criteria == "Price" {
                    if left[leftInd].cost < right[rightInd].cost {
                        leftAppend(&result, left, &leftInd)
                    }
                    else if left[leftInd].cost > right[rightInd].cost {
                        rightAppend(&result, right, &rightInd)
                    }
                    else { // Values are equal ->
                        equalAppend(&result, left, right, &leftInd, &rightInd)
                    }
                }
                else if criteria == "Liters" {
                    if left[leftInd].liters < right[rightInd].liters {
                        leftAppend(&result, left, &leftInd)
                    }
                    else if left[leftInd].liters > right[rightInd].liters {
                        rightAppend(&result, right, &rightInd)
                    }
                    else { // Values are equal ->
                        equalAppend(&result, left, right, &leftInd, &rightInd)
                    }
                }
            }
            else { // Descending
                if criteria == "Distance" {
                    if left[leftInd].distance > right[rightInd].distance {
                        leftAppend(&result, left, &leftInd)
                    }
                    else if left[leftInd].distance < right[rightInd].distance {
                        rightAppend(&result, right, &rightInd)
                    }
                    else { // Values are equal ->
                        equalAppend(&result, left, right, &leftInd, &rightInd)
                    }
                }
                else if criteria == "Price" {
                    if left[leftInd].cost > right[rightInd].cost {
                        leftAppend(&result, left, &leftInd)
                    }
                    else if left[leftInd].cost < right[rightInd].cost {
                        rightAppend(&result, right, &rightInd)
                    }
                    else { // Values are equal ->
                        equalAppend(&result, left, right, &leftInd, &rightInd)
                    }
                }
                else if criteria == "Liters" {
                    if left[leftInd].liters > right[rightInd].liters {
                        leftAppend(&result, left, &leftInd)
                    }
                    else if left[leftInd].liters < right[rightInd].liters {
                        rightAppend(&result, right, &rightInd)
                    }
                    else { // Values are equal ->
                        equalAppend(&result, left, right, &leftInd, &rightInd)
                    }
                }
            }
        }
        
        // Edge Cases
        while leftInd < left.count {
            result.append(left[leftInd])
            leftInd += 1
        }
        while rightInd < right.count {
            result.append(right[rightInd])
            rightInd += 1
        }
        
        return result
    }
    
    // Append Log to array
    // inout -> passing by reference
    private func leftAppend(_ result: inout [Log], _ left: [Log], _ leftInd: inout Int) {
        result.append(left[leftInd]) // Append the left item
        leftInd += 1 // Increase left index
    }
    
    private func rightAppend(_ result: inout [Log], _ right : [Log], _ rightInd : inout Int) {
        result.append(right[rightInd]) // Append right item
        rightInd += 1 // Increase right index
    }
    
    // Since they are equal, both are appended to the array and both indexes are increased.
    private func equalAppend(_ result: inout [Log], _ left: [Log], _ right : [Log], _ leftInd: inout Int, _ rightInd : inout Int) {
        result.append(left[leftInd])
        leftInd += 1
        result.append(right[rightInd])
        rightInd += 1
    }
}
