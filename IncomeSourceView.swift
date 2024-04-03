//
//  IncomeSourceView.swift
//  Ryeleigh's Bakery
//
//  Created by Ryeleigh Avila on 4/3/24.
//

import SwiftUI

// Definition a SwiftUI view for managing income sources!
struct IncomeSourcesView: View {
    // Binding to control for visibility of income sources view
    @Binding var showIncomeSources: Bool
    
    // State variables to track selected income source/detail view visibility/income sources list
    @State private var selectedIncomeSource: IncomeSource?
    @State private var isShowingDetailView = false
    @State private var incomeSources: [IncomeSource] = {
        // Initialize incomeSources with default values
        if let data = UserDefaults.standard.data(forKey: "IncomeSources"),
           let decodedIncomeSources = try? JSONDecoder().decode([IncomeSource].self, from: data) {
            return decodedIncomeSources
        } else {
            return [
                IncomeSource(name: "Meal kit", amount: 150, notes: "Great kick off start to these kits! yum!!!"),
                IncomeSource(name: "Gift cards", amount: 200, notes: "Sold less than what expected :("),
                IncomeSource(name: "Mobile Orders", amount: 500, notes: "To go orders are doing better than walk-in at the moment!"),
                IncomeSource(name: "Catering", amount: 200, notes: "Had a couple of school events this month"),
                IncomeSource(name: "Sales", amount: 2000, notes: "Average month!")
            ]
        }
    }()

    // Computes the total amount from incomeSources array
    public var totalAmount: Double {
        incomeSources.reduce(0) { $0 + $1.amount }
    }
    
    // Function to get the total amount
    public func  GetTotal() -> Double {
        return totalAmount
    }

    
    var body: some View {
        NavigationView {
            VStack {
                // List of income sources
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(incomeSources.indices, id: \.self) { index in
                            // Button for each income source to show detail view
                            Button(action: {
                                if index < incomeSources.count {
                                    selectedIncomeSource = incomeSources[index]
                                    isShowingDetailView = true
                                }
                            }) {
                                IncomeSourceRow(incomeSource: $incomeSources[index])
                            }
                        }
                        // Button to add a new income source
                        Button(action: addIncomeSource) {
                            Text("Add Income Source")
                                .font(.system(size: 15))
                                .padding()
                        }
                    }
                    .padding()
                }

                Spacer()

                // Display total amount in a small box
                VStack {
                    Text("Total Earned:")
                        .font(.headline)
                    Text("$\(totalAmount, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
            }
        }
        .navigationBarTitle("Income Sources", displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                // Saves incomeSources
                if let encodedData = try? JSONEncoder().encode(incomeSources) {
                    UserDefaults.standard.set(encodedData, forKey: "IncomeSources")
                }
                showIncomeSources = false
            }) {
                Text("Done")
                    .font(.system(size: 15))
            }
        )
        // when isShowingDetailView is true
        .sheet(isPresented: $isShowingDetailView) {
            if let selectedIncomeSource = selectedIncomeSource {
                IncomeDetailView(editedIncomeSource: selectedIncomeSource) { updatedIncomeSource in
                    if let index = incomeSources.firstIndex(where: { $0.id == updatedIncomeSource.id }) {
                        incomeSources[index] = updatedIncomeSource
                    }
                }
            }
        }
    }

    // Function to add a new income source
    func addIncomeSource() {
        let newIncomeSource = IncomeSource(name: "", amount: 0, notes: "")
        incomeSources.append(newIncomeSource)
        selectedIncomeSource = newIncomeSource
        isShowingDetailView = true
    }
}

// Defining a view for displaying an income source row
struct IncomeSourceRow: View {
    @Binding var incomeSource: IncomeSource

    var body: some View {
        VStack(alignment: .leading) {
            // Text field for income source name
            TextField("Income Source", text: $incomeSource.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title3)
                .foregroundColor(.red)

            // Text field for income source notes
            TextField("Notes", text: $incomeSource.notes)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 10))
                .padding(.vertical, 8)

            // HStack for displaying current amount and text field for editing amount
            HStack {
                Text("Current Amount:")
                    .font(.system(size: 20))
                    .foregroundColor(.cyan)
                Spacer()
                TextField("Amount", value: $incomeSource.amount, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 15))
                    .frame(width: 60)
                Text("$")
                    .font(.system(size: 12))
                    .foregroundColor(.black)
            }
        }
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 2).foregroundColor(Color(UIColor.systemGray6)))
        .padding(.horizontal)
    }
}

// Define a structure for representing an income source
struct IncomeSource: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var amount: Double
    var notes: String
}

// Define a view for editing income source details
struct IncomeDetailView: View {
    @State var editedIncomeSource: IncomeSource
    var onSave: (IncomeSource) -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Income Detail View")
                .font(.headline)
                .padding()
            // Text fields for editing income source details
            TextField("Name", text: $editedIncomeSource.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 13))
                .padding()
            TextField("Amount", value: $editedIncomeSource.amount, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 13))
                .padding()
            TextField("Notes", text: $editedIncomeSource.notes)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 13))
                .padding()
            
            // Button to save changes and dismiss the view
            Button(action: {
                onSave(editedIncomeSource)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .font(.system(size: 15))
            }
            .padding()
        }
    }

    // Initialize the view with initial income source data and onSave closure
    init(editedIncomeSource: IncomeSource, onSave: @escaping (IncomeSource) -> Void) {
        self._editedIncomeSource = State(initialValue: editedIncomeSource)
        self.onSave = onSave
    }
}
