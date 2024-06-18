//
//  ActivatedView.swift
//  kkusu
//
//  Created by sungkug_apple_developer_ac on 6/18/24.
//

import SwiftUI
import SwiftData

struct ActivatedView: View {
    @Environment(\.modelContext) var modelContext
    @Query var fakeCallSet: [FakeCallSetting]
    private var callProviderDelegate = FakeCallProviderDelegate()
    
    var body: some View {
        ZStack{
            GifView("checkBackground")
                .frame(height: 990)
            VStack{
                Text("말해보세요")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .padding(.top, 424)
                Text("\(fakeCallSet.first?.trigger ?? "값이 설정되어 있지 않아요")")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.top, 1)
                Spacer()
                HStack{
                    Button(action: {
                        guard let model = fakeCallSet.first else {
                            return
                        }
                        modelContext.delete(model)
                    }, label: {
                        VStack{
                            Image("재설정버튼")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 79, height: 79)
                            Text("재설정")
                                .foregroundStyle(.black)
                        }
                    })
                    Spacer()
                    Button(action: {
                        triggerFakeCall(callProviderDelegate: callProviderDelegate, caller: fakeCallSet.first?.caller ?? "엄마")
                    }, label: {
                        VStack{
                            Image("미리보기버튼")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 79, height: 79)
                            Text("미리보기")
                                .foregroundStyle(.black)
                        }
                    })
                }
                .padding(.bottom, 140)
                .padding(.horizontal, 39)
            }
        }
    }
}

#Preview {
    ActivatedView()
}
