//
//  ComMoudle1.swift
//  mutiple_channel_demo
//
//  Created by iReader on 2025/3/4.
//
import SnapKit

class ComMoudle1 {
    
    let appConfig = GlobalConfig()
    
    func introduce() {
        debugPrint("I'm module one")
#if CHANNEL_A
        debugPrint("I'm in the channel A")
#elseif CHANNEL_B
        debugPrint("I'm in the channel B")
#endif
        debugPrint(appConfig.color)
    }
    
}
