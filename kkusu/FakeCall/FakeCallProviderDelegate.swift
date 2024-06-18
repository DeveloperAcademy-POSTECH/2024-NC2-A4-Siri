//
//  FakeCallProviderDelegate.swift
//  kkusu
//
//  Created by sungkug_apple_developer_ac on 6/18/24.
//

import Foundation
import CallKit
import AVFoundation


final class FakeCallProviderDelegate: NSObject, CXProviderDelegate {
    var audioPlayer: AVAudioPlayer?
    let provider: CXProvider
    let callController = CXCallController()
    
    override init() {
        let configuration = CXProviderConfiguration()
        configuration.supportedHandleTypes = [.phoneNumber]
        self.provider = CXProvider(configuration: configuration)
        super.init()
        provider.setDelegate(self, queue: nil)
    }
    
    public func startCall(id: UUID, handle: String) {
        let uuid = UUID()
        let handle = CXHandle(type: .phoneNumber, value: handle)
        let startCallAction = CXStartCallAction(call: uuid, handle: handle)
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
        update.hasVideo = hasVideo
        
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
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("Answering call")
        configureAudioSession()
        playRecordedAudio()

        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        deactivateAudioSession()
        
        print("Ending call")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        print("Holding call")
        action.fulfill()
    }
    
    private func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: [])
            try audioSession.setMode(.voiceChat)
            try audioSession.setActive(true, options: [])
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }
    
    private func deactivateAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false, options: [])
        } catch {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }
    
    private func playRecordedAudio() {
        guard let audioFilePath = Bundle.main.path(forResource: "music", ofType: "m4a") else {
            print("Audio file not found")
            return
        }
        
        let audioURL = URL(fileURLWithPath: audioFilePath)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }

    private func stopAudioPlayback() {
        audioPlayer?.stop()
    }
}
