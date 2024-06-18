//
//  kkusuApp.swift
//  kkusu
//
//  Created by sungkug_apple_developer_ac on 6/18/24.
//

import SwiftUI

@main
struct kkusuApp: App {
    
    init() {
        UserActivityShortcutsManager.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
