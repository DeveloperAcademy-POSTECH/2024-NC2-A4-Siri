# 2024-NC2-A4-Siri
꾸기 &amp; 이수
![NC2_Main](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A4-Siri/assets/91677242/df4f1a0a-7443-4fb0-92ed-2f4de7e11f2c)
## 🎥 Youtube Link
(추후 만들어진 유튜브 링크 추가)

## 💡 About Siri

> 일상적인 작업을 빠르고 쉽게 수행할 수 있도록 돕는 Ai
>
> 앱의 주요 작업을 식별해서 시리를 통해 빠르게 접속하고 사용할 수 있도록 합니다.
> 시스템에 앱의 주요 작업을 알리고 제안을 하여 참여를 유도합니다.
>
> -> 어떤 상황에서든 실행이 되도록 유연성이 핵심입니다

## 🎯 What we focus on?

> SiriKit을 이용해 우리앱을 단축어앱에서 인식할 수 있도록 Intent를 정의하거나 userActivity를 설정한다.
> 사용자가 Siri Shortcuts를 쉽게 추가할 수 있도록 돕는 INUIAddVoiceShortcutButton을 사용해서 사용자가 해당 작업을 Siri 음성 명령으로 실행할 수 있게한다.

## 💼 Use Case
> <br/> [불편한 상황에서 벗어나고 싶은 사람들]이 Siri를 사용해서
> [전화로 핑계가 되는 상황을 연출] 할 수 있는 앱

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
> 먼저 INUIAddVoiceShortcutButton을 생성 후 뷰에 배치해줍니다.
> 이 때 버튼에 현재 설정중인 shortcut 값을 넣어 줘야지 버튼에 현재 설정된 단축어가 표시가 됩니다.

```swift
        var userActivity: NSUserActivity {
            let userActivity = NSUserActivity(activityType: self.type)
            userActivity.title = self.title
            userActivity.suggestedInvocationPhrase = self.invocationPhrase
            userActivity.isEligibleForSearch = true
            userActivity.isEligibleForPrediction = true
            userActivity.persistentIdentifier = NSUserActivityPersistentIdentifier(self.type)
            return userActivity
        }
        
        func makeShortcut() -> INShortcut {
            return INShortcut(userActivity: self.userActivity)
        }
```
> 그렇기에 처음 단축어를 생성할 때, 사용자의 활동을 나타내고, 시스템이 이를 기반으로 한 기능을
> 제공할 수 있도록 하는 클래스인 NSUserActivity를 먼저 생성해줍니다. 여기에 activityType에는
> 활동의 고유 식별자를 넣어주고, suggestedInvocationPhrase에는 Siri 제안 문구를 넣어서  INShortcut를 생성해주면 됩니다.

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
>다시 INUIAddVoiceShortcutButton으로 돌아와서 이제 버튼의  Add / Edit 창을 띄울 때
> 뷰컨트롤러의 delegate를 현재의 뷰 컨트롤러로 설정해줍니다.

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
> 그리고 프로토콜의 단축어 추가버튼을 누르고 끝나는 시점의 메소드를 새로 만들어진
> INVoiceShortcut을 이용해 단축어를 업데이트하게 정의해야합니다.

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
>그래서 새로 만들어진 단축어를 버튼의 단축어로 바꿔주고 INVoiceShortcutCenter에서
>이 단축어를 추가하거나 셋팅해주면 됩니다. 그리고 단축어를 수정하는 부분도 이와 같게 메소드를 정의해주면 됩니다.

```swift
ActivatedView(callProviderDelegate : callProviderDelegate)
                .onContinueUserActivity(UserActivityShortcutsManager.Shortcut.fakeCall.type, perform: { userActivity in
                    if let firstFakeCall = fakeCallSet.first {
                        let initialDelay = Double(firstFakeCall.delayTime)
                        let reAlertDelay = initialDelay + 120

                        DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay) {
                            triggerFakeCall(callProviderDelegate: callProviderDelegate, caller: firstFakeCall.caller)
                        }

                        if firstFakeCall.reAlret {
                            DispatchQueue.main.asyncAfter(deadline: .now() + reAlertDelay) {
                                triggerFakeCall(callProviderDelegate: callProviderDelegate, caller: firstFakeCall.caller)
                            }
                        }
                    }
                })
```
> 그리고 마직막으로 onContinueUserActivity 메소드를 사용해 단축어를 통해서
> 실행되는 NSUserActivity가 어떻게 동작할지 정의를 해주면됩니다.
> (Click) 여기서는 우리가 설정한 Type의 NSUserActivity에 대한 동작으로 가짜전화가 오게 설정되어있습니다.

