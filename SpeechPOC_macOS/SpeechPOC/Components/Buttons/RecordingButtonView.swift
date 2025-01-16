//
//  RecordingButtonView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/26/24.
//

import SwiftUI

struct RecordingButtonView: View {
    @State private var showError = false
    @Binding var isRecording: Bool
    var action: (_ onSuccess: () -> Void, _ onError: () -> Void) -> Void

    var body: some View {
        Button(action: {
            toggleRecording()
        }) {
            Image(systemName: isRecording ? "mic.fill" : "mic.slash.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding()
                .foregroundColor(.white)
                .background(isRecording ? Color.red : Color.gray)
                .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Recording Error"),
                message: Text("Unable to start or stop recording. Please try again."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func toggleRecording() {
        action(
            { isRecording = true },
            { showError = true }
        )
    }
}

#if DEBUG
#Preview("Idle State") {
    RecordingButtonView(isRecording: .constant(false), action: { _, _ in })
        .frame(width: 100, height: 100)
        .padding()
}

#Preview("Recording State") {
    RecordingButtonView(isRecording: .constant(true), action: { _, _ in })
        .frame(width: 100, height: 100)
        .padding()
}
#endif
