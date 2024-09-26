//
//  CircularAudioVisualizerView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/26/24.
//

import SwiftUI

struct CircularAudioVisualizerView: View {
    var audioLevel: Float
    var maxCircleSize: CGFloat = 100
    
    var body: some View {
        GeometryReader { geometry in
            let baseSize = max(min(geometry.size.width, geometry.size.height) / 2, 0)
            let clampedAudioLevel = max(0, min(CGFloat(audioLevel), 1))
            let outerCircleSize = max(baseSize + clampedAudioLevel * maxCircleSize, 0)
            let innerCircleSize = max(baseSize + clampedAudioLevel * (maxCircleSize / 2), 0)

            //TODO: Tweak/make improvements to animation response to audioLevel detection
            ZStack {
                Circle()
                    .stroke(lineWidth: 50)
                    .frame(width: outerCircleSize, height: outerCircleSize)
                    .foregroundColor(Color.gray.opacity(0.6))
                    .animation(.bouncy(duration: 0.2), value: audioLevel)
                
                Circle()
                    .stroke(lineWidth: 50)
                    .frame(width: innerCircleSize, height: innerCircleSize)
                    .foregroundColor(Color.white.opacity(0.6))
                    .animation(.bouncy(duration: 0.2), value: audioLevel)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .animation(.easeInOut(duration: 0.2), value: audioLevel)
        }
    }
}

#if DEBUG
struct CircularAudioVisualizerView_Previews: PreviewProvider {
    static var previews: some View {
        CircularAudioVisualizerView(audioLevel: 0.5)
            .frame(width: 200, height: 200)
    }
}
#endif
