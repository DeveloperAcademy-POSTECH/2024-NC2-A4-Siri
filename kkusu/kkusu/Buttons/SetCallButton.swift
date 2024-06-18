//
//  SetCallButton.swift
//  kkusu
//
//  Created by sungkug_apple_developer_ac on 6/18/24.
//

import SwiftUI

struct SetCallButton: View {
    @State private var isLocked = true
    @Binding var showModal: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                BackgroundComponent()
                DraggingComponent(isLocked: $isLocked, showModal: $showModal, maxWidth: geometry.size.width - 10)
            }
        }
        .padding(.horizontal, 26)
        .frame(height: 87)
    }

}

struct BackgroundComponent: View {
    
    var body: some View {
        ZStack(alignment: .leading)  {
            Image("sliderButton")
                .resizable()
                .scaledToFill()
        }
    }
    
}

struct DraggingComponent: View {
    @Binding var isLocked: Bool
    @Binding var showModal: Bool
    let maxWidth: CGFloat
    
    private let minWidth = CGFloat(80)
    @State private var offsetX: CGFloat = 0
    
    var body: some View {
        Image("callIcon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 80, height: 80)
            .offset(x: offsetX)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard isLocked else { return }
                        let translation = value.translation.width
                        if translation > 0 {
                            offsetX = min(translation, maxWidth - minWidth)
                        }
                    }
                    .onEnded { value in
                        guard isLocked else { return }
                        if offsetX < maxWidth - minWidth {
                            offsetX = 0
                            UINotificationFeedbackGenerator().notificationOccurred(.warning)
                        } else {
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            withAnimation(.spring().delay(0.5)) {
                                isLocked = false
                                showModal = true
                            }
                        }
                    }
            )
            .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0), value: offsetX)
            .padding(5)
            .onChange(of: showModal) { oldValue, newValue in
                if !showModal {
                    offsetX = 0
                    isLocked = true
                }
            }
    }
}

//#Preview {
//    SetCallButton(showModal: false)
//}
