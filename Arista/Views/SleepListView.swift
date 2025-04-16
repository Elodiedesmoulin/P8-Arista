//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct SleepListView: View {
    @ObservedObject var viewModel: SleepListViewModel
    @State private var showingAddSleepView = false
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.sleepSessions) { session in
                    HStack {
                        QualityIndicator(quality: session.quality)
                            .padding()
                        VStack(alignment: .leading) {
                            Text("Start: \(session.startDate.formatted())")
                            Text("Duration: \(session.duration) min")
                        }
                    }
                }
                .onDelete(perform: deleteSleep)
            }
            .navigationTitle("Sleep History")
            .navigationBarItems(trailing: Button(action: {
                showingAddSleepView = true
            }) {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showingAddSleepView) {
            AddSleepSessionView(
                viewModel: AddSleepViewModel(
                    sleepRepository: SleepRepository(context: viewContext),
                    userRepository: UserRepository(context: viewContext)
                ),
                onSleepAdded: {
                    viewModel.fetchSleepData()
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

    private func deleteSleep(at offsets: IndexSet) {
        offsets.forEach { index in
            let session = viewModel.sleepSessions[index]
            do {
                try SleepRepository(context: viewContext).deleteSleepSession(session)
                viewModel.fetchSleepData()
            } catch {
                viewModel.error = .repositoryError(error.localizedDescription)
            }
        }
    }
}

struct QualityIndicator: View {
    let quality: Int16
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(qualityColor(quality), lineWidth: 5)
                .foregroundColor(qualityColor(quality))
                .frame(width: 30, height: 30)
            Text("\(quality)")
                .foregroundColor(qualityColor(quality))
        }
    }
    
    func qualityColor(_ quality: Int16) -> Color {
        switch (10 - quality) {
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

