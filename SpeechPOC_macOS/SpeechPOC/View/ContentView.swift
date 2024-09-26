//
//  ContentView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SpeechRecognizerViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                CircularAudioVisualizerView(audioLevel: viewModel.audioLevel, maxCircleSize: 80)
                    .frame(width: 150, height: 150)
                Button(action: {
                    viewModel.toggleRecording()
                }) {
                    Image(systemName: viewModel.isRecording ? "mic.fill" : "mic.slash.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding()
                        .foregroundColor(.white)
                        .background(viewModel.isRecording ? Color.red : Color.green)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(viewModel.isRecording ? Color.red : Color.green, lineWidth: 4)
                        )
                        .shadow(radius: 10)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .frame(width: 250, height: 250)

            ScrollView {
                Text(viewModel.transcribedText.isEmpty ? "Start speaking to see transcription, verify that your microphone is enabled. Press the button to start recording." : viewModel.transcribedText)
                    .font(.caption)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .layoutPriority(1)
            }
            .padding()
            .frame(maxHeight: 150)
            Spacer()
        }
        .padding()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
