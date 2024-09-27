//
//  ContentView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var speechRecognizerViewModel = SpeechRecognizerViewModel()
    @StateObject private var microphoneViewModel = MicrophoneInputViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                CircularAudioVisualizerView(audioLevel: speechRecognizerViewModel.audioLevel, maxCircleSize: 80)
                    .frame(width: 150, height: 150)
                
                RecordingButtonView(
                    isRecording: speechRecognizerViewModel.isRecording,
                    action: {
                        speechRecognizerViewModel.toggleRecording()
                    }
                )
            }
            .frame(width: 250, height: 250)
            
            TranscribedTextView(transcribedText: speechRecognizerViewModel.transcribedText)
            
            Spacer()
        }
        .padding()
        .overlay(InputDeviceInfoView(inputSource: microphoneViewModel.currentInputSource)
                .environmentObject(microphoneViewModel),
                 alignment: .topTrailing)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .previewLayout(.fixed(width: 800, height: 600))
            .environmentObject(SpeechRecognizerViewModel())
            .environmentObject(MicrophoneInputViewModel())
    }
}
#endif
