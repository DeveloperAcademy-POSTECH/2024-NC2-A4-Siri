//
//  RedView.swift
//  kkusu
//
//  Created by sungkug_apple_developer_ac on 6/18/24.
//

import SwiftUI
import Intents

struct RedView: View {
    
    let shortcut: INShortcut = UserActivityShortcutsManager.Shortcut.fakeCall.makeShortcut()
    
    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
        
            SiriButton(shortcut: shortcut).frame(height: 34)
        }
    }
}

struct RedView_Previews: PreviewProvider {
    static var previews: some View {
        RedView()
    }
}
