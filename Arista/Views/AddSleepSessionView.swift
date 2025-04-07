//
//  AddSleepSessionView.swift
//  Arista
//
//  Created by Elo on 31/03/2025.
//


import SwiftUI

struct AddSleepSessionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddSleepSessionViewModel
    var onSleepAdded: (() -> Void)?

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Start Time (MM/dd/yyyy HH:mm)", text: $viewModel.startTime)
                        .keyboardType(.numbersAndPunctuation)
                    TextField("Duration (minutes)", text: $viewModel.duration)
                        .keyboardType(.numberPad)
                    TextField("Quality (0-10)", text: $viewModel.quality)
                        .keyboardType(.numberPad)
                }
                .formStyle(.grouped)
                Spacer()
                Button("Add Sleep") {
                    if viewModel.addSleep() {
                        presentationMode.wrappedValue.dismiss()
                        onSleepAdded?()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("New Sleep")
            .alert(item: $viewModel.error) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.errorDescription ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}


