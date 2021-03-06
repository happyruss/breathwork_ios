//
//  Track.swift
//  Breathwork
//
//  Created by Mr Russell on 12/17/17.
//  Copyright © 2017 Russell Eric Dobda. All rights reserved.
//

import Foundation
import AVKit

class TrackTemplate {
    
    let name: String
    let shortName: String
    let voiceAsset: AVAsset?
    let musicAsset: AVAsset?
    let breathAsset: AVAsset
    let voiceDuration: Int?
    let breathDuration: Float64
    let breathStartSeconds: Int?
    let breathStopSeconds: Int?
    
    init(name: String, shortName: String, voiceUrl: URL? = nil, musicUrl: URL? = nil, breathStartSeconds: Int? = nil, breathStopSeconds: Int? = nil) {
        self.name = name
        self.shortName = shortName
        self.breathStartSeconds = breathStartSeconds
        self.breathStopSeconds = breathStopSeconds
        
        if (voiceUrl != nil) {
            self.voiceAsset = AVAsset(url: voiceUrl!)
            self.voiceDuration = Int(CMTimeGetSeconds(self.voiceAsset!.duration))
        } else {
            self.voiceAsset = nil
            self.voiceDuration = nil
        }
        
        if (musicUrl != nil) {
            self.musicAsset = AVAsset(url: musicUrl!)
        } else {
            self.musicAsset = nil
        }
        
        self.breathAsset = AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "BreathLoop", ofType: "m4a")!))
        self.breathDuration = CMTimeGetSeconds(self.breathAsset.duration)
    }
}
