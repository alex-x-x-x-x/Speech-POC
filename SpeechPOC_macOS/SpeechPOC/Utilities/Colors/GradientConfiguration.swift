//
//  GradientConfiguration.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/26/24.
//

import SwiftUI

struct GradientConfiguration {
    var lowLevelGradient: LinearGradient
    var mediumLevelGradient: LinearGradient
    var highLevelGradient: LinearGradient

    // MARK: - Color configurations
    // TODO: Improve gradient color choices including startPoint/endPoint for `audioLevel`
    static var defaultConfig: GradientConfiguration {
        GradientConfiguration(
            lowLevelGradient: LinearGradient(
                gradient: Gradient(colors: [Color.lowlevelGradient1, Color.lowlevelGradient2]),
                startPoint: .top,
                endPoint: .bottom
            ),
            mediumLevelGradient: LinearGradient(
                gradient: Gradient(colors: [Color.mediumlevelGradient1, Color.mediumlevelGradient2]),
                startPoint: .top,
                endPoint: .bottom
            ),
            highLevelGradient: LinearGradient(
                gradient: Gradient(colors: [Color.highlevelGradient1, Color.highlevelGradient2]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    // MARK: - Gradient set based on audio level

    func gradient(for audioLevel: CGFloat) -> LinearGradient {
        switch audioLevel {
        case 0.0..<0.3:
            return lowLevelGradient
        case 0.3..<0.6:
            return mediumLevelGradient
        case 0.6...1.0:
            return highLevelGradient
        default:
            return lowLevelGradient
        }
    }
}
