//
//  HistoricDataView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 08/02/25.
//

import SwiftUI
import Charts

struct DailyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

struct MonthlyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

enum ChartOptions: String, CaseIterable {
    case oneWeek = "1W"
    case oneMonth = "1M"
    case threeMonth = "3M"
    case oneYear = "1Y"
    case yearToDate = "YTD"
}

class ChartsViewModel: ObservableObject {
    var mockWeekChartData = [
        DailyStepModel(date: Date(), count: 6400),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), count: 9740),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), count: 6500),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), count: 10300),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), count: 7225),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), count: 8278),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(), count: 3453)
    ]
    
    var mockMonthChartData = [
        MonthlyStepModel(date: Date(), count: 6400),
        MonthlyStepModel(date: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(), count: 9740),
        MonthlyStepModel(date: Calendar.current.date(byAdding: .month, value: -2, to: Date()) ?? Date(), count: 6500),
    ]
    
    @Published var oneWeekAverage = 383
    @Published var oneWeekTotal = 2345
    
    @Published var mockOneMonthData = [DailyStepModel]()
    @Published var oneMonthAverage = 0
    @Published var oneMonthTotal = 0

    @Published var mockThreeMonthsData = [DailyStepModel]()
    @Published var threeMonthAverage = 0
    @Published var threeMonthTotal = 0
    
    @Published var oneYearAverage = 0
    @Published var oneYearTotal = 0

    @Published var ytdAverage = 0
    @Published var ytdTotal = 0
    
    init() {
        let mockOneMonth = mockDataForDays(days: 30)
        let mockThreeMonths = mockDataForDays(days: 90)
        DispatchQueue.main.async {
            self.mockOneMonthData = mockOneMonth
            self.mockThreeMonthsData = mockThreeMonths
        }
    }
    
    func mockDataForDays(days: Int) -> [DailyStepModel] {
        var mockData = [DailyStepModel]()
        for day in 0..<days {
            let currentDate = Calendar.current.date(byAdding: .day, value: -day, to: Date()) ?? Date()
            let randomStepCount = Int.random(in: 3000...12000)
            let dailyStepData = DailyStepModel(date: currentDate, count: randomStepCount)
            
            mockData.append(dailyStepData)
        }
        return mockData
    }
    
}

struct ChartsView: View {
    
    @StateObject var viewModel = ChartsViewModel()
    @State var selectedChart: ChartOptions = .oneWeek
    
    var body: some View {
        VStack {
            Text("Charts")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            ZStack {
                switch selectedChart {
                case .oneWeek:
                    VStack {
                        HStack {
                            Spacer()
                            
                            VStack(spacing: 16) {
                                Text("Average")
                                    .font(.title2)
                                Text("\(viewModel.oneWeekAverage)")
                                    .font(.title3)
                            }
                            .frame(width: 90)
                            .padding()
                            .background(.gray.opacity(0.1))
                            .cornerRadius(10)
                            
                            Spacer()
                            
                            VStack(spacing: 16) {
                                Text("Total")
                                    .font(.title2)
                                Text("\(viewModel.oneWeekTotal)")
                                    .font(.title3)
                            }
                            .frame(width: 90)
                            .padding()
                            .background(.gray.opacity(0.1))
                            .cornerRadius(10)
                            
                            Spacer()
                        }
                        Chart {
                            ForEach(viewModel.mockWeekChartData) {
                                data in BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                            }
                        }
                    }
                case .oneMonth:
                    Chart {
                        ForEach(viewModel.mockOneMonthData) {
                            data in BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                        }
                    }
                case .threeMonth:
                    Chart {
                        ForEach(viewModel.mockThreeMonthsData) {
                            data in BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                        }
                    }
                case .oneYear:
                    Chart {
                        ForEach(viewModel.mockMonthChartData) {
                            data in BarMark(x: .value(data.date.formatted(), data.date, unit: .month), y: .value("Steps", data.count))
                        }
                    }
                case .yearToDate:
                    Chart {
                        ForEach(viewModel.mockMonthChartData) {
                            data in BarMark(x: .value(data.date.formatted(), data.date, unit: .month), y: .value("Steps", data.count))
                        }
                    }
                }
            }
            .frame(maxHeight: 400)
            .padding(.horizontal)
            
            HStack {
                ForEach(ChartOptions.allCases, id: \.rawValue) {
                    option in Button(option.rawValue) {
                        withAnimation{
                            selectedChart = option
                        }
                    }
                    .padding()
                    .foregroundColor(selectedChart == option ? .white : .blue)
                    .background(selectedChart == option ? .blue : .clear)
                    .cornerRadius(10)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    ChartsView()
}
