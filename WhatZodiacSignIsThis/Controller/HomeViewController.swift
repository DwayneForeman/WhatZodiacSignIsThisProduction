//
//  HomeViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/16/23.
//

import UIKit
import GameKit
import RevenueCat

class HomeViewController: UIViewController {

    static let shared = HomeViewController()
    
    @IBOutlet weak var soundButton: UIButton!
    
    var soundIsEnabled = true
    
    var scoreReporterValue = 0

    @IBOutlet weak var level2Button: UIButton!
    
    @IBOutlet weak var level3Button: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        AudioManager.shared.player?.stop()
        
        
        // Grab the value from userdefaulst storrage when view loads
        // We need to unwrap since there will be a chance this can be nil is user never switched the dound settings which will cause app to crash
        if let soundSettingFromUserDefaults = UserDefaults.standard.value(forKey: "SoundEnabled") {
            
            // set the value eequal to our glocal var soundIsEnabled
            soundIsEnabled = soundSettingFromUserDefaults as! Bool
            
        }
        
        // Now checking with soundEnbaled being false per above line so we can set the button image according upon load up
        if soundIsEnabled == false {
            soundButton.setImage(UIImage(named: "SpeakerButtonSlash.pdf"), for: .normal)
        } else {
            soundButton.setImage(UIImage(named: "SpeakerButton.pdf"), for: .normal)
        }
        
        
        scoreReporterValue = GameSetupManager.shared.gameCenterHighestScoreAbove100
        print("view dud load value \(scoreReporterValue)")
        
    }

    
    @IBAction func level2ButtonPressed(_ sender: UIButton) {
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if let error = error {
                print("Error fetching customer info: \(error.localizedDescription)")
            } else if let customerInfo = customerInfo {
                if customerInfo.entitlements.all["premium"]?.isActive == true {
                    print("User has premium entitlement. Dismissing.")
                    
                    self.performSegue(withIdentifier: "GoToGamePlayTwoViewController", sender: nil)
                   
                } else {
                    print("User does not have premium entitlement.")
                    
                    self.performSegue(withIdentifier: "GoToUpgradeWithDismissViewController", sender: nil)
                    
                }
            }
        }
    }
    
    
    
    @IBAction func level3ButtonPressed(_ sender: UIButton) {
        
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if let error = error {
                print("Error fetching customer info: \(error.localizedDescription)")
            } else if let customerInfo = customerInfo {
                if customerInfo.entitlements.all["premium"]?.isActive == true {
                    print("User has premium entitlement. Dismissing.")
                    
                    self.performSegue(withIdentifier: "GoToGamePlayThreeViewController", sender: nil)
                   
                } else {
                    print("User does not have premium entitlement.")
                    
                    self.performSegue(withIdentifier: "GoToUpgradeWithDismissViewController", sender: nil)
                    
                    }
                }
            }
        }

    
    
    
    
    
    
   
    
    func authenticateGameCenterUser() {
        
        // create a playerobject from GameKit
        let player = GKLocalPlayer.local
        
        // Now use that player to authenticate which will take a closure with view controller and an error
        player.authenticateHandler = { viewController, error in
            
            if error != nil {
                        print(error?.localizedDescription ?? "")
                    } else if let gameCenterLoginScreen = viewController {
                        // If there's no error and a view controller is provided, show the view controller
                        self.present(gameCenterLoginScreen, animated: true)
                    }
        }
        
        // Create a GKGameCenterViewController with an initial state
        let zodiacMemeLordsLeaderboard = GKGameCenterViewController(state: .leaderboards)
        zodiacMemeLordsLeaderboard.gameCenterDelegate = self
        present(zodiacMemeLordsLeaderboard, animated: true)
        
        
        let scoreReporter = GKScore(leaderboardIdentifier: "zodiacmemelords")
        
        scoreReporterValue = GameSetupManager.shared.gameCenterHighestScoreAbove100
        scoreReporter.value = Int64(scoreReporterValue)
        print("inside func value: \(scoreReporter.value)")

        let scoreArray : [GKScore] = [scoreReporter]
        
        GKScore.report(scoreArray)
    }
    
    
    
    // To update the score in other view controllers without authtication as we already have that above
    func updateGameCenterScore() {
        let leaderboardID = "zodiacmemelords" // Replace with your actual leaderboard identifier
        
        // Create a GKScore object with the new score
        let scoreReporter = GKScore(leaderboardIdentifier: leaderboardID)
        scoreReporter.value = Int64(GameSetupManager.shared.gameCenterHighestScoreAbove100)
        
        // Report the score
        GKScore.report([scoreReporter]) { error in
            if let error = error {
                print("Error reporting score to Game Center: \(error.localizedDescription)")
            } else {
                print("Score reported to Game Center successfully.")
            }
        }
    }
    
    
    
    
    
    @IBAction func anyButtonPressed(_ sender: UIButton) {
            AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
    }
    
    
    
    
    @IBAction func leaderboardButtonPressed(_ sender: UIButton) {
        
        
        authenticateGameCenterUser()
        
        
    }
    
    
  
    
    
    
    
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        
        soundIsEnabled = !soundIsEnabled
        
        // Save the audio seettings to user defaults after user toogles
        UserDefaults.standard.set(soundIsEnabled, forKey: "SoundEnabled")
        
        // Now checking with soundEnbaled being false per above line
            if soundIsEnabled == false {
                soundButton.setImage(UIImage(named: "SpeakerButtonSlash.pdf"), for: .normal)
            } else {
                soundButton.setImage(UIImage(named: "SpeakerButton.pdf"), for: .normal)
            }
        }
}


// conforming to the GKGameCenterControllerDelegate protocol so we can make it equal to ourself above
extension HomeViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
