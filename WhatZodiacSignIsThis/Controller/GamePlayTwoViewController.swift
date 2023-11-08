//
//  GamePlayTwoViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/16/23.
//

import UIKit
import SAConfettiView
import AVFoundation
import CoreData

class GamePlayTwoViewController: UIViewController {

    //MARK: - Variables
    
    @IBOutlet weak var jokesLabel: UILabel!
    
    @IBOutlet var answerButtons: [UIButton]!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    //var currentHotStreakHelper = GameSetupManager.shared.currentHotStreakHelper
    
    var smallCorrectSignKeyFromJokesArray: String = ""
    
    var usersSelectedAnswer: String = ""
    
    var correctAnswer: String = ""
    
    var streaks = [String]()
    
    var answerButtonNames = ["SmallAquariusButton", "SmallAriesButton", "SmallCancerButton", "SmallCapricornButton", "SmallGeminiButton", "SmallLeoButton", "SmallLibraButton", "SmallPiscesButton", "SmallSagittariusButton", "SmallScorpioButton", "SmallTaurusButton", "SmallVirgoButton"]
    
    
    
    
    
    //MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        
        // Firbase Function
        //fetchInitialJoke()
        
        UpgradeManager.shared.checkForPremiumUser()
        
        // Capture, Filter and Assign to our components of this ViewController from CoreData fetch reults when teh view loads
        GameSetupManager.shared.captureAndFilterFetchResults(scoreLabel: scoreLabel)
      
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
    
    func newRound() {
           self.view.bringSubviewToFront(self.view)
           // Play waiting for answer sound
           AudioManager.shared.playSound(soundName: "WaitingForAnswerSound", shouldLoop: true)
           GameSetupManager.shared.getRandomJoke()
           smallCorrectSignKeyFromJokesArray = GameSetupManager.shared.smallCorrectSignKeyFromJokesArray
           jokesLabel.text = GameSetupManager.shared.jokesLabelText
           GameSetupManager.shared.getAnswers(totalAnswersToDisplay: 8, answerButtons: answerButtons, answerButtonNames: answerButtonNames, typeSmall: true)
           GameSetupManager.shared.scoreLabelInt = Int(scoreLabel.text!)!
           GameSetupManager.shared.getHotStreaks(streak: streaks, viewController: self)
           GameSetupManager.shared.gameOver(scoreLabel: scoreLabel, viewController: self, answerButtons: answerButtons)
           CoreDataManager.shared.addScoreAndStreak(score: GameSetupManager.shared.scoreLabelInt, streak: GameSetupManager.shared.currentHotStreakHelper)
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
                self.smallCorrectSignKeyFromJokesArray = GameSetupManager.shared.smallCorrectSignKeyFromJokesArray
                self.jokesLabel.text = randomJoke
                
                // Continue with other actions related to the new round
                GameSetupManager.shared.getAnswers(totalAnswersToDisplay: 8, answerButtons: self.answerButtons, answerButtonNames: self.answerButtonNames, typeSmall: true)
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
        
        
        GameSetupManager.shared.highlightSelectedButtonHelper(sender: sender, theUsersSelectedAnswer: usersSelectedAnswer, regOrSmallCorrectSignKeyFromJokesArray: smallCorrectSignKeyFromJokesArray, answerButtons: answerButtons, myStreaks: GameSetupManager.shared.streaks, scoreLabel: scoreLabel, viewController: self)
        
        // Set the newRoundCallback in GameSetupManager to start a new round
        // Weak catptures self to make it a weak refernce to avoid memeory leaks and then it is used again in the body as an optional to call newRound()
        // We are using the function we created in GameSteupManager to equal it to a closure function which will run this View Controllers current newRound, hence self.newRound()
        GameSetupManager.shared.newRoundCallback = { [weak self] in
                   self?.newRound()
               }
    }
    
    
    @IBAction func ballonPressed(_ sender: UIButton) {
        
        GameSetupManager.shared.ballonHelper(numOfIncorrectAnswersToRemove: 4, answerButtons: answerButtons, scoreLabelText: scoreLabel, smallOrRegCorrectSignKeyFromJokesArray: smallCorrectSignKeyFromJokesArray, viewController: self)

    }

    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        
        // Play sound when button pushed
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
        performSegue(withIdentifier: "GoToHomeViewController", sender: nil)
        
        }
    
    }
