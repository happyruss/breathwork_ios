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
        self.user.savedBreathVolume = (defaults.value(forKey: "savedBreathVolume") != nil) ? defaults.float(forKey: "savedBreathVolume") : 0.5
        self.user.savedBreathSpeed = (defaults.value(forKey: "savedBreathSpeed") != nil) ? defaults.float(forKey: "savedBreathSpeed") : 0.5
        self.user.savedVoiceVolume = (defaults.value(forKey: "savedVoiceVolume") != nil) ? defaults.float(forKey: "savedVoiceVolume") : 0.5
        self.user.savedMusicVolume = (defaults.value(forKey: "savedMusicVolume") != nil) ? defaults.float(forKey: "savedMusicVolume") : 0.5
    }
    
    public func playTrackAtLevel(trackLevel: Int, noVoiceDurationSeconds: Int?) {
        if (self.activeTrack != nil) {
            self.activeTrack!.stop()
            self.activeTrack = nil
            self.activeTrackLevel = 0
        }
        self.activeTrackLevel = trackLevel
        let trackTemplate = trackTemplateFactory.trackTemplates[trackLevel]
        self.activeTrack = Track(trackTemplate: trackTemplate, noVoiceDurationSeconds: noVoiceDurationSeconds, breathVolume: self.user.savedBreathVolume, breathSpeed: self.user.savedBreathSpeed, voiceVolume: self.user.savedVoiceVolume, musicVolume: self.user.savedMusicVolume)
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
    
    public func userStartedTrack() {
    }

    public func userCompletedTrack() {
    }
    
    public func setDefaultDurationMinutes(durationMinutes: Int) {
        defaults.setValue(durationMinutes, forKey: "SavedCustomMeditationDurationMinutes")
        self.user.customMeditationDurationMinutes = durationMinutes
    }
    
    public func incrementTotalSecondsInMeditation() {
        self.user.totalSecondsInMeditation = self.user.totalSecondsInMeditation + 1
        defaults.setValue(self.user.totalSecondsInMeditation, forKey: "TotalSecondsInMeditation")
    }
    
    public func setDefaultBreathVolume(breathVolume: Float) {
        defaults.setValue(breathVolume, forKey: "savedBreathVolume")
        self.user.savedBreathVolume = breathVolume
        activeTrack?.setBreathVolume(breathVolume)
    }

    public func setDefaultBreathSpeed(breathSpeed: Float) {
        defaults.setValue(breathSpeed, forKey: "savedBreathSpeed")
        self.user.savedBreathSpeed = breathSpeed
        activeTrack?.setBreathSpeed(breathSpeed)
    }

    public func setDefaultVoiceVolume(voiceVolume: Float) {
        defaults.setValue(voiceVolume, forKey: "savedVoiceVolume")
        self.user.savedVoiceVolume = voiceVolume
        activeTrack?.setVoiceVolume(voiceVolume)
    }

    public func setDefaultMusicVolume(musicVolume: Float) {
        defaults.setValue(musicVolume, forKey: "savedMusicVolume")
        self.user.savedMusicVolume = musicVolume
        activeTrack?.setMusicVolume(musicVolume)
    }
}
