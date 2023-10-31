//
//  ViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 8/19/23.
//

import UIKit
import SAConfettiView
import AVFoundation
import CoreData
import StoreKit
import GoogleMobileAds

class GamePlayOneViewController: UIViewController, GADFullScreenContentDelegate {
    
    //MARK: - Variables
    
    @IBOutlet weak var jokesLabel: UILabel!
    
    @IBOutlet var answerButtons: [UIButton]!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var currentHotStreakHelper = GameSetupManager.shared.currentHotStreakHelper
    
    var correctSignKeyFromJokesArray: String = ""
    
    var usersSelectedAnswer: String = ""
    
    var correctAnswer: String = ""
    
    var streaks = [String]()
    
    var answerButtonNames = ["AquariusButton", "AriesButton", "CancerButton", "CapricornButton", "GeminiButton", "LeoButton", "LibraButton", "PiscesButton", "SagittariusButton", "ScorpioButton", "TaurusButton", "VirgoButton"]
    
    static let shared = GamePlayOneViewController()

    
    //MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firbase Function
        //fetchInitialJoke()
        
        // Load an interstitial ad
        loadInterstitialAd()
        
        // Show ads based on upgade status
        showAdsBasedOnUpgradeStatus()
        
        // Check for upgrade status
        UpgradeManager.shared.checkForPremiumUser()
        
        
        // Retrieve losses from UserDefaults
        if let losses = UserDefaults.standard.value(forKey: "losses") as? Int {
            GameSetupManager.shared.losses = losses
            print("Losses from ViewDidLoad: \(losses)")
        }

        // Retrieve isUpgraded from UserDefaults
        if let isUpgraded = UserDefaults.standard.value(forKey: "IsUpgraded") as? Bool {
            GameSetupManager.shared.isUpgraded = isUpgraded
            print("IsUpgraded from ViewDidLoad: \(isUpgraded)")
        } else {
            // Default to false if the key doesn't exist in UserDefaults
            GameSetupManager.shared.isUpgraded = false
            print("IsUpgraded not found in UserDefaults. Setting to false.")
        
        }

        // For THIS GamePlayOneVC, If the user is NOT upgraded and their losses equal 1, then we need to pop up the UpGradeWithDismissVC
        if GameSetupManager.shared.isUpgraded == false && GameSetupManager.shared.losses == 1 {
            print("Losses equal 1. Showing UpgradeWithDismissVC.")
            self.performSegue(withIdentifier: "GoToGameOverViewController", sender: nil)
        }

        
        
        // Hideing the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Capture, Filter and Assign to our components of this ViewController from CoreData fetch reults when teh view loads
        GameSetupManager.shared.captureAndFilterFetchResults(scoreLabel: scoreLabel)
        
        print("view did load \(currentHotStreakHelper)")
        
        // Start new round
        newRound()
        
