//
//  SiriButton.swift
//  kkusu
//
//  Created by sungkug_apple_developer_ac on 6/18/24.
//

import SwiftUI
import IntentsUI

struct SiriButton: UIViewControllerRepresentable {
    @Binding var shortcut: INShortcut?
    
    func makeUIViewController(context: Context) -> SiriUIViewController {
        return SiriUIViewController(shortcut: shortcut)
    }
    
    func updateUIViewController(_ uiViewController: SiriUIViewController, context: Context) {
        uiViewController.updateShortcut(shortcut: shortcut)
    }
}

class SiriUIViewController: UIViewController {
    var shortcut: INShortcut?
    private var button: INUIAddVoiceShortcutButton?
    
    init(shortcut: INShortcut?) {
        self.shortcut = shortcut
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    private func setupButton() {
        let button = INUIAddVoiceShortcutButton(style: .automaticOutline)
        button.shortcut = shortcut
        button.translatesAutoresizingMaskIntoConstraints = false
        button.delegate = self
        
        self.view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        self.button = button
    }
    
    func updateShortcut(shortcut: INShortcut?) {
        self.shortcut?.userActivity?.suggestedInvocationPhrase = shortcut?.userActivity?.suggestedInvocationPhrase
        self.shortcut = shortcut
        self.button?.shortcut = shortcut
        
        if let shortcut = shortcut {
            INVoiceShortcutCenter.shared.setShortcutSuggestions([shortcut])
        }
    }
}

extension SiriUIViewController: INUIAddVoiceShortcutButtonDelegate {
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        addVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(addVoiceShortcutViewController, animated: true)
    }
    
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        editVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(editVoiceShortcutViewController, animated: true)
    }
}

extension SiriUIViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let voiceShortcut = voiceShortcut {
            let newShortcut = INShortcut(userActivity: voiceShortcut.shortcut.userActivity!)
            newShortcut.userActivity?.suggestedInvocationPhrase = voiceShortcut.invocationPhrase
            updateShortcut(shortcut: newShortcut)
        }
        controller.dismiss(animated: true)
    }

    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true)
    }
}

extension SiriUIViewController: INUIEditVoiceShortcutViewControllerDelegate {
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let voiceShortcut = voiceShortcut {
            let newShortcut = INShortcut(userActivity: voiceShortcut.shortcut.userActivity!)
            newShortcut.userActivity?.suggestedInvocationPhrase = voiceShortcut.invocationPhrase
            updateShortcut(shortcut: newShortcut)
        }
        controller.dismiss(animated: true)
    }

    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        updateShortcut(shortcut: nil)
        controller.dismiss(animated: true)
    }

    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true)
    }
}

//struct SiriButton: UIViewControllerRepresentable {
//    @Binding var shortcut: INShortcut?
//    
//    func makeUIViewController(context: Context) -> SiriUIViewController {
//        return SiriUIViewController(shortcut: shortcut)
//    }
//    
//    func updateUIViewController(_ uiViewController: SiriUIViewController, context: Context) {
//        uiViewController.updateShortcut(shortcut: shortcut)
//    }
//}
//
//class SiriUIViewController: UIViewController {
//    var shortcut: INShortcut?
//    private var button: INUIAddVoiceShortcutButton?
//    
//    init(shortcut: INShortcut?) {
//        self.shortcut = shortcut
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let button = INUIAddVoiceShortcutButton(style: .automaticOutline)
//        button.shortcut = shortcut
//        button.translatesAutoresizingMaskIntoConstraints = false
//        
//        self.view.addSubview(button)
//        NSLayoutConstraint.activate([
//            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//        
//        button.delegate = self
//        self.button = button
//    }
//    
//    func updateShortcut(shortcut: INShortcut?) {
//        print("업데이트 할거")
//        self.shortcut?.userActivity?.suggestedInvocationPhrase = shortcut?.userActivity?.suggestedInvocationPhrase
//        self.shortcut = shortcut
//        self.button?.shortcut = shortcut
//        
//        self.button?.removeFromSuperview()
//        let newButton = INUIAddVoiceShortcutButton(style: .automaticOutline)
//        newButton.shortcut = shortcut
//        print("업데이트 확인 \(shortcut?.userActivity?.suggestedInvocationPhrase ?? "모름")")
//        newButton.translatesAutoresizingMaskIntoConstraints = false
//        newButton.delegate = self
//        
//        self.view.addSubview(newButton)
//        NSLayoutConstraint.activate([
//            newButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            newButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//        self.button = newButton
//        if let shortCut = shortcut{
//            INVoiceShortcutCenter.shared.setShortcutSuggestions([shortCut])
//        }
//    }
//}
//
//extension SiriUIViewController: INUIAddVoiceShortcutButtonDelegate {
//    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
//        addVoiceShortcutViewController.delegate = self
//        addVoiceShortcutViewController.modalPresentationStyle = .formSheet
//        present(addVoiceShortcutViewController, animated: true)
//    }
//    
//    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
//        editVoiceShortcutViewController.delegate = self
//        editVoiceShortcutViewController.modalPresentationStyle = .formSheet
//        present(editVoiceShortcutViewController, animated: true)
//    }
//}
//
//extension SiriUIViewController: INUIAddVoiceShortcutViewControllerDelegate {
//    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
//        print("완료")
//        if let voiceShortcut = voiceShortcut {
//            let newShortcut = INShortcut(userActivity: voiceShortcut.shortcut.userActivity!)
//            newShortcut.userActivity?.suggestedInvocationPhrase = voiceShortcut.invocationPhrase
//            updateShortcut(shortcut: newShortcut)
//        }
//        controller.dismiss(animated: true)
//    }
//
//    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
//        controller.dismiss(animated: true)
//    }
//}
//
//extension SiriUIViewController: INUIEditVoiceShortcutViewControllerDelegate {
//    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
//        print("수정완료")
//        if let voiceShortcut = voiceShortcut {
//            let newShortcut = INShortcut(userActivity: voiceShortcut.shortcut.userActivity!)
//            newShortcut.userActivity?.suggestedInvocationPhrase = voiceShortcut.invocationPhrase
//            updateShortcut(shortcut: newShortcut)
//        }
//        controller.dismiss(animated: true)
//    }
//
//    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
//        print("수정전")
//        updateShortcut(shortcut: nil)
//        controller.dismiss(animated: true)
//    }
//
//    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
//        print("수정취소")
//        controller.dismiss(animated: true)
//    }
//}
