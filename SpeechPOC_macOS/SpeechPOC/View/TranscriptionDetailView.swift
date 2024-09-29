//
//  TranscriptionDetailView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/27/24.
//

import SwiftUI

struct TranscriptionDetailView: View {
    @Binding var transcription: Transcription
    var onSave: (Transcription) -> Void
    var gradientConfig: GradientConfiguration = .defaultConfig
    
    @State private var editedTitle: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Title", text: $transcription.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing, .top])

            TextEditor(text: $transcription.content)
                .border(Color.gray, width: 1)
                .frame(minHeight: 200)
                .padding([.leading, .trailing])
            
            TaggingView(tags: $transcription.tags, gradientConfig: gradientConfig)
                .padding([.leading, .trailing])
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    onSave(transcription)
                }) {
                    Text("Save")
                        .fontWeight(.bold)
                        .padding()
                        .frame(minWidth: 100)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
        .onAppear {
            editedTitle = transcription.title
        }
    }
}

#if DEBUG || TracePreviews
struct TranscriptionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTranscription = Transcription(
            title: "Transcription title",
            content: "blablablablablablabla.",
            tags: ["????", "blablablabla", "tag"]
        )
        
        StatefulPreviewWrapper(sampleTranscription) { binding in
            TranscriptionDetailView(transcription: binding, onSave: { updatedTranscription in
            })
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

// MARK: - Preview helper

struct StatefulPreviewWrapper<Value: Identifiable, Content: View>: View where Value: Hashable {
    @State private var value: Value
    var content: (Binding<Value>) -> Content
    
    init(_ value: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        _value = State(wrappedValue: value)
        self.content = content
    }
    
    var body: some View {
        content($value)
    }
}
#endif


