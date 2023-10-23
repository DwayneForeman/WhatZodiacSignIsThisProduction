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

class GamePlayOneViewController: UIViewController {
    
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
     
        GameOverViewController.shared.checkForPremiumUser(viewController: self)
        
        print("GAMMMMMMMEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE ONNEEEEEEE VIEWWWW DIDDDD LOAD")
        
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
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        GameOverViewController.shared.checkForPremiumUser()
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
    }
    
    
    //MARK: - Action Functions
    
    @IBAction func highlightSelectedButton(_ sender: UIButton) {
        
        GameSetupManager.shared.highlightSelectedButtonHelper(sender: sender, theUsersSelectedAnswer: usersSelectedAnswer, regOrSmallCorrectSignKeyFromJokesArray: correctSignKeyFromJokesArray, answerButtons: answerButtons, myStreaks: streaks, scoreLabel: scoreLabel, viewController: self)
        
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
        GameOverViewController.shared.checkForPremiumUser()

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
}