        // Grab file to run/see our SQL Lite datbase in action
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Set the flag to false so the a new prompt can be shown when the user gets another high score
        UserDefaults.standard.set(false, forKey: "PromptWasShown")
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        AudioManager.shared.player?.stop()

    }
    
    
    // Save before view dissapears
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //AudioManager.shared.player.stop()
        print(GameSetupManager.shared.scoreLabelInt)
        print(currentHotStreakHelper)
        // Save score and streak to core data when we leave the screen
        CoreDataManager.shared.addScoreAndStreak(score: GameSetupManager.shared.scoreLabelInt, streak: CoreDataManager.shared.fetchLatestStreak()!)
        print(currentHotStreakHelper)
        
        // Retrieve isUpgraded from UserDefaults
        if let isUpgraded = UserDefaults.standard.value(forKey: "IsUpgraded") as? Bool {
            GameSetupManager.shared.isUpgraded = isUpgraded
            print("IsUpgraded from ViewDidLoad: \(isUpgraded)")
        } else {
            // Default to false if the key doesn't exist in UserDefaults
            GameSetupManager.shared.isUpgraded = false
            print("IsUpgraded not found in UserDefaults. Setting to false.")
        
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        UpgradeManager.shared.checkForPremiumUser()
        
      
    }
    
    func newRound() {
            self.view.bringSubviewToFront(self.view)
            AudioManager.shared.playSound(soundName: "WaitingForAnswerSound", shouldLoop: true)
            GameSetupManager.shared.getRandomJoke()
            correctSignKeyFromJokesArray = GameSetupManager.shared.correctSignKeyFromJokesArray
            jokesLabel.text = GameSetupManager.shared.jokesLabelText
            GameSetupManager.shared.getAnswers(totalAnswersToDisplay: 4, answerButtons: answerButtons, answerButtonNames: answerButtonNames, typeSmall: false)
            GameSetupManager.shared.scoreLabelInt = Int(scoreLabel.text!)!
            GameSetupManager.shared.getHotStreaks(streak: streaks, viewController: self)
            GameSetupManager.shared.gameOver(scoreLabel: scoreLabel, viewController: self, answerButtons: answerButtons)
            CoreDataManager.shared.addScoreAndStreak(score: GameSetupManager.shared.scoreLabelInt, streak: currentHotStreakHelper)
            GameSetupManager.shared.ballonPressed = false
            GameSetupManager.shared.highScoreAlert(viewController: self, scoreLabel: scoreLabel)
            
        }
    
    
    

    
    
    
    
    //MARK: - Firebase FireStore Functions
  
    /*
    
    func newRound() {
        self.view.bringSubviewToFront(self.view)
        AudioManager.shared.playSound(soundName: "WaitingForAnswerSound", shouldLoop: true)
        
        // Fetch the initial joke
        GameSetupManager.shared.getRandomJoke { [self] randomJoke in
            if let randomJoke = randomJoke {
                self.correctSignKeyFromJokesArray = GameSetupManager.shared.correctSignKeyFromJokesArray
                self.jokesLabel.text = randomJoke
                
                // Continue with other actions related to the new round
                GameSetupManager.shared.getAnswers(totalAnswersToDisplay: 4, answerButtons: self.answerButtons, answerButtonNames: self.answerButtonNames, typeSmall: false)
                GameSetupManager.shared.scoreLabelInt = Int(scoreLabel.text!)!
                GameSetupManager.shared.getHotStreaks(streak: streaks, viewController: self)
                GameSetupManager.shared.gameOver(scoreLabel: scoreLabel, viewController: self, answerButtons: answerButtons)
                CoreDataManager.shared.addScoreAndStreak(score: GameSetupManager.shared.scoreLabelInt, streak: currentHotStreakHelper)
                GameSetupManager.shared.ballonPressed = false
            } else {
                // Handle the case where no joke was found or an error occurred
                self.jokesLabel.text = "Failed to fetch a joke. Please try again."
            }
        }
    }
    
    func fetchInitialJoke() {
        // Show a loading indicator or message to the user
        jokesLabel.text = "Loading... 😈"
        
        // Fetch the initial joke
        GameSetupManager.shared.getRandomJoke { [weak self] randomJoke in
            DispatchQueue.main.async { // Switch to the main queue
                if let randomJoke = randomJoke {
                    // Update the UI with the fetched joke
                    self?.jokesLabel.text = randomJoke
                } else {
                    // Handle the case where no joke was found or an error occurred
                    self?.jokesLabel.text = "Failed to fetch a joke. Please try again."
                }
            }
        }
    }
     
    */
    
    //MARK: - Action Functions
    
    @IBAction func highlightSelectedButton(_ sender: UIButton) {
        
        GameSetupManager.shared.highlightSelectedButtonHelper(sender: sender, theUsersSelectedAnswer: usersSelectedAnswer, regOrSmallCorrectSignKeyFromJokesArray: correctSignKeyFromJokesArray, answerButtons: answerButtons, myStreaks: streaks, scoreLabel: scoreLabel, viewController: self)
        
        GameSetupManager.shared.highScoreAlert(viewController: self, scoreLabel: scoreLabel)
        
        // Set the newRoundCallback in GameSetupManager to start a new round
        // Weak catptures self to make it a weak refernce to avoid memeory leaks and then it is used again in the body as an optional to call newRound()
        // We are using the function we created in GameSteupManager to equal it to a closure function which will run this View Controllers current newRound, hence self.newRound()
        GameSetupManager.shared.newRoundCallback = { [weak self] in
                   self?.newRound()
               }
    
    }
    
    @IBAction func ballonPressed(_ sender: UIButton) {
       
        // Print a message
         print("Ballon button Tapped")
        
        // Check if the user has just upgraded
        UpgradeManager.shared.checkForPremiumUser()

        print(GameSetupManager.shared.isUpgraded)
         // Check if the user is upgraded or hasn't incurred any losses
         if GameSetupManager.shared.isUpgraded == true || GameSetupManager.shared.losses == 0 {
             // Call the balloon helper function to use the lifeline
             GameSetupManager.shared.ballonHelper(numOfIncorrectAnswersToRemove: 2, answerButtons: answerButtons, scoreLabelText: scoreLabel, smallOrRegCorrectSignKeyFromJokesArray: correctSignKeyFromJokesArray, viewController: self)
             print("\(GameSetupManager.shared.scoreLabelInt) from VC")
         }


     }
    
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        
        // Play sound when button pushed
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
       performSegue(withIdentifier: "GoToHomeViewController", sender: nil)
    }
    
    
    
    //MARK: - Setup Interstitial Ads to diplay every 3 min
    
    let testAds = "ca-app-pub-3940256099942544/4411468910"
    let wsitInterstitialAdOct2023Ads = "ca-app-pub-2471263905843170/4011229361"
    private var interstitialAd: GADInterstitialAd?
    private var timer: Timer?

    // Function to load an interstitial ad
        func loadInterstitialAd() {
            // Replace with your interstitial ad unit ID
            let adUnitID = wsitInterstitialAdOct2023Ads
            let request = GADRequest()

            GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) { [weak self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad: \(error.localizedDescription)")
                    return
                }

                self?.interstitialAd = ad
                self?.interstitialAd?.fullScreenContentDelegate = self
            }
        }

        // Function to display the interstitial ad
        func showInterstitialAd() {
            if let interstitialAd = interstitialAd {
                interstitialAd.present(fromRootViewController: self)
            } else {
                print("Interstitial ad is not ready yet.")
            }
        }

        // Function to start the timer for displaying ads every 3 minutes
        func startAdTimer() {
            // Timer to display the ad every 3 minutes
            timer = Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: #selector(displayAd), userInfo: nil, repeats: true)
        }

        // Selector for displaying the ad
        @objc func displayAd() {
            showInterstitialAd()
        }

     
    func showAdsBasedOnUpgradeStatus() {

        // Check for upgrade status
        UpgradeManager.shared.checkForPremiumUser()
        
        // Retrieve isUpgraded from UserDefaults
        if let isUpgraded = UserDefaults.standard.value(forKey: "IsUpgraded") as? Bool {
            GameSetupManager.shared.isUpgraded = isUpgraded
            print("User IS upgraded. They are FREE fom ads")
            
        } else {
            // Default to false if the key doesn't exist in UserDefaults
            GameSetupManager.shared.isUpgraded = false
            
            // Start the timer to display the ad every 3 minutes
            startAdTimer()
            
            print("User is not upgraded. They will see ads.")
        
        }
    }
}


//MARK: - Handle Interstitial Ad Events

extension GamePlayOneViewController {
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
               // Called when the interstitial ad is presented full-screen.
           }

           func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
               // Called when the interstitial ad is dismissed.
               // Load another ad or perform other actions here.
               
               // Resume Audio
               AudioManager.shared.playSound(soundName: "WaitingForAnswerSound", shouldLoop: true)
               
               // Automatically load another ad
               loadInterstitialAd()
           }

           func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
               // Called when there's an error presenting the interstitial ad.
               print("Failed to present interstitial ad: \(error.localizedDescription)")
           }
       
}

