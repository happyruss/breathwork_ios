//
//  BreathworkManager.swift
//  Breathwork
//
//  Created by Mr Russell on 12/17/17.
//  Copyright © 2017 Russell Eric Dobda. All rights reserved.
//

import Foundation

class TrackTemplateFactory {
    
    public static var shared = TrackTemplateFactory()

    let appName = "Breathwork"
    let appUrl = "http://www.guidedmeditationtreks.com/healing-breathwork.html"
    
    var trackTemplates = [TrackTemplate]()
    
    public init() {

        trackTemplates.append(TrackTemplate(name: "Timer", shortName: "Timer"))
        
        trackTemplates.append(TrackTemplate(name: "Introduction", shortName: "Introduction", voiceUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "Introduction", ofType: "m4a")!)))

        trackTemplates.append(TrackTemplate(name: "Stepping Into Your Power", shortName: "Stepping Into Your Power", voiceUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "01-stepIntoPower-voice", ofType: "m4a")!), musicUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "01-stepIntoPower-music", ofType: "m4a")!), breathStartSeconds: 99, breathStopSeconds: 1396))

        trackTemplates.append(TrackTemplate(name: "Grieving and Celebrating a Loss", shortName: "Handling Loss", voiceUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "02-process-loss-voice", ofType: "m4a")!), musicUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "02-process-loss-music", ofType: "m4a")!), breathStartSeconds: 143, breathStopSeconds: 1428))

        trackTemplates.append(TrackTemplate(name: "Healing Sexual Abuse", shortName: "Healing Sexual Abuse", voiceUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "03-sex-healing-voice", ofType: "m4a")!), musicUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "03-sex-healing-music", ofType: "m4a")!), breathStartSeconds: 167, breathStopSeconds: 1620))

        trackTemplates.append(TrackTemplate(name: "Abundance", shortName: "Abundance", voiceUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "04-abundance-voice", ofType: "m4a")!), musicUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "04-abundance-music", ofType: "m4a")!), breathStartSeconds: 103, breathStopSeconds: 1652))

    }
}
