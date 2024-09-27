//
//  MicrophoneInputViewModel.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/26/24.
//

import AVFoundation

final class MicrophoneInputViewModel: ObservableObject {
    @Published var currentInputSource: String = "No Input Device"

    init() {
        setupAudioSession()
    }

    // MARK: - Setup audio session

    func setupAudioSession() {
        updateCurrentInputSourceForMac()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDeviceChange),
            name: .AVCaptureDeviceWasConnected,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDeviceChange),
            name: .AVCaptureDeviceWasDisconnected,
            object: nil
        )
    }

    // MARK: - Audio input source management

    private func updateCurrentInputSourceForMac() {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.microphone, .external],
            mediaType: .audio,
            position: .unspecified
        )

        if let defaultDevice = AVCaptureDevice.default(for: .audio) {
            currentInputSource = defaultDevice.localizedName
        } else if let firstDevice = discoverySession.devices.first {
            currentInputSource = firstDevice.localizedName
        } else {
            currentInputSource = "No Input Device"
        }
    }
    
    // MARK: - Input device change notification (detection purposes)

    @objc private func handleDeviceChange(notification: Notification) {
        updateCurrentInputSourceForMac()
    }
}

