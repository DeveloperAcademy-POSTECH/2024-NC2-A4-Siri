//
//  SetView.swift
//  kkusu
//
//  Created by sungkug_apple_developer_ac on 6/18/24.
//

import SwiftUI
import SwiftData
import Intents

struct SetView: View {
    @Environment(\.modelContext) var modelContext
    @Query var fakeCallSet: [FakeCallSetting]
    let shortcut: INShortcut = UserActivityShortcutsManager.Shortcut.fakeCall.makeShortcut()
    
    @Binding var showModal: Bool
    @State private var selectedTime = 5
    @State private var remindMe = false
    @State private var selectedCaller = "엄마"
    @State private var selectedTrigger = "안녕하세요"
    
    let timeOptions = [5, 10, 15, 30, 60]
    let callerOptions = ["엄마", "아빠", "오빠", "누나", "꾸기", "이수"]
    let triggerOptions = ["안녕하세요", "도와주세요", "무슨 일이에요?"]


    var body: some View {
        ZStack {
            Color.black
            VStack{
                HStack{
                    Button {
                        showModal = false
                    } label: {
                        Text("취소")
                            .font(.system(size: 17))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    Text("설정 추가")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        changeFakeCallSet()
                    } label: {
                        Text("저장")
                            .font(.system(size: 17))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal)
                
                List {
                    Section(header: Text("설정")) {
                        TimePicker
                        ReAlret
                        CallerPicker
                        TriggerPicker
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(GroupedListStyle())
                .foregroundStyle(.white)
            }
            .padding(.top, 40)

//            SiriButton(shortcut: shortcut).frame(height: 34)

        }
        .ignoresSafeArea(.all)
        .onAppear(perform: {
            setState()
        })
    }
    
    //MARK: - 타이머 픽커
    var TimePicker : some View {
        
        Picker("타이머", selection: $selectedTime) {
            ForEach(timeOptions, id: \.self) { time in
                Text("\(time)초 후").tag(time)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .listRowBackground(Color.black)
        .listRowSeparatorTint(.gray)
        .onChange(of: selectedTime) {
            print("Selected time: 분")
        }
    }
    
    //MARK: - 다시 알림 토글
    var ReAlret : some View {
        Toggle(isOn: $remindMe) {
            Text("다시 알림")
        }
        .listRowBackground(Color.black)
        .listRowSeparatorTint(.gray)
        .onChange(of: remindMe) {
            
        }
    }
    
    //MARK: - 발신자 픽커
    var CallerPicker : some View {
        Picker("발신자", selection: $selectedCaller) {
            ForEach(callerOptions, id: \.self) { caller in
                Text(caller).tag(caller)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .listRowBackground(Color.black)
        .listRowSeparatorTint(.gray)
    }
    
    //MARK: - 트리거 문장 픽커
    var TriggerPicker : some View{
        Picker("트리거 문장", selection: $selectedTrigger) {
            ForEach(triggerOptions, id: \.self) { trigger in
                Text(trigger).tag(trigger)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .listRowBackground(Color.black)
        .listRowSeparatorTint(.gray)
    }
    
    //MARK: - swiftData model 값 설정 함수
    func changeFakeCallSet() {
        if fakeCallSet.isEmpty{
            let newFakeCallSetting = FakeCallSetting(delayTime: selectedTime, reAlret: remindMe, caller: selectedCaller, trigger: selectedTrigger)

            modelContext.insert(newFakeCallSetting)
        } else {
            
            guard let firstItem = fakeCallSet.first else { return }
            firstItem.delayTime = selectedTime
            firstItem.reAlret = remindMe
            firstItem.caller = selectedCaller
            firstItem.trigger = selectedTrigger
            
            do {
                try modelContext.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func setState() {
        selectedCaller = fakeCallSet.first?.caller ?? callerOptions.first!
        selectedTime = fakeCallSet.first?.delayTime ?? timeOptions.first!
        remindMe = fakeCallSet.first?.reAlret ?? false
        selectedTrigger = fakeCallSet.first?.trigger ?? triggerOptions.first!
    }
}

struct RedView_Previews: PreviewProvider {
    
    static var previews: some View {
        @State var showModal = true

        SetView(showModal: $showModal)
    }
}
