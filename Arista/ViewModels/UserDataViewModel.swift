//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

class UserDataViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        fetchUser()
    }

    private func fetchUser() {
        do {
            if let user = try userRepository.fetchSingleUser() {
                firstName = user.firstName ?? ""
                lastName = user.lastName ?? ""
                email = user.email ?? ""
                password = user.password ?? ""
            }
        } catch {
            print("Error fetching single user: \(error)")
        }
    }
}
