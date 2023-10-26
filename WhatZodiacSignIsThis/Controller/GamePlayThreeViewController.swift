//
//  GamePlayThreeViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/17/23.
//

import UIKit
import SAConfettiView
import AVFoundation
import CoreData


class GamePlayThreeViewController: UIViewController {

    //MARK: - Variables
    
        @IBOutlet weak var jokesLabel: UILabel!
        
        @IBOutlet var answerButtons: [UIButton]!
        
        @IBOutlet weak var scoreLabel: UILabel!
    
        var usersSelectedAnswer: String = ""
    
        var correctAnswer: String = ""
    
        var smallCorrectSignKeyFromJokesArray = ""
    
        var streaks = [String]()
    
        var currentHotStreakHelper = GameSetupManager.shared.currentHotStreakHelper
    
        var answerButtonNames = ["SmallAquariusButton", "SmallAriesButton", "SmallCancerButton", "SmallCapricornButton", "SmallGeminiButton", "SmallLeoButton", "SmallLibraButton", "SmallPiscesButton", "SmallSagittariusButton", "SmallScorpioButton", "SmallTaurusButton", "SmallVirgoButton"]
        
        
    
    //MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        
            UpgradeManager.shared.checkForPremiumUser()
        
            // Capture, Filter and Assign to our components of this ViewController from CoreData fetch reults when teh view loads
            GameSetupManager.shared.captureAndFilterFetchResults(scoreLabel: scoreLabel)
          
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

        
    func newRound() {
        self.view.bringSubviewToFront(self.view)
        // Play waiting for answer sound
        AudioManager.shared.playSound(soundName: "WaitingForAnswerSound", shouldLoop: true)
        GameSetupManager.shared.getRandomJoke()
        smallCorrectSignKeyFromJokesArray = GameSetupManager.shared.smallCorrectSignKeyFromJokesArray
        jokesLabel.text = GameSetupManager.shared.jokesLabelText
        GameSetupManager.shared.getAnswers(totalAnswersToDisplay: 12, answerButtons: answerButtons, answerButtonNames: answerButtonNames, typeSmall: true)
        GameSetupManager.shared.scoreLabelInt = Int(scoreLabel.text!)!
        GameSetupManager.shared.getHotStreaks(streak: streaks, viewController: self)
        GameSetupManager.shared.gameOver(scoreLabel: scoreLabel, viewController: self, answerButtons: answerButtons)
        CoreDataManager.shared.addScoreAndStreak(score: GameSetupManager.shared.scoreLabelInt, streak: currentHotStreakHelper)
        GameSetupManager.shared.ballonPressed = false
    }
    



    //MARK: - Action Functions

    @IBAction func highlightSelectedButton(_ sender: UIButton) {
        
        
        GameSetupManager.shared.highlightSelectedButtonHelper(sender: sender, theUsersSelectedAnswer: usersSelectedAnswer, regOrSmallCorrectSignKeyFromJokesArray: smallCorrectSignKeyFromJokesArray, answerButtons: answerButtons, myStreaks: streaks, scoreLabel: scoreLabel, viewController: self)
        
        // Set the newRoundCallback in GameSetupManager to start a new round
        // Weak catptures self to make it a weak refernce to avoid memeory leaks and then it is used again in the body as an optional to call newRound()
        // We are using the function we created in GameSteupManager to equal it to a closure function which will run this View Controllers current newRound, hence self.newRound()
        GameSetupManager.shared.newRoundCallback = { [weak self] in
                   self?.newRound()
               }
    }
    
    
    @IBAction func ballonPressed(_ sender: UIButton) {
        
        GameSetupManager.shared.ballonHelper(numOfIncorrectAnswersToRemove: 6, answerButtons: answerButtons, scoreLabelText: scoreLabel, smallOrRegCorrectSignKeyFromJokesArray: smallCorrectSignKeyFromJokesArray, viewController: self)

    }

    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        
        // Play sound when button pushed
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
        performSegue(withIdentifier: "GoToHomeViewController", sender: nil)
        
        }
    
    }
