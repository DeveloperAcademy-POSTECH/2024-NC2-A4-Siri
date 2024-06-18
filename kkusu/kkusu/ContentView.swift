//
//  ContentView.swift
//  kkusu
//
//  Created by sungkug_apple_developer_ac on 6/18/24.
//

import SwiftUI

struct ContentView: View {
    private var callProviderDelegate = FakeCallProviderDelegate()
    @State var showRedView: Bool = false

    private func triggerFakeCall() {
        let uuid = UUID()
        let handle = "엄마" // 가짜 전화 번호
        callProviderDelegate.reportIncomingCall(uuid: uuid, handle: handle)
    }
    var body: some View {
        VStack {
            Button(action: {
                showRedView.toggle()
            }, label: {
                Label("Show a RedView", systemImage: "eye.circle.fill")
            })
            .foregroundColor(.red)
        }
        .padding()
        .sheet(isPresented: $showRedView, content: {
            RedView()
        })
        .onContinueUserActivity(UserActivityShortcutsManager.Shortcut.fakeCall.type, perform: { userActivity in
            showRedView.toggle()
            triggerFakeCall()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
