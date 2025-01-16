//
//  SplitContentView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/27/24.
//

import SwiftUI

struct SplitContentView: View {
    @EnvironmentObject var transcriptionViewModel: TranscriptionViewModel
    @EnvironmentObject var speechRecognizerViewModel: SpeechRecognizerViewModel
    var backAction: (() -> Void)?

    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                if let backAction = backAction {
                    BackButton(action: backAction)
                }
                TranscriptionListView(
                    transcriptions: $transcriptionViewModel.transcriptions,
                    selectedTranscription: $transcriptionViewModel.selectedTranscription
                )
            }
        } detail: {
            detailView
        }
    }

    private var detailView: some View {
        Group {
            if let selectedTranscriptionIndex = transcriptionViewModel.transcriptions.firstIndex(where: { $0.id == transcriptionViewModel.selectedTranscription?.id }) {
                TranscriptionDetailView(
                    transcription: $transcriptionViewModel.transcriptions[selectedTranscriptionIndex],
                    onSave: { updatedTranscription in
                        transcriptionViewModel.updateTranscription(updatedTranscription)
                        transcriptionViewModel.selectedTranscription = nil
                    }
                )
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button(action: {
                            transcriptionViewModel.deleteTranscription(transcriptionViewModel.transcriptions[selectedTranscriptionIndex])
                            transcriptionViewModel.selectedTranscription = nil
                        }) {
                            Image(systemName: "trash")
                        }
                    }
                }
            } else {
                VStack {
                    Text("Select or Save a transcription")
                        .foregroundColor(Color(NSColor.placeholderTextColor))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#if DEBUG || TRACE_VIEWS
struct SplitContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplitContentView(backAction: {})
            .environmentObject(TranscriptionViewModel())
    }
}
#endif
