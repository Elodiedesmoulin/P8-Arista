//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddExerciseViewModel
    var onExerciseAdded: (() -> Void)? 

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(ExerciseCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    TextField("Start Time (MM/dd/yyyy HH:mm)", text: $viewModel.startTime)
                        .keyboardType(.numbersAndPunctuation)
                    TextField("Duration (minutes)", text: $viewModel.duration)
                        .keyboardType(.numberPad)
                    TextField("Intensity (0-10)", text: $viewModel.intensity)
                        .keyboardType(.numberPad)
                }
                .formStyle(.grouped)
                Spacer()
                Button("Add Exercise") {
                    if viewModel.addExercise() {
                        presentationMode.wrappedValue.dismiss()
                        onExerciseAdded?()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("New Exercise")
        }
    }
}


//#Preview {
//    let context = PersistenceController.preview.container.viewContext
//    return AddExerciseView(
//        viewModel: AddExerciseViewModel(
//            exerciseRepository: CoreDataExerciseRepository(context: context),
//            userRepository: CoreDataUserRepository(context: context)
//        ),
//        onExerciseAdded: { }
//    )
//}
