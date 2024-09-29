//
//  SaveButton.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/27/24.
//

import SwiftUI

struct SaveButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Save")
        }
        .buttonStyle(ActionButtonStyle(backgroundColor: .green, foregroundColor: .white))
    }
}

#if DEBUG
struct SaveButton_Previews: PreviewProvider {
    static var previews: some View {
        SaveButton(action: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif

