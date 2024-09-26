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
            MicrophoneLevelView(audioLevel: viewModel.audioLevel)
                .frame(height: 20)
                .padding(.horizontal)
            
            
            Button(action: {
                viewModel.toggleRecording()
            }) {
                Text(viewModel.isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .foregroundColor(.white)
                    .background(viewModel.isRecording ? Color.red : Color.blue)
                    .cornerRadius(10)
            }
            
            ScrollView {
                Text(viewModel.transcribedText)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding()
            
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
