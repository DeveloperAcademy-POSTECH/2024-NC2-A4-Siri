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
    var callProviderDelegate = FakeCallProviderDelegate()

    var body: some View {
        if fakeCallSet.isEmpty{
            MainView()
        } else {
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
