//
//  SpeechRecognizerViewModel.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/24/24.
//

import AVFoundation
import Speech

final class SpeechRecognizerViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var transcribedText = ""
    @Published var audioLevel: Float = 0.0
    @Published var audioSamples: [Float] = []

    private var audioEngine = AVAudioEngine()
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let sampleCount = 50

    init() {
        requestSpeechRecognitionAccess()
        requestMicrophoneAccess()
    }
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            checkPermissionsAndStartRecording()
        }
    }

    private func checkPermissionsAndStartRecording() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                AVCaptureDevice.requestAccess(for: .audio) { granted in
                    if granted {
                        DispatchQueue.main.async {
                            self.startRecording()
                        }
                    } else {
                        print("Microphone access denied")
                    }
                }
            default:
                print("Speech recognition not authorized")
            }
        }
    }
    
    // MARK: - Start/stop recording

    private func startRecording() {
        guard !audioEngine.isRunning else { return }
        resetRecognitionTaskIfNeeded()
        createRecognitionRequest()
        setupRecognitionTask()
        startAudioEngine()

        DispatchQueue.main.async {
            self.isRecording = true
        }
    }

    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isRecording = false
    }
    
    // MARK: - Speech recognition tasks (reset, create, setup & handle recognition results)

    private func resetRecognitionTaskIfNeeded() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
    }

    private func createRecognitionRequest() {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create recognition request")
        }
        
        recognitionRequest.shouldReportPartialResults = true
    }

    private func setupRecognitionTask() {
        guard let recognitionRequest = recognitionRequest else { return }

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.transcribedText = result.bestTranscription.formattedString
                }
            }
            
            if error != nil || result?.isFinal == true {
                self.stopAudioEngine()
            }
        }
    }

    // MARK: - Audio engine control (configures the audio engine with hardware format and starts capturing audio)

    private func startAudioEngine() {
        let inputNode = audioEngine.inputNode
        let hwFormat = inputNode.inputFormat(forBus: 0)
        
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: hwFormat) { buffer, when in
            self.recognitionRequest?.append(buffer)
            self.detectAudioLevel(buffer: buffer)
        }
        
        do {
            try audioEngine.start()
        } catch {
            audioEngine.stop()
            audioEngine.reset()
        }
    }


    private func stopAudioEngine() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest = nil
        recognitionTask = nil
    }

    // MARK: - Audio Level Detection

    private func detectAudioLevel(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData else { return }
        let channelDataValue = channelData.pointee
        let channelDataArray = stride(from: 0,
                                      to: Int(buffer.frameLength),
                                      by: buffer.stride).map { channelDataValue[$0] }
        
        let rms = sqrt(channelDataArray.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
        let avgPower = 20 * log10(rms)
        
        DispatchQueue.main.async {
            self.audioLevel = (avgPower + 160) / 160
        }
    }
    
    // MARK: - Permission requests

    fileprivate func requestSpeechRecognitionAccess() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                self.startAudioEngine()
            case .denied, .restricted, .notDetermined:
                self.stopAudioEngine()
            @unknown default:
                fatalError("Unknown authorization status")
            }
        }
    }
    
    fileprivate func requestMicrophoneAccess() {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            if granted {
                self.startRecording()
            } else {
                self.stopRecording()
            }
        }
    }
}
