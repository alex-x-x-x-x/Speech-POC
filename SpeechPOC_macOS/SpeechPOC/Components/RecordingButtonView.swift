//
//  RecordingButtonView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/26/24.
//

import SwiftUI

struct RecordingButtonView: View {
    var isRecording: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isRecording ? "mic.fill" : "mic.slash.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding()
                .foregroundColor(.white)
                .background(isRecording ? Color.red : Color.red)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isRecording ? Color.red : Color.red, lineWidth: 4)
                )
                .shadow(radius: 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#if DEBUG
struct RecordingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingButtonView(isRecording: false,
                            action: {}).frame(width: 100, height: 100)
    }
}
#endif
