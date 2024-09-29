//
//  ContentView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/24/24.
//
//TODO: Refactor and tweak
import SwiftUI

struct ContentView: View {
    @StateObject private var speechRecognizerViewModel = SpeechRecognizerViewModel()
    @StateObject private var microphoneViewModel = MicrophoneInputViewModel()
    @StateObject private var transcriptionViewModel = TranscriptionViewModel()
    
    var body: some View {
        NavigationSplitView {
            transcriptionListView
        } detail: {
            if let index = transcriptionViewModel.transcriptions.firstIndex(where: { $0.id == transcriptionViewModel.selectedTranscription?.id }) {
                TranscriptionDetailView(
                    transcription: $transcriptionViewModel.transcriptions[index],
                    onSave: { updatedTranscription in
                        transcriptionViewModel.updateTranscription(updatedTranscription)
                        transcriptionViewModel.selectedTranscription = nil
                    }
                )
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            transcriptionViewModel.deleteTranscription(transcriptionViewModel.transcriptions[index])
                            transcriptionViewModel.selectedTranscription = nil
                        }) {
                            Image(systemName: "trash")
                        }
                    }
                    ToolbarItem(placement: .navigation) {
                        Button(action: { transcriptionViewModel.selectedTranscription = nil }) {
                            Image(systemName: "arrow.left")
                            Text("Back to Recording")
                        }
                    }
                }
            } else {
                recordingView
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .environmentObject(transcriptionViewModel)
    }
    
    private var transcriptionListView: some View {
        List(selection: $transcriptionViewModel.selectedTranscription) {
            ForEach(transcriptionViewModel.transcriptions) { transcription in
                Text(transcription.title)
                    .tag(transcription)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(transcriptionViewModel.selectedTranscription?.id == transcription.id ?
                                  Color(NSColor.selectedTextBackgroundColor).opacity(0.2) : Color.clear)
                    )
                    .contentShape(Rectangle())
            }
            .onMove(perform: moveTranscriptions)
        }
        .frame(minWidth: 200)
        .listStyle(SidebarListStyle())
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: addTranscription) {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationTitle("Transcriptions")
    }

    private var recordingView: some View {
        VStack(spacing: 20) {
            recordingVisualizerSection
            TranscribedTextView(transcribedText: speechRecognizerViewModel.transcribedText)
            
            Spacer()
            SaveButton(action: saveTranscription)
        }
        .padding()
        .overlay(InputDeviceInfoView(inputSource: microphoneViewModel.currentInputSource)
                .environmentObject(microphoneViewModel),
                 alignment: .topTrailing)
    }
    
    private var recordingVisualizerSection: some View {
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
    }
    
    private func saveTranscription() {
        let newTranscription = Transcription(
            title: "Saved Transcription \(transcriptionViewModel.transcriptions.count + 1)",
            content: speechRecognizerViewModel.transcribedText,
            tags: transcriptionViewModel.generateTags(for: speechRecognizerViewModel.transcribedText)
        )
        transcriptionViewModel.addTranscription(newTranscription)
        
        DispatchQueue.main.async {
            speechRecognizerViewModel.transcribedText = ""
            transcriptionViewModel.selectedTranscription = newTranscription
        }
    }
    
    private func addTranscription() {
        let newTranscription = Transcription(
            title: "New Transcription",
            content: "",
            tags: []
        )
        transcriptionViewModel.addTranscription(newTranscription)
        transcriptionViewModel.selectedTranscription = newTranscription
    }

    //TODO: Fix!
    private func moveTranscriptions(from source: IndexSet, to destination: Int) {
        transcriptionViewModel.transcriptions.move(fromOffsets: source, toOffset: destination)
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
            .environmentObject(TranscriptionViewModel())
    }
}
#endif
