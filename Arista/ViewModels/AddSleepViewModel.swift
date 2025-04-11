//
//  AddSleepSessionViewModel.swift
//  Arista
//
//  Created by Elo on 31/03/2025.
//


import Foundation

class AddSleepViewModel: ObservableObject {
    @Published var startTime: String = ""
    @Published var duration: String = ""
    @Published var quality: String = ""
    @Published var createdSleep: Sleep?
    @Published var error: AppError? = nil

    private let sleepRepository: SleepRepository
    private let userRepository: UserRepository

    init(sleepRepository: SleepRepository, userRepository: UserRepository) {
        self.sleepRepository = sleepRepository
        self.userRepository = userRepository
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        self.startTime = formatter.string(from: Date())
    }
    
    func addSleep() -> Bool {
        guard let durationInt = Int16(duration) else {
            self.error = .invalidDuration
            return false
        }
        guard let qualityInt = Int16(quality) else {
            self.error = .invalidQuality
            return false
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        guard let parsedDate = formatter.date(from: startTime) else {
            self.error = .invalidStartTime
            return false
        }
        
        do {
            guard let user = try userRepository.fetchSingleUser() else {
                self.error = .userNotFound
                return false
            }
            let newSleep = try sleepRepository.createSleepSession(startDate: parsedDate, duration: durationInt, quality: qualityInt, user: user)
            self.createdSleep = newSleep
            return true
        } catch {
            self.error = .repositoryError(error.localizedDescription)
            return false
        }
    }
}
