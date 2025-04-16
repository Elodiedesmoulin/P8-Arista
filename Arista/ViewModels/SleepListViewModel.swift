//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

class SleepListViewModel: ObservableObject {
    @Published var sleepSessions: [Sleep] = []
    @Published var error: AppError? = nil

    private let sleepRepository: SleepRepository

    init(sleepRepository: SleepRepository) {
        self.sleepRepository = sleepRepository
        fetchSleepData()
    }

    func fetchSleepData() {
        do {
            sleepSessions = try sleepRepository.fetchAllSleepSessions()
        } catch {
            self.error = .repositoryError(error.localizedDescription)
        }
    }
}
