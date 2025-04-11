//
//  ExerciseListView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct ExerciseListView: View {
    @ObservedObject var viewModel: ExerciseListViewModel
    @State private var showingAddExerciseView = false
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.exercises) { exercise in
                    HStack {
                        Image(systemName: iconForCategory(exercise.exerciseCategory))
                        VStack(alignment: .leading) {
                            Text(exercise.category)
                                .font(.headline)
                            Text("Duration: \(exercise.duration) min")
                                .font(.subheadline)
                            Text(exercise.date.formatted())
                                .font(.subheadline)
                        }
                        Spacer()
                        IntensityIndicator(intensity: exercise.intensity)
                    }
                }
                .onDelete { offsets in
                    offsets.forEach { index in
                        let exercise = viewModel.exercises[index]
                        viewModel.deleteExercise(exercise)
                    }
                }
            }
            .navigationTitle("Exercises")
            .navigationBarItems(trailing: Button(action: {
                showingAddExerciseView = true
            }) {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showingAddExerciseView) {
            AddExerciseView(
                viewModel: AddExerciseViewModel(
                    exerciseRepository: ExerciseRepository(context: viewContext),
                    userRepository: UserRepository(context: viewContext)
                ),
                onExerciseAdded: {
                    viewModel.fetchExercises()
                }
            )
        }
        .alert(item: $viewModel.error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.errorDescription ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func iconForCategory(_ category: ExerciseCategory) -> String {
        switch category {
        case .football:
            return "sportscourt"
        case .natation:
            return "waveform.path.ecg"
        case .running:
            return "figure.run"
        case .marche:
            return "figure.walk"
        case .cyclisme:
            return "bicycle"
        }
    }
}

struct IntensityIndicator: View {
    var intensity: Int16
    
    var body: some View {
        Circle()
            .fill(colorForIntensity(intensity))
            .frame(width: 10, height: 10)
    }
    
    func colorForIntensity(_ intensity: Int16) -> Color {
        switch intensity {
        case 0...3:
            return .green
        case 4...6:
            return .yellow
        case 7...10:
            return .red
        default:
            return .gray
        }
    }
}


