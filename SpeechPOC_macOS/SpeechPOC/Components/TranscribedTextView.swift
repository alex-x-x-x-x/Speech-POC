//
//  TranscribedTextView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/26/24.
//

import SwiftUI

struct TranscribedTextView: View {
    var transcribedText: String
    
    var body: some View {
        ScrollView {
            Text(transcribedText.isEmpty ? "Start speaking to see transcription, verify that your microphone is enabled. Press the button to start recording." : transcribedText)
                .font(.caption)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .layoutPriority(1)
        }
        .padding()
        .frame(maxHeight: 150)
    }
}

#if DEBUG
struct TranscribedTextView_Previews: PreviewProvider {
    static var previews: some View {
        TranscribedTextView(transcribedText: "")
    }
}
#endif

