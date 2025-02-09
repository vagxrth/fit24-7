//
//  ChartsViewModel.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 09/02/25.
//

import Foundation

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
    @Published var oneMonthAverage = 5533
    @Published var oneMonthTotal = 155000

    @Published var mockThreeMonthsData = [DailyStepModel]()
    @Published var threeMonthAverage = 2344
    @Published var threeMonthTotal = 80030
    
    @Published var oneYearAverage = 22233
    @Published var oneYearTotal = 833443

    @Published var ytdAverage = 34213
    @Published var ytdTotal = 132324
    
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
