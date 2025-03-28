//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct SleepHistoryView: View {
    @ObservedObject var viewModel: SleepHistoryViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.sleepSessions) { session in
                HStack {
                    QualityIndicator(quality: session.quality)
                        .padding()
                    VStack(alignment: .leading) {
                        Text("Start: \(session.startDate.formatted())")
                        Text("Duration: \(session.duration) min")
                    }
                }
            }
            .navigationTitle("Sleep History")
        }
        .alert(item: $viewModel.error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.errorDescription ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
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

//#Preview {
//    let context = PersistenceController.preview.container.viewContext
//    return SleepHistoryView(viewModel: SleepHistoryViewModel(sleepRepository: CoreDataSleepRepository(context: context)))
//}
