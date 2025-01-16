//
//  TranscriptionListView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/27/24.
//

import SwiftUI

struct TranscriptionListView: View {
    @Binding var transcriptions: [Transcription]
    @Binding var selectedTranscription: Transcription?

    var body: some View {
        List(selection: $selectedTranscription) {
            ForEach(transcriptions) { transcription in
                Text(transcription.title)
                    .tag(transcription)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedTranscription?.id == transcription.id ?
                                  Color(NSColor.selectedTextBackgroundColor).opacity(0.2) : Color.clear)
                    )
                    .contentShape(Rectangle())
            }
            .onMove(perform: moveTranscriptions)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: addTranscription) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private func addTranscription() {
        let newTranscription = Transcription(title: "New Transcription", content: "", tags: [])
        transcriptions.append(newTranscription)
        selectedTranscription = newTranscription
    }

    private func moveTranscriptions(from source: IndexSet, to destination: Int) {
        transcriptions.move(fromOffsets: source, toOffset: destination)
    }
}
