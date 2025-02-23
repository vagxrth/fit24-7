//
//  HistoricDataView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 08/02/25.
//

import SwiftUI
import Charts

struct ChartsView: View {
    
    @StateObject var viewModel = ChartsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    switch viewModel.selectedChart {
                    case .oneWeek:
                        VStack {
                            ChartDataView(average: $viewModel.oneWeekAverage, total: $viewModel.oneWeekTotal)
                            
                            Chart {
                                ForEach(viewModel.oneWeekChartData) { data in
                                    BarMark(x: .value("Day", data.date, unit: .day), y: .value("Steps", data.count))
                                }
                            }
                        }
                    case .oneMonth:
                        VStack {
                            ChartDataView(average: $viewModel.oneMonthAverage, total: $viewModel.oneMonthTotal)
                            
                            Chart {
                                ForEach(viewModel.oneMonthChartData) { data in
                                    BarMark(x: .value("Day", data.date, unit: .day), y: .value("Steps", data.count))
                                }
                            }
                        }
                    case .oneYear:
                        VStack {
                            ChartDataView(average: $viewModel.oneYearAverage, total: $viewModel.oneYearTotal)
                            
                            Chart {
                                ForEach(viewModel.oneYearChartData) { data in
                                    BarMark(x: .value("Month", data.date, unit: .month), y: .value("Steps", data.count))
                                }
                            }
                        }
                    default:
                        EmptyView() // Fallback in case of unexpected state
                    }
                }
            }
            .foregroundColor(.blue)
            .frame(maxHeight: 450)
            .padding(.horizontal)
            
            HStack {
                ForEach([ChartOptions.oneWeek, ChartOptions.oneMonth, ChartOptions.oneYear], id: \.rawValue) { option in
                    Button(option.rawValue) {
                        withAnimation {
                            viewModel.selectedChart = option
                        }
                    }
                    .padding()
                    .foregroundColor(viewModel.selectedChart == option ? .white : .green)
                    .background(viewModel.selectedChart == option ? .green : .clear)
                    .cornerRadius(10)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationTitle(FitnessTabs.charts.rawValue)
        .padding(.top)
        .alert("Oops", isPresented: $viewModel.showAlert) {
            Button(role: .cancel) {
                viewModel.showAlert = false
            } label: {
                Text("Ok")
            }
        } message: {
            Text("Error Fetching Data!")
        }
    }
}

#Preview {
    ChartsView()
}
