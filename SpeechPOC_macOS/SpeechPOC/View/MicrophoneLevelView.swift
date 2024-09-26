//
//  MicrophoneLevelView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/24/24.
//

import SwiftUI

struct MicrophoneLevelView: View {
    var audioLevel: Float
    
    var body: some View {
        GeometryReader { geometry in
            let normalizedLevel = min(max((audioLevel + 100) / 100, 0), 1)
            let barWidth = CGFloat(normalizedLevel) * geometry.size.width
            
            HStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: barWidth, height: geometry.size.height)
                Spacer()
            }
            .background(Color.gray.opacity(0.5))
            .cornerRadius(5)
        }
    }
}

#if DEBUG
struct MicrophoneLevelView_Previews: PreviewProvider {
    static var previews: some View {
        MicrophoneLevelView(audioLevel: 5)
    }
}
#endif
