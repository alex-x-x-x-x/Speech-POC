//
//  ActionButtonStyle.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/27/24.
//

import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var foregroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

#if DEBUG
struct ActionButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            Text("Preview Button")
        }
        .buttonStyle(ActionButtonStyle(backgroundColor: .blue, foregroundColor: .white))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
