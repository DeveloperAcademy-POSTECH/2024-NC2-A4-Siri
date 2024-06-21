# 2024-NC2-A4-Siri
꾸기 &amp; 이수
![NC2_Main](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A4-Siri/assets/91677242/df4f1a0a-7443-4fb0-92ed-2f4de7e11f2c)
## 🎥 Youtube Link
(추후 만들어진 유튜브 링크 추가)

## 💡 About Siri

> 일상적인 작업을 빠르고 쉽게 수행할 수 있도록 돕는 Ai

> 앱의 주요 작업을 식별해서 시리를 통해 빠르게 접속하고 사용할 수 있도록 합니다.
 시스템에 앱의 주요 작업을 알리고 제안을 하여 참여를 유도합니다.

> -> 어떤 상황에서든 실행이 되도록 유연성이 핵심입니다

## 🎯 What we focus on?

> SiriKit을 이용해 우리앱을 단축어앱에서 인식할 수 있도록 Intent를 정의하거나 userActivity를 설정한다.
> 사용자가 Siri Shortcuts를 쉽게 추가할 수 있도록 돕는 INUIAddVoiceShortcutButton을 사용해서 사용자가 해당 작업을 Siri 음성 명령으로 실행할 수 있게한다.

## 💼 Use Case
> <br/> [불편한 상황에서 벗어나고 싶은 사람들]이 Siri를 사용해서
[전화로 핑계가 되는 상황을 연출] 할 수 있는 앱

## 🖼️ Prototype
![NC2 집중기술2 001](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A4-Siri/assets/91677242/7ff57035-f062-45cb-9613-e2ed88349bd3)
![NC2 집중기술2 002](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A4-Siri/assets/91677242/3c8fd12f-a315-40ba-bfa7-cf0878778732)

## 🛠️ About Code
```swift
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
```
```swift
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
```
```swift
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
```
```swift
    func updateShortcut(shortcut: INShortcut?) {
        if let shortcut = shortcut {
            self.shortcut?.userActivity?.suggestedInvocationPhrase = shortcut.userActivity?.suggestedInvocationPhrase
            self.shortcut = shortcut
            self.button?.shortcut = shortcut
            
            INVoiceShortcutCenter.shared.setShortcutSuggestions([shortcut])
        }
    }
```
