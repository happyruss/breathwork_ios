//
//  ViewController.swift
//  Breathwork
//
//  Created by Mr Russell on 12/17/17.
//  Copyright © 2017 Russell Eric Dobda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let breathworkManager = BreathworkManager.shared
    let trackTemplateFactory = TrackTemplateFactory.shared
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var totalMeditationTimeLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.clipsToBounds = true

        self.titleLabel.text = trackTemplateFactory.appName
        let trackCount = trackTemplateFactory.trackTemplates.count
        
        for i in 1...trackCount - 1 {
            let trackTemplate = trackTemplateFactory.trackTemplates[i]
            let button = BreathworkButton()
            button.tag = i
            button.setTitle(trackTemplate.shortName, for: .normal)
            button.addTarget(self, action: #selector(self.didTapMeditationButton(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            button.sizeToFit()
            
            if i == 1 {
                let firstDots = view.viewWithTag(101) as UIView?
                
                let heightOfAButton = button.frame.size.height
                let heightOfDots = firstDots?.frame.size.height ?? 0
                
                let heightOfAnItem = heightOfAButton + heightOfDots + 20
                let stackViewHeight = heightOfAnItem * CGFloat(trackTemplateFactory.trackTemplates.count)
                
                for constraint in stackView.constraints {
                    if constraint.identifier == "stackViewHeightConstraint" {
                        constraint.constant = stackViewHeight
                    }
                }
                
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let medHours = breathworkManager.user.totalSecondsInMeditation / 3600
        totalMeditationTimeLabel.text = medHours == 1 ? "\(medHours) hour spent meditating" : "\(medHours) hours spent meditating"
        self.secureButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func secureButtons() {
        let totalTrackCount = trackTemplateFactory.trackTemplates.count
        
        timerButton.isEnabled = true

        var contentOffset = CGPoint(x:0, y:0)

        for i in 1...totalTrackCount - 1 {
            let button = view.viewWithTag(i) as! UIButton
            button.isEnabled = true
        }

        contentOffset = CGPoint(x:0, y:0)
        let bottomOffset = CGPoint(x:0, y:self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
        if (contentOffset.y > bottomOffset.y) {
            contentOffset = bottomOffset
        }
        scrollView.setContentOffset(contentOffset, animated: true)
    }
    
    func runMeditation(trackLevel: Int, noVoiceDurationSeconds: Int?) {
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeditationViewController") as! MeditationViewController
        self.present(mvc, animated: true) {
        }
        mvc.runMeditation(trackLevel: trackLevel, noVoiceDurationSeconds: noVoiceDurationSeconds)

    }
    
    fileprivate func presentInvalidCustomCountdownAlert(trackLevel: Int) {
        let alert = UIAlertController(title: "Work Dilligently", message: "Length for this meditation must be at least 1 minute.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            self.presentCustomCountdownAlert(trackLevel: trackLevel)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in
            self.presentCustomCountdownAlert(trackLevel: trackLevel)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func textFieldTouched(textField: UITextField) {
        textField.text = ""
    }
    
    fileprivate func presentCustomCountdownAlert(trackLevel: Int) {
        let alert2 = UIAlertController(title: "Meditate", message: "Enter a meditation length", preferredStyle: UIAlertController.Style.alert)

        let defaultDurationMinutes = self.breathworkManager.user.customMeditationDurationMinutes
        alert2.addTextField { (textField) in
            textField.text = String(defaultDurationMinutes)
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(self.textFieldTouched), for: UIControl.Event.touchDown)
        }
        alert2.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: { action in
            let value = alert2.textFields?[0].text
            guard value != nil else {
                self.presentInvalidCustomCountdownAlert(trackLevel: trackLevel)
                return
            }
            if let durationMinutes = Int(value!) {
                self.breathworkManager.setDefaultDurationMinutes(durationMinutes: durationMinutes)
                self.runMeditation(trackLevel: trackLevel, noVoiceDurationSeconds: durationMinutes * 60)
            } else {
                self.presentInvalidCustomCountdownAlert(trackLevel: trackLevel)
            }
        }))
        alert2.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in
        }))
        self.present(alert2, animated: true, completion: nil)
    }
    
    @objc func didTapMeditationButton(_ sender: UIButton) {
        let trackLevel = sender.tag
        if (trackLevel == 0) {
            presentCustomCountdownAlert(trackLevel: trackLevel)
        } else {
            self.runMeditation(trackLevel: trackLevel, noVoiceDurationSeconds: nil)
        }
    }
    
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: trackTemplateFactory.appUrl)!)
    }

}

