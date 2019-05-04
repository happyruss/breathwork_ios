//
//  MeditationViewController.swift
//  Breathwork
//
//  Created by Mr Russell on 1/21/18.
//  Copyright © 2018 Russell Eric Dobda. All rights reserved.
//

import UIKit

class MeditationViewController: UIViewController, TrackDelegate {
    
    let breathworkManager = BreathworkManager.shared
    let trackTemplateFactory = TrackTemplateFactory.shared
    
    @IBOutlet weak var breathVolumeSlider: UISlider!
    @IBOutlet weak var breathSpeedSlider: UISlider!
    @IBOutlet weak var musicVolumeSlider: UISlider!
    @IBOutlet weak var voiceVolumeSlider: UISlider!

    @IBOutlet weak var breathVolumeLabel: UILabel!
    @IBOutlet weak var breathSpeedLabel: UILabel!
    @IBOutlet weak var musicVolumeLabel: UILabel!
    @IBOutlet weak var voiceVolumeLabel: UILabel!

    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var meditationNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var blackBackgroundButton: UIButton!
    @IBOutlet weak var backgroundButton: UIButton!
    
    private var isInMeditation = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func didChangeMusicVolume(_ sender: Any) {
        breathworkManager.setDefaultMusicVolume(musicVolume: (sender as! UISlider).value)
    }
    
    @IBAction func didChangeVoiceVolume(_ sender: Any) {
        breathworkManager.setDefaultVoiceVolume(voiceVolume: (sender as! UISlider).value)
    }
    
    @IBAction func didChangeBreathSpeed(_ sender: Any) {
        breathworkManager.setDefaultBreathSpeed(breathSpeed: (sender as! UISlider).value)
    }
    
    @IBAction func didChangeBreathVolume(_ sender: Any) {
        breathworkManager.setDefaultBreathVolume(breathVolume: (sender as! UISlider).value)
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      playPauseButton.isHidden = true
      self.breathVolumeSlider.setValue(breathworkManager.user.savedBreathVolume, animated: true)
      self.breathSpeedSlider.setValue(breathworkManager.user.savedBreathSpeed, animated: true)
      self.musicVolumeSlider.setValue(breathworkManager.user.savedMusicVolume, animated: true)
      self.voiceVolumeSlider.setValue(breathworkManager.user.savedVoiceVolume, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func runMeditation(trackLevel: Int, noVoiceDurationSeconds: Int?) {
        let trackTemplate = breathworkManager.trackTemplateFactory.trackTemplates[trackLevel]
        meditationNameLabel.text = trackTemplate.name
        let isActiveTrackIntroduction = trackTemplate.name == "Introduction"
        let isActiveTrackTimer = trackTemplate.name == "Timer"
        
        if (isActiveTrackIntroduction || isActiveTrackTimer) {
            musicVolumeSlider.isHidden = true
            musicVolumeLabel.isHidden = true
        } else {
            musicVolumeSlider.isHidden = false
            musicVolumeLabel.isHidden = false
        }
        
        if (isActiveTrackTimer) {
            voiceVolumeSlider.isHidden = true
            voiceVolumeLabel.isHidden = true
        } else {
            voiceVolumeSlider.isHidden = false
            voiceVolumeLabel.isHidden = false
        }
        
        if (isActiveTrackIntroduction) {
            breathSpeedSlider.isHidden = true
            breathSpeedLabel.isHidden = true
            breathVolumeSlider.isHidden = true
            breathVolumeLabel.isHidden = true
        } else {
            breathSpeedSlider.isHidden = false
            breathSpeedLabel.isHidden = false
            breathVolumeSlider.isHidden = false
            breathVolumeLabel.isHidden = false
        }
        
        breathworkManager.playTrackAtLevel(trackLevel: trackLevel, noVoiceDurationSeconds: noVoiceDurationSeconds)
        breathworkManager.activeTrack?.delegate = self
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: UIControl.State.normal)
        playPauseButton.isHidden = false
        isInMeditation = true
        breathworkManager.userStartedTrack()
    }
    
    @IBAction func didTapPlayPause(_ sender: Any) {
        breathworkManager.pauseOrResume()
        guard let activeTrack = breathworkManager.activeTrack else {
            return
        }
        if activeTrack.isPaused {
            playPauseButton.setImage(#imageLiteral(resourceName: "play-button"), for: UIControl.State.normal)
        } else {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: UIControl.State.normal)
        }
    }
    
    func goBackToMainScreen() {
        self.breathworkManager.stop()
        self.dismiss(animated: true) {
            self.breathworkManager.activeTrack?.delegate = nil
        }
    }
    
    @IBAction func didTapBlackBackgroundButton(_ sender: Any) {
        blackBackgroundButton.isHidden = true
    }
    
    @IBAction func didTapBackground(_ sender: Any) {
        blackBackgroundButton.isHidden = false
    }

    @IBAction func didTapBackButton(_ sender: UIButton) {
        if (isInMeditation) {
            let alert = UIAlertController(title: "Meditation Underway", message: "Would you like to stop the current session?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                self.goBackToMainScreen()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            goBackToMainScreen()
        }
    }

    
    func trackTimeRemainingUpdated(timeRemaining: Int) {
        breathworkManager.incrementTotalSecondsInMeditation()
        countdownLabel.text = String(format: "%d", arguments: [(timeRemaining / 60)]) + ":" + String(format: "%02d", arguments: [((timeRemaining % 3600) % 60)])
    }
    
    func trackEnded() {
        breathworkManager.userCompletedTrack()
        playPauseButton.isHidden = true
        blackBackgroundButton.isHidden = true
        isInMeditation = false
        self.goBackToMainScreen()
    }
}

