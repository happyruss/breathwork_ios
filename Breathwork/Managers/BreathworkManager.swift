//
//  BreathworkManager.swift
//  Breathwork
//
//  Created by Mr Russell on 12/17/17.
//  Copyright © 2017 Russell Eric Dobda. All rights reserved.
//

import Foundation

class BreathworkManager {
    
    public static var shared = BreathworkManager()
    
    let user: User
    var activeTrack: Track?
    fileprivate var activeTrackLevel = 0
    fileprivate let defaults = UserDefaults()

    let trackTemplateFactory = TrackTemplateFactory.shared
    
    public init() {
        self.user = User()
        self.user.totalSecondsInMeditation = defaults.integer(forKey: "TotalSecondsInMeditation")
        let savedCustomMeditationDurationMinutes = defaults.integer(forKey: "SavedCustomMeditationDurationMinutes")
        defaults.setValue(savedCustomMeditationDurationMinutes, forKey: "SavedCustomMeditationDurationMinutes")
        self.user.customMeditationDurationMinutes = savedCustomMeditationDurationMinutes
    }
    
    public func playTrackAtLevel(trackLevel: Int, noVoiceDurationSeconds: Int?) {
        if (self.activeTrack != nil) {
            self.activeTrack!.stop()
            self.activeTrack = nil
            self.activeTrackLevel = 0
        }
        self.activeTrackLevel = trackLevel
        let trackTemplate = trackTemplateFactory.trackTemplates[trackLevel]
        self.activeTrack = Track(trackTemplate: trackTemplate, noVoiceDurationSeconds: noVoiceDurationSeconds)
        self.activeTrack!.playFromBeginning()
    }
    
    public func pauseOrResume() {
        guard activeTrack != nil else {
            return
        }
        activeTrack!.pauseOrResume()
    }
    
    public func stop() {
        guard activeTrack != nil else {
            return
        }
        activeTrack!.stop()
        activeTrack = nil
    }
    
    private func setTrackCompletetion() {
    }

    public func userStartedTrack() {
        self.setTrackCompletetion()
    }

    public func userCompletedTrack() {
        self.setTrackCompletetion()
    }
    
    public func setDefaultDurationMinutes(durationMinutes: Int) {
        defaults.setValue(durationMinutes, forKey: "SavedCustomMeditationDurationMinutes")
        self.user.customMeditationDurationMinutes = durationMinutes
    }
    
    public func incrementTotalSecondsInMeditation() {
        self.user.totalSecondsInMeditation = self.user.totalSecondsInMeditation + 1
        defaults.setValue(self.user.totalSecondsInMeditation, forKey: "TotalSecondsInMeditation")
    }
    
}
