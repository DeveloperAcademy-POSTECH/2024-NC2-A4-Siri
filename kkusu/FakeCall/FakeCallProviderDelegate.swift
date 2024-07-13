//
//  FakeCallProviderDelegate.swift
//  kkusu
//
//  Created by sungkug_apple_developer_ac on 6/18/24.
//

import Foundation
import CallKit
import AVFoundation

final class FakeCallProviderDelegate: NSObject, ObservableObject, CXProviderDelegate {
    @Published var isCallEnded = false
    var audioPlayer: AVAudioPlayer?
    let provider: CXProvider
    let callController = CXCallController()
    
    override init() {
        let configuration = CXProviderConfiguration()
        configuration.supportsVideo = true
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportedHandleTypes = [.generic]
        self.provider = CXProvider(configuration: configuration)
        super.init()
        provider.setDelegate(self, queue: nil)
    }
    
    public func startCall(id: UUID, handle: String) {
        let handle = CXHandle(type: .generic, value: handle)
        let startCallAction = CXStartCallAction(call: id, handle: handle)
        let transaction = CXTransaction(action: startCallAction)
        
        callController.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction: \(error.localizedDescription)")
            } else {
                print("Requested transaction successfully")
            }
        }
    }
    
    public func reportIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: handle)
        update.hasVideo = true
        
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if let error = error {
                print("Error reporting incoming call: \(error.localizedDescription)")
            } else {
                print("Incoming call successfully reported.")
            }
        }
    }
    
    func providerDidReset(_ provider: CXProvider) {
        print("Call reset")
        cleanupAfterCall()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("Answering call")
        self.configureAudioSession()
        action.fulfill()
        isCallEnded = false
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        self.playRecordedAudio()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("Ending call")
        cleanupAfterCall()
        action.fulfill()
        isCallEnded = true
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        print("Holding call")
        action.fulfill()
    }
    
    private func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            if audioSession.category != .playAndRecord {
                try audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                             options: AVAudioSession.CategoryOptions.allowBluetooth)
            }
            if audioSession.mode != .voiceChat {
                try audioSession.setMode(.voiceChat)
            }
        } catch {
            print("Error configuring AVAudioSession: \(error.localizedDescription)")
        }
    }
    
    private func deactivateAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false, options: [])
            print("Audio session deactivated")
        } catch {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }
    
    private func playRecordedAudio() {
        guard let audioFilePath = Bundle.main.path(forResource: "momSound", ofType: "m4a") else {
            print("Audio file not found")
            return
        }
        
        let audioURL = URL(fileURLWithPath: audioFilePath)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.audioPlayer?.play()
                print("Playing recorded audio")
            }
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }

    private func stopAudioPlayback() {
        audioPlayer?.stop()
        print("Audio playback stopped")
    }
    
    private func cleanupAfterCall() {
        stopAudioPlayback()
        deactivateAudioSession()
        audioPlayer = nil
        print("Cleaned up after call")
    }
}
