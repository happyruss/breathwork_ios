//
//  Track.swift
//  Breathwork
//
//  Created by Mr Russell on 12/17/17.
//  Copyright © 2017 Russell Eric Dobda. All rights reserved.
//

import Foundation
import AVKit

protocol TrackDelegate: class {
    func trackTimeRemainingUpdated(timeRemaining: Int)
    func trackEnded()
}

class Track {
    
    fileprivate var remainingTime = 0
    public var isPaused = false
    fileprivate var timer = Timer()
    
    fileprivate let trackTemplate: TrackTemplate
    
    fileprivate let voiceItem: AVPlayerItem?
    fileprivate let musicItem: AVPlayerItem?
    fileprivate let breathItem: AVPlayerItem?
    fileprivate let voicePlayer: AVPlayer?
    fileprivate let musicPlayer: AVPlayer?
    fileprivate let breathPlayer: AVQueuePlayer?
    
    fileprivate let totalDuration: Int
    fileprivate let isTimerOnly: Bool
    fileprivate let isIntroduction: Bool
    
    fileprivate var breathSpeed: Float = 1.0
    
    weak var delegate: TrackDelegate?
    
    init(trackTemplate: TrackTemplate, noVoiceDurationSeconds: Int?, breathVolume: Float, breathSpeed: Float, voiceVolume: Float, musicVolume: Float) {
        self.trackTemplate = trackTemplate
        self.breathSpeed = breathSpeed
        
        //initialize the audio files
        let assetKeys = [
            "playable",
            "hasProtectedContent"
        ]

        if (trackTemplate.voiceAsset != nil) {
            self.voiceItem = AVPlayerItem(asset: trackTemplate.voiceAsset!,
                                          automaticallyLoadedAssetKeys: assetKeys)
            self.voicePlayer = AVPlayer(playerItem: voiceItem)
        } else {
            self.voiceItem = nil
            self.voicePlayer = nil
        }
        
        if (trackTemplate.musicAsset != nil) {
            self.musicItem = AVPlayerItem(asset: trackTemplate.musicAsset!,
                                           automaticallyLoadedAssetKeys: assetKeys)
            self.musicPlayer = AVPlayer(playerItem: musicItem)
        } else {
            self.musicItem = nil
            self.musicPlayer = nil
        }
        
        if (trackTemplate.name == "Timer") {
            self.remainingTime = noVoiceDurationSeconds!
            self.totalDuration = noVoiceDurationSeconds!
            self.isTimerOnly = true
        } else {
            self.remainingTime = trackTemplate.voiceDuration!
            self.totalDuration = trackTemplate.voiceDuration!
            self.isTimerOnly = false
        }

        if (trackTemplate.name != "Introduction") {
            self.breathItem = AVPlayerItem(asset: trackTemplate.breathAsset)
            isIntroduction = false

            // Seamless looping not available until iOS 10
            // but i cant get this to work anyway
//            if #available(iOS 10.0, *) {
//                self.breathPlayer = AVQueuePlayer(items: [breathItem!])
//              _ = AVPlayerLooper(player: self.breathPlayer!, templateItem: self.breathItem!)
//            } else {
                self.breathPlayer = AVQueuePlayer(playerItem: breathItem)
                self.breathPlayer!.actionAtItemEnd = .none
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(playerItemDidReachEnd(notification:)),
                                                       name: .AVPlayerItemDidPlayToEndTime,
                                                       object: self.breathPlayer!.currentItem)
//            }
            setBreathVolume(breathVolume)
        } else {
            self.breathItem = nil
            self.breathPlayer = nil
            isIntroduction = true
        }
        
        if (trackTemplate.voiceAsset != nil) {
            setVoiceVolume(voiceVolume)
        }
        if (trackTemplate.musicAsset != nil) {
            setMusicVolume(musicVolume)
        }
        
    }
    
    //Seamless loop workaround for < iOS 10
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTimeMake(value:10, timescale:100))
        }
    }
    
    @objc func update() {
        self.remainingTime = self.remainingTime - 1
        delegate?.trackTimeRemainingUpdated(timeRemaining: self.remainingTime)
        
        guard self.remainingTime > 0 else {
            if (isTimerOnly) {
                self.breathPlayer!.pause()
            }
            timer.invalidate()
            delegate?.trackEnded()
            return
        }

        if (isTimerOnly) {
            setBreathSpeed(self.breathSpeed)
            return
        }
        
        if (isIntroduction) {
            self.voicePlayer!.play()
            return
        }
        
        // assume all 3 pieces are not null
        self.voicePlayer!.play()
        self.musicPlayer!.play()
        setBreathSpeed(self.breathSpeed)
    }
    
    fileprivate func setupAudio() {
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.spokenAudio, options: AVAudioSession.CategoryOptions.mixWithOthers)
            } else {
                // Fallback on earlier versions
                // Set category with options (iOS 9+) setCategory(_:options:)
                AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playback, with:  [])
            AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
            }
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    public func playFromBeginning() {
        setupAudio()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        self.isPaused = false
        if (self.voicePlayer != nil) {
            self.voicePlayer!.play()
        }
        if (self.musicPlayer != nil) {
            self.musicPlayer!.play()
        }
    }
    
    func pause() {
        timer.invalidate()
        self.isPaused = true
        if (self.voicePlayer != nil && self.voicePlayer!.rate != 0 && self.voicePlayer!.error == nil) {
            self.voicePlayer!.pause()
        }
        if (self.musicPlayer != nil && self.musicPlayer!.rate != 0 && self.musicPlayer!.error == nil) {
            self.musicPlayer!.pause()
        }
        if (self.breathPlayer != nil && self.breathPlayer!.rate != 0 && self.breathPlayer!.error == nil) {
            self.breathPlayer!.pause()
        }
    }
    
    func resume() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        self.isPaused = false
    }

    public func stop() {
        self.remainingTime = self.totalDuration;
        self.isPaused = false
        timer.invalidate()
    }
    
    public func pauseOrResume() {
        if (self.isPaused) {
            self.resume()
        } else {
            self.pause()
        }
    }
    
    public func setBreathVolume(_ value:Float) {
        breathPlayer?.volume = value
    }
    public func setBreathSpeed(_ value:Float) {
        breathSpeed = value
        let currentPosition = self.totalDuration - self.remainingTime
        var shouldBePlaying = isTimerOnly
        if (!isTimerOnly) {
            shouldBePlaying = currentPosition > trackTemplate.breathStartSeconds! && currentPosition < trackTemplate.breathStopSeconds!
        }
        shouldBePlaying = shouldBePlaying && !self.isPaused
        if (shouldBePlaying) {
            //      formula to convert scale
            //      ((Input - InputLow) / (InputHigh - InputLow)) * (OutputHigh - OutputLow) + OutputLow;
            let proposedBreathSpeed = ((value - 0.0) / (1.0 - 0.0)) * (1.25 - 0.75) + 0.75
            self.breathPlayer!.rate = proposedBreathSpeed
        } else {
            self.breathPlayer!.rate = 0
        }
    }
    public func setMusicVolume(_ value:Float) {
        musicPlayer?.volume = value
    }
    public func setVoiceVolume(_ value:Float) {
        voicePlayer?.volume = value
    }
}
