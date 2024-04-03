//
//  ExpenseSourceView.swift
//  Ryeleigh's Bakery
//
//  Created by Ryeleigh Avila on 4/3/24.
//

import SwiftUI

// View for managing and displaying expense sources
struct ExpenseSourcesView: View {
    @Binding var showExpenseSources: Bool  // Binding for showing expense sources view
    @State private var selectedExpenseSource: ExpenseSource?  // State for tracking selected expense source
    @State private var expenseSources: [ExpenseSource] = {
        // Retrieve expenseSources from UserDefaults/default values if not found
        if let data = UserDefaults.standard.data(forKey: "ExpenseSources"),
           let decodedExpenseSources = try? JSONDecoder().decode([ExpenseSource].self, from: data) {
            return decodedExpenseSources
        } else {
            return [
                // Default expense sources if not found in UserDefaults
                ExpenseSource(name: "Food Cost", amount: 600, notes: "Had to get more dough, bread, breakfast meat and toppings "),
                ExpenseSource(name: "Rent", amount: 1200, notes: "Rent may increase in the next month"),
                ExpenseSource(name: "Cost of supplies", amount: 400, notes: "Had to replenish paper goods and cleaning supplies"),
                ExpenseSource(name: "Labor", amount: 175, notes: "Only had one employee this weekend"),
                ExpenseSource(name: "Maintenance", amount: 100, notes: "Continuous leak in faucet")
            ]
        }
    }()

    @AppStorage("totalSpent") var totalSpent: Double = 0
    @State private var originalTotalSpent: Double = 0  // State for original total spent

    var body: some View {
        NavigationView {
            VStack {
                // List of expense sources
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(expenseSources.indices, id: \.self) { index in
                            Button(action: {
                                if index < expenseSources.count {
                                    selectedExpenseSource = expenseSources[index]  // Select expense source
                                }
                            }) {
                                ExpenseSourceRow(expenseSource: $expenseSources[index])  // Displaying expense source row
                            }
                        }
                        Button(action: addExpenseSource) {
                            Text("Add Expense Source")  // Button to add new expense source for user
                                .font(.system(size: 15))
                                .padding()
                        }
                    }
                    .padding()
                }

                Spacer()

                // Displays total amount spent
                VStack {
                    Text("Total Spent:")
                        .font(.headline)
                    Text("$\(totalSpent, specifier: "%.2f")")
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
            .navigationBarTitle("Expense Sources", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    // Save expenseSources to UserDefaults
                    if let encodedData = try? JSONEncoder().encode(expenseSources) {
                        UserDefaults.standard.set(encodedData, forKey: "ExpenseSources")
                    }
                    showExpenseSources = false  // Dismiss the view for otherwise
                }) {
                    Text("Done")
                        .font(.system(size: 15))
                }
            )
            .sheet(item: $selectedExpenseSource) { expenseSource in
                // Displays expense detail view for selected expense source
                ExpenseDetailView(editedExpenseSource: expenseSources[expenseSources.firstIndex(of: expenseSource) ?? 0]) { updatedExpenseSource in
                    if let index = expenseSources.firstIndex(where: { $0.id == updatedExpenseSource.id }) {
                        expenseSources[index] = updatedExpenseSource
                        updateTotalSpent()  // Updates total spent amount
                    }
                }
            }
            .onAppear {
                originalTotalSpent = totalSpent  // Stores original total spent amount
            }
        }
    }

    // Function to add a new expense source
    func addExpenseSource() {
        expenseSources.append(ExpenseSource(name: "", amount: 0, notes: ""))  // Add new expense source to the list
    }

    // Function to update the total spent amount
    private func updateTotalSpent() {
        totalSpent = expenseSources.reduce(0) { $0 + $1.amount }  // Calculate total spent based on expense sources
    }

    // Function to get the total spent amount
    public func GetTotal() -> Double {
        return totalSpent  // Return the total spent amount
    }
}

// View for displaying an expense source row
struct ExpenseSourceRow: View {
    @Binding var expenseSource: ExpenseSource  // Binding for the expense source

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Expense Source", text: $expenseSource.name)  // Text field for editing expense source name
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title3)
                .foregroundColor(.red)

            TextField("Notes", text: $expenseSource.notes)  // Text field for editing expense source notes
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 10))
                .padding(.vertical, 8)

            HStack {
                Text("Current Amount:")
                    .font(.system(size: 20))
                    .foregroundColor(.cyan)
                Spacer()
                TextField("Amount", value: $expenseSource.amount, formatter: NumberFormatter())  // Text field for editing expense amount
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


struct ExpenseSource: Identifiable, Hashable, Codable {
    var id = UUID()  // Unique identifier for each expense source
    var name: String
    var amount: Double  // Amount spent on the expense source
    var notes: String  // Additional notes or details about the expense source
}

// View for editing expense source details
struct ExpenseDetailView: View {
    @State var editedExpenseSource: ExpenseSource  // State for tracking edited expense source
    var onSave: (ExpenseSource) -> Void  // Closure to handle saving changes
    @Environment(\.presentationMode) var presentationMode  // Environment variable to manage presentation mode!

    var body: some View {
        VStack {
            Text("Expense Detail View")
                .font(.headline)
                .padding()
            // Displays the details of the selected expense source
            TextField("Name", text: $editedExpenseSource.name)  // Text field for editing expense sources name
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 13))
                .padding()
            TextField("Amount", value: $editedExpenseSource.amount, formatter: NumberFormatter ())  // Text field for editing expense amount
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 13))
                .padding()
            TextField("Notes", text: $editedExpenseSource.notes)  // Text field for editing expense source notes
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 13))
                .padding()
            
            Button(action: {
                onSave(editedExpenseSource)
                presentationMode.wrappedValue.dismiss()  // Dismiss the detail view
            }) {
                Text("Done")
                    .font(.system(size: 15))
            }
            .padding()
        }
    }

    // ExpenseDetailView with an edited expense source/onSave closure 
    init(editedExpenseSource: ExpenseSource, onSave: @escaping (ExpenseSource) -> Void) {
        self._editedExpenseSource = State(initialValue: editedExpenseSource)
        self.onSave = onSave
    }
}





