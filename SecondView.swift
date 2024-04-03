//
//  SecondView.swift
//  Ryeleigh's Bakery
//
//  Created by Ryeleigh Avila
//

import SwiftUI

// Define a new SwiftUI view called SecondView
struct SecondView: View {
    // Define state variables to track the loading status of income and expense images/my screen presentation
    @State private var incomeImageLoaded = false
    @State private var expenseImageLoaded = false
    @State private var showIncomeSources = false
    @State private var showExpenseSources = false
    @State var IncomeView: IncomeSourcesView? // Optional IncomeSourcesView
    @State var ExpenseView: ExpenseSourcesView? // Optional ExpenseSourcesView

    // definition of body
    var body: some View {
        NavigationView {
            ZStack {
                // Define a linear gradient background that I customed
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.pink.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all) // Ignore safe area for full-screen background

                VStack {
                    // Title for the view
                    Text("Current Profit/Loss Percentage")
                        .font(.headline)
                        .padding()
                        .offset(y: -180)

                    // Displaying calculated profit/loss percentage from my pulled sources
                    Text("**So far Profit/loss percentage is approximately \(calculateProfitPct())%**")
                        .foregroundColor(profitTextColor()) // Set text color dynamically based on profit/loss
                        .font(.system(size: 15))
                        .offset(y: -178)

                    // Instruction for the user for their profit calculation!
                    Text("**Press the blue arrow above while I load profit/Loss :)**")
                        .foregroundColor(.blue) // Set text color to blue
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .offset(y: -135)

                    // Placeholder image requirment 1 (image within my computer)
                    Image("scale")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .offset(y: -130)
                        .padding()

                    // Display income related content
                    VStack {
                        if incomeImageLoaded {
                            // Display income-related content once image is loaded
                            VStack {
                                // AsyncImage for income (Async 1)
                                AsyncImage(url: URL(string: "https://www.flyingsolo.com.au/wp-content/uploads/2022/02/passive-income-cartoon.jpg")!) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 153, height: 85)
                                    case .failure:
                                        Text("Failed to load image")
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .offset(y: -150)

                                // Button to view and modify income sources
                                Button(action: {
                                    showIncomeSources = true
                                }) {
                                    HStack {
                                        Text("View and Modify Income")
                                            .font(.system(size: 14))
                                        Image(systemName: "dollarsign.circle")
                                            .font(.system(size: 14))
                                    }
                                }
                                .offset(y: -140)
                                .sheet(isPresented: $showIncomeSources) {
                                    NavigationView {
                                        IncomeView
                                    }
                                }
                            }
                        } else {
                            // Showing progress view while loading income content
                            ProgressView()
                                .onAppear {
                                    // Simulate delay for loading
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        incomeImageLoaded = true
                                        IncomeView = IncomeSourcesView(showIncomeSources: $showIncomeSources)
                                    }
                                }
                        }
                    }

                    // Display expense related content
                    VStack {
                        if expenseImageLoaded {
                            // Display expense-related content once image is loaded
                            VStack {
                                // AsyncImage for expenses (Async 2)!
                                AsyncImage(url: URL(string: "https://bookkeepers.com/wp-content/uploads/2020/01/monthly-expenses-planning-checklist-receipts-wallet-how-to-stick-to-a-budget-ss-featured.jpg.webp")!) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 146, height: 150)
                                    case .failure:
                                        Text("Failed to load image")
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .offset(y: -150)

                                // Button to view and modify expense sources
                                Button(action: {
                                    showExpenseSources = true
                                }) {
                                    HStack {
                                        Text("View and Modify Expense")
                                            .font(.system(size: 14))
                                        Image(systemName: "exclamationmark.triangle")
                                            .font(.system(size: 14))
                                    }
                                }
                                .offset(y: -172)
                                .sheet(isPresented: $showExpenseSources) {
                                    ExpenseView
                                }
                            }
                        } else {
                            // Showing progress view while loading expense content
                            ProgressView()
                                .onAppear {
                                    // Simulation delay for loading
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        expenseImageLoaded = true
                                        ExpenseView = ExpenseSourcesView(showExpenseSources: $showExpenseSources)
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("Utilities") // Navigation title
            .font(.system(size: 60)) 
            .fontWeight(.bold)
        }
    }

    // Function to calculate profit/loss percentage
    func calculateProfitPct() -> Double {
        let income = IncomeView?.GetTotal() ?? 0
        let expenses = ExpenseView?.GetTotal() ?? 0
        let profit = income - expenses
        var profitPct: Double = 0

        if income != 0 {
            profitPct = (profit / income) * 100
        }
        return profitPct
    }

    // Function to determine text color based on profit/loss
    func profitTextColor() -> Color {
        let profitPct = calculateProfitPct()
        if profitPct < 0 {
            return .red // Negative profit/loss percentage text color
        } else if profitPct == 0 {
            return .blue // Zero profit/loss percentage text color
        } else {
            return .green // Positive profit/loss percentage text color
        }
    }
}
