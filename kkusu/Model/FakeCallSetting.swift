//
//  FakeCallSetting.swift
//  kkusu
//
//  Created by sungkug_apple_developer_ac on 6/18/24.
//

import Foundation
import SwiftData

@Model
class FakeCallSetting {
    @Attribute var delayTime: Int
    @Attribute var reAlret: Bool
    @Attribute var caller: String
    @Attribute var trigger: String
    


    init(delayTime: Int, reAlret: Bool, caller: String, trigger: String) {
        self.delayTime = delayTime
        self.reAlret = reAlret
        self.caller = caller
        self.trigger = trigger
    }
}
