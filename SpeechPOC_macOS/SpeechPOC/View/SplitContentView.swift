//
//  SplitContentView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/27/24.
//
//TODO: Refactor and tweak
import SwiftUI

struct SplitContentView: View {
    @EnvironmentObject var transcriptionViewModel: TranscriptionViewModel
    var backAction: () -> Void
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                backButton
                transcriptionListView
            }
        } detail: {
            detailView
        }
    }
    
    private var backButton: some View {
        Button(action: backAction) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back to Recording")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color(NSColor.controlBackgroundColor))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(NSColor.separatorColor)),
            alignment: .bottom
        )
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
        .padding(.horizontal, 16)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: addTranscription) {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    private var detailView: some View {
        Group {
            if let selectedTranscriptionIndex = transcriptionViewModel.transcriptions.firstIndex(where: { $0.id == transcriptionViewModel.selectedTranscription?.id }) {
                TranscriptionDetailView(
                    transcription: $transcriptionViewModel.transcriptions[selectedTranscriptionIndex],
                    onSave: {_ in
                        transcriptionViewModel.updateTranscription(transcriptionViewModel.transcriptions[selectedTranscriptionIndex])
                        transcriptionViewModel.selectedTranscription = nil
                    }
                )
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
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
        .padding()
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
    
    private func moveTranscriptions(from source: IndexSet, to destination: Int) {
        transcriptionViewModel.transcriptions.move(fromOffsets: source, toOffset: destination)
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

