//
//  TaggingView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/27/24.
//

import SwiftUI

struct TaggingView: View {
    @Binding var tags: [String]
    @State private var newTag: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Add a tag", text: $newTag)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Add") {
                    if !newTag.isEmpty {
                        tags.append(newTag)
                        newTag = ""
                    }
                }
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}
