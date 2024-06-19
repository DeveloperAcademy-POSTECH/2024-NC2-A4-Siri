//
//  UserActivityShortcutsManager.swift
//  kkusu
//
//  Created by sungkug_apple_developer_ac on 6/18/24.
//

import Intents

final class UserActivityShortcutsManager {
        
    public enum Shortcut: CaseIterable {
        case fakeCall
        
        var type: String {
            
            switch self {
            case .fakeCall:
                return "com.kkusu.shortcuts.FakeCall"
            }
        }
        
        var title: String {
            
            switch self {
            case .fakeCall:
                return "가짜전화 실행"
            }
        }
        
        var invocationPhrase: String {
            
            switch self {
            case .fakeCall:
                return "전화해줘"
            }
        }
        
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
    }
    
    static func setup() {
        var shortcuts: [INShortcut] = []
        for shortcut in Shortcut.allCases {
            shortcuts.append(shortcut.makeShortcut())
        }
        
        INVoiceShortcutCenter.shared.setShortcutSuggestions(shortcuts)
        
        print("complete setup INVoiceShortcutCenter")
    }
    
    static func getExistingVoiceShortcut(for type: String, completion: @escaping (INShortcut?) -> Void) {
        INVoiceShortcutCenter.shared.getAllVoiceShortcuts { (shortcuts, error) in
            if let error = error {
                print("Error fetching voice shortcuts: \(error)")
                completion(nil)
            } else {
                let matchingShortcuts = shortcuts?.filter { $0.shortcut.userActivity?.activityType == type } ?? []
                print("Number of shortcuts with type \(type): \(matchingShortcuts.count)")
                
                if let firstMatchingShortcut = matchingShortcuts.first {
                    print(firstMatchingShortcut.invocationPhrase)
                    let newSortcut = INShortcut(userActivity: firstMatchingShortcut.shortcut.userActivity!)
                    newSortcut.userActivity?.suggestedInvocationPhrase = firstMatchingShortcut.invocationPhrase
                    completion(newSortcut)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
