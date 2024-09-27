//
//  CircularAudioVisualizerView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/26/24.
//

import SwiftUI

struct CircularAudioVisualizerView: View {
    private(set) var audioLevel: Float
    private(set) var maxCircleSize: CGFloat = 100

    var gradientConfig: GradientConfiguration = .defaultConfig

    var body: some View {
        GeometryReader { geometry in
            let baseSize = max(min(geometry.size.width, geometry.size.height) / 2, 0)
            let clampedAudioLevel = max(0, min(CGFloat(audioLevel), 1))
            let outerCircleSize = max(baseSize + clampedAudioLevel * maxCircleSize, 0)
            let innerCircleSize = max(baseSize + clampedAudioLevel * (maxCircleSize / 2), 0)
            
            let gradient = gradientConfig.gradient(for: clampedAudioLevel)

            ZStack {
                Circle()
                    .stroke(gradient, lineWidth: 40)
                    .frame(width: outerCircleSize, height: outerCircleSize)
                    .animation(clampedAudioLevel > 0.01 ? .interactiveSpring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5) : .easeOut(duration: 0.4), value: audioLevel)

                Circle()
                    .stroke(gradient, lineWidth: 20)
                    .frame(width: innerCircleSize, height: innerCircleSize)
                    .animation(clampedAudioLevel > 0.01 ? .interactiveSpring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5) : .easeOut(duration: 0.4), value: audioLevel)
                // TODO: Tweak `clampedAudioLevel` for both animation and opacity??
                Circle()
                    .stroke(gradient, lineWidth: 2)
                    .frame(width: outerCircleSize * 1.1, height: outerCircleSize * 1.1)
                    .opacity(clampedAudioLevel > 0.7 ? 1 : 0)
                    .animation(clampedAudioLevel > 0.7 ? .easeInOut(duration: 0.2) : .none, value: audioLevel)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#if DEBUG
struct CircularAudioVisualizerView_Previews: PreviewProvider {
    static var previews: some View {
        CircularAudioVisualizerView(
            audioLevel: 0.5,
            gradientConfig: GradientConfiguration.defaultConfig
        )
        .frame(width: 250, height: 250)
    }
}
#endif
