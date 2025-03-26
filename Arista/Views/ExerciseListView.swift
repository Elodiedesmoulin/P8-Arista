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
                        Image(systemName: iconForCategory(exercise.category))
                        VStack(alignment: .leading) {
                            Text(exercise.category)
                                .font(.headline)
                            Text("Durée: \(exercise.duration) min")
                                .font(.subheadline)
                            Text(exercise.date.formatted())
                                .font(.subheadline)
                        }
                        Spacer()
                        IntensityIndicator(intensity: exercise.intensity)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Exercices")
            .navigationBarItems(trailing: Button(action: {
                showingAddExerciseView = true
            }) {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showingAddExerciseView) {
            AddExerciseView(
                viewModel: AddExerciseViewModel(
                    exerciseRepository: CoreDataExerciseRepository(context: viewContext),
                    userRepository: CoreDataUserRepository(context: viewContext)
                ),
                onExerciseAdded: {
                    viewModel.fetchExercises() 
                }
            )
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            let exercise = viewModel.exercises[index]
            viewModel.deleteExercise(by: exercise.id)
        }
    }
    
    private func iconForCategory(_ category: String) -> String {
        guard let cat = ExerciseCategory(rawValue: category) else { return "questionmark" }
        switch cat {
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
    var intensity: Int
    
    var body: some View {
        Circle()
            .fill(colorForIntensity(intensity))
            .frame(width: 10, height: 10)
    }
    
    func colorForIntensity(_ intensity: Int) -> Color {
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

//#Preview {
//    let context = PersistenceController.preview.container.viewContext
//    let exerciseRepo = CoreDataExerciseRepository(context: context)
//    return ExerciseListView(viewModel: ExerciseListViewModel(exerciseRepository: exerciseRepo))
//}
