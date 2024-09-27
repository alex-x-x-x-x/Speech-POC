//
//  InputDeviceInfoView.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/26/24.
//

import SwiftUI

struct InputDeviceInfoView: View {
    var inputSource: String
    
    var body: some View {
        VStack {
            Text("Input Device")
                .font(.headline)
                .padding(.top, 5)
            
            HStack {
                if inputSource.contains("AirPods") {
                    Image(systemName: "airpodspro")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 10)
                }
                
                Text(inputSource)
                    .font(.caption2)
                    .padding(5)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
            }
        }
        .frame(width: 150)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.trailing, 20)
        .padding(.top, 30)
    }
}

#if DEBUG
struct InputDeviceInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InputDeviceInfoView(inputSource: "AirPods Pro")
                .previewDisplayName("AirPods Pro")

            InputDeviceInfoView(inputSource: "Built-in Microphone")
                .previewDisplayName("Built-in Microphone")

            InputDeviceInfoView(inputSource: "External Microphone")
                .previewDisplayName("External Microphone")

            InputDeviceInfoView(inputSource: "No Input Device")
                .previewDisplayName("No Input Device")
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
