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
    let requireMeditationsBeDoneInOrder = true
    let appUrl = "http://www.guidedmeditationtreks.com/breathwork"
    
    var trackTemplates = [TrackTemplate]()
    var minimumTrackDuration = 0
    
    public init() {

        trackTemplates.append(TrackTemplate(shortName: "Timer", name: "Timer", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "BreathLoop", ofType: "m4a")!), part2Url: nil))
        
        trackTemplates.append(TrackTemplate(shortName: "Introduction", name: "Introduction", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "Introduction", ofType: "m4a")!), part2Url: nil))

//        trackTemplates.append(TrackTemplate(shortName: "Shamatha", name: "Shamatha", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "01_Shamatha", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "01_Shamatha2", ofType: "m4a")!)))
//
//        trackTemplates.append(TrackTemplate(shortName: "Anapana", name: "Anapana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "02_Anapana", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "02_Anapana2", ofType: "m4a")!)))
//
//        trackTemplates.append(TrackTemplate(shortName: "Focused Anapana", name: "Focused Anapana", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "03_FocusedAnapana", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "03_FocusedAnapana2", ofType: "m4a")!)))
//
//        trackTemplates.append(TrackTemplate(shortName: "Breathwork", name: "Top To Bottom Breathwork", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "04_TopToBottom", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "04_TopToBottom2", ofType: "m4a")!)))
//
//        trackTemplates.append(TrackTemplate(shortName: "Scanning Breathwork", name: "Part By Part Breathwork", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "05_TopToBottomBottomToTop", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "05_TopToBottomBottomToTop2", ofType: "m4a")!)))
//
//        trackTemplates.append(TrackTemplate(shortName: "Symmetrical Breathwork", name: "Symmetrical Breathwork", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "06_Symmetrical", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "06_Symmetrical2", ofType: "m4a")!)))
//
//        trackTemplates.append(TrackTemplate(shortName: "Sweeping Breathwork", name: "Sweeping Breathwork", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "07_Sweeping", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "07_Sweeping2", ofType: "m4a")!)))
//
//        trackTemplates.append(TrackTemplate(shortName: "Piercing Breathwork", name: "In the Moment Breathwork", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "08_InTheMoment", ofType: "m4a")!), part2Url: URL(fileURLWithPath: Bundle.main.path(forResource: "08_InTheMoment2", ofType: "m4a")!)))
//
//        trackTemplates.append(TrackTemplate(shortName: "Metta", name: "Metta", part1Url: URL(fileURLWithPath: Bundle.main.path(forResource: "MetaPana", ofType: "m4a")!), part2Url: nil))

        trackTemplates.forEach { (trackTemplate) in
            if(trackTemplate.minimumDuration > minimumTrackDuration) {
                minimumTrackDuration = trackTemplate.minimumDuration
            }
        }
    }
    
}

