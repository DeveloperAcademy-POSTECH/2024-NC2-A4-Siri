//
//  ContentView.swift
//  kkusu
//
//  Created by sungkug_apple_developer_ac on 6/18/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var fakeCallSet: [FakeCallSetting]
    private var callProviderDelegate = FakeCallProviderDelegate()

    var body: some View {
        if fakeCallSet.isEmpty{
            MainView()
        } else {
            ActivatedView()
                .onContinueUserActivity(UserActivityShortcutsManager.Shortcut.fakeCall.type, perform: { userActivity in
                    triggerFakeCall(callProviderDelegate: callProviderDelegate, caller: fakeCallSet.first?.caller ?? "엄마")
                })
        }
    }
}

func triggerFakeCall(callProviderDelegate : FakeCallProviderDelegate, caller: String) {
    let uuid = UUID()
    let handle = caller
    callProviderDelegate.reportIncomingCall(uuid: uuid, handle: handle)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
