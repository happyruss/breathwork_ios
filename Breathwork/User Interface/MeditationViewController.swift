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
    
    
    
    @IBOutlet weak var appNameLabel: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playPauseButton.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func runMeditation(trackLevel: Int, noVoiceDurationSeconds: Int?) {
        let trackTemplate = breathworkManager.trackTemplateFactory.trackTemplates[trackLevel]
        meditationNameLabel.text = trackTemplate.name
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

