//
//  SpeechRecognizerViewModel.swift
//  SpeechPOC
//
//  Created by Alex Lifa on 9/24/24.
//

import AVFoundation
import Speech

class SpeechRecognizerViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var transcribedText = ""
    @Published var audioLevel: Float = 0.0

    private var audioEngine = AVAudioEngine()
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    init() {
        requestSpeechRecognitionAccess()
        requestMicrophoneAccess()
    }
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    // MARK: - Start/stop recording

    private func startRecording() {
        resetRecognitionTaskIfNeeded()
        createRecognitionRequest()
        setupRecognitionTask()
        startAudioEngine()
        isRecording = true
    }
    
    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
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
            self.handleRecognitionResult(result, error: error)
        }
    }

    private func handleRecognitionResult(_ result: SFSpeechRecognitionResult?, error: Error?) {
        if let result = result {
            DispatchQueue.main.async {
                self.transcribedText = result.bestTranscription.formattedString
            }
        }
        
        if error != nil || result?.isFinal == true {
            stopAudioEngine()
        }
    }

    // MARK: - Start/stop audio engine

    private func startAudioEngine() {
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            self.recognitionRequest?.append(buffer)
            self.detectAudioLevel(buffer: buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine couldn't start because of an error: \(error.localizedDescription)")
        }
    }

    private func stopAudioEngine() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest = nil
        recognitionTask = nil
    }

    // MARK: - Detect audio level

    private func detectAudioLevel(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData else { return }
        let channelDataValue = channelData.pointee
        let channelDataArray = stride(from: 0,
                                      to: Int(buffer.frameLength),
                                      by: buffer.stride).map { channelDataValue[$0] }
        
        let rms = sqrt(channelDataArray.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
        let avgPower = 20 * log10(rms)
        
        DispatchQueue.main.async {
            self.audioLevel = avgPower
        }
    }
    
    // MARK: - SpeechRecognition and Microphone (system level permissions)
    
    fileprivate func requestSpeechRecognitionAccess() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            case .denied, .restricted, .notDetermined:
                print("Speech recognition not authorized")
            @unknown default:
                fatalError("Unknown authorization status")
            }
        }
    }
    
    fileprivate func requestMicrophoneAccess() {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            if granted {
                print("Microphone access granted")
            } else {
                print("Microphone access denied")
            }
        }
    }
}
