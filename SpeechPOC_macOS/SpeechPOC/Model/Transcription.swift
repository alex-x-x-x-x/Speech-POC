//
//  Transcription.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/27/24.
//

import Foundation

struct Transcription: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var content: String
    var tags: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Transcription, rhs: Transcription) -> Bool {
        return lhs.id == rhs.id
    }
}

