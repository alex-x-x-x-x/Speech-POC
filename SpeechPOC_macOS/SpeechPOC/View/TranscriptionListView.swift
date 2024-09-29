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
            }
            .onMove(perform: move)
        }
        .frame(minWidth: 200)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        transcriptions.move(fromOffsets: source, toOffset: destination)
    }
}
