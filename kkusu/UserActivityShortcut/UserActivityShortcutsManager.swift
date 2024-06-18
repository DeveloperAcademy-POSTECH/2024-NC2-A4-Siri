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
        case blueview
        
        var type: String {
            
            switch self {
            case .fakeCall:
                return "com.kkusu.shortcuts.FakeCall"
            case .blueview:
                return "com.kkusu.shortcuts.blueview"
            }
        }
        
        var title: String {
            
            switch self {
            case .fakeCall:
                return "가짜전화 실행"
            case .blueview:
                return "블루뷰 실행"
            }
        }
        
        var invocationPhrase: String {
            
            switch self {
            case .fakeCall:
                return "전화해줘"
            case .blueview:
                return "블루뷰 보여줘"
            }
        }
        
        var userActivity: NSUserActivity {
            
            let userActivity = NSUserActivity(activityType: self.type)
            userActivity.title = self.title
            userActivity.suggestedInvocationPhrase = self.invocationPhrase
            
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
}
