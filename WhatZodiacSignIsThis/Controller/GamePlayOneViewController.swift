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
    
    

    
    //MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
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
        AudioManager.shared.player.stop()
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
        AudioManager.shared.playSound(soundName: "WaitingForAnswerSound", shouldLoop: true)
        GameSetupManager.shared.getRandomJoke()
        correctSignKeyFromJokesArray = GameSetupManager.shared.correctSignKeyFromJokesArray
        jokesLabel.text = GameSetupManager.shared.jokesLabelText
        GameSetupManager.shared.getAnswers(totalAnswersToDisplay: 4, answerButtons: answerButtons, answerButtonNames: answerButtonNames, typeSmall: false)
        GameSetupManager.shared.scoreLabelInt = Int(scoreLabel.text!)!
        GameSetupManager.shared.getHotStreaks(streak: streaks, viewController: self)
        GameSetupManager.shared.gameOver(scoreLabel: scoreLabel, viewController: self)
        CoreDataManager.shared.addScoreAndStreak(score: GameSetupManager.shared.scoreLabelInt, streak: currentHotStreakHelper)
    }
    
    
    
    
    
    //MARK: - Action Functions
    
    
    @IBAction func highlightSelectedButton(_ sender: UIButton) {
        
        if let imageNameOfButton = sender.accessibilityIdentifier {
            usersSelectedAnswer = imageNameOfButton
            print("You selected \(usersSelectedAnswer)")
            print("The correct answer is \(correctSignKeyFromJokesArray)")
        }
        
        
        // IF USER WINS
        if usersSelectedAnswer == correctSignKeyFromJokesArray {
            
            // Append every win to streaks
            streaks.append("Win")
            
            let correctAnswerSoundArray = ["CorrectAnswer1", "CorrectAnswer2", "CorrectAnswer3", "CorrectAnswer4", "CorrectAnswer5"]
            
            let randomCorrectAnswerSound = correctAnswerSoundArray.randomElement()!
            print(randomCorrectAnswerSound)
            
            AudioManager.shared.playSound(soundName: randomCorrectAnswerSound, shouldLoop: false)
            
            
            
            // Once we get the correct answer, disable all buttons so users cannot click on mutiple buttons within the same round
            for button in answerButtons {
                button.isEnabled = false
            }
            
            
            let customeHighlightColor = UIColor(named: "OrangeHighlightGradient")
            sender.backgroundColor = customeHighlightColor
            sender.layer.cornerRadius = 18
            
            let confettiView = SAConfettiView(frame: self.view.bounds)
            self.view.addSubview(confettiView)
            
            // Show correct answer prompt
            GameSetupManager.shared.answerPrompt(userAnswer: usersSelectedAnswer, correctOrIncorrectPopUp: "CorrectPopUp", viewController: self)
            
            // Start the confetti animation
            confettiView.startConfetti()
            
            // Tap into the main Disoatch Queue and update UI
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                // Stop confetti
                confettiView.stopConfetti()
                // Hide confetti
                confettiView.isHidden = true
                // Bring main vuew to front
                self.view.bringSubviewToFront(self.view)
                // Start new round
                self.newRound()
            }
            
            /* ---------- LOSE UI ALERT CONTROLLER PROMPT ---------------
            
            let winPrompt = UIAlertController(title: "Niceee Work!!!",                  message: "", preferredStyle: .alert)
            let okayButton = UIAlertAction(title: "Okay", style: .default)
            winPrompt.addAction(okayButton)
            present(winPrompt, animated: true)
            
            */
            
            GameSetupManager.shared.scoreLabelInt += 10
            print("\(GameSetupManager.shared.scoreLabelInt) from VC")
            scoreLabel.text = String(GameSetupManager.shared.scoreLabelInt)
            print("Horray, you win!")
            
            
            // IF USER LOOSES
        } else {
            
            // Append every win to streaks
            streaks.append("Lose")
            
            let wrongAnswerSoundArray = ["WrongAnswer1", "WrongAnswer2", "WrongAnswer3", "WrongAnswer4"]
            
            let randomWrongAnswerSound = wrongAnswerSoundArray.randomElement()!
            
            DispatchQueue.main.async {
                AudioManager.shared.playSound(soundName: randomWrongAnswerSound, shouldLoop: false)
                let customeHighlightColor = UIColor(named: "OrangeHighlightGradient")
                sender.backgroundColor = customeHighlightColor
                sender.layer.cornerRadius = 18
            }
            
            
            // Once we get the INcorrect answer, disable all buttons so users cannot click on mutiple buttons within the same round
            for button in answerButtons {
                button.isEnabled = false
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                
                self.newRound()
            }
            
            
            // Show incorrect answer prompt
            GameSetupManager.shared.answerPrompt(userAnswer: usersSelectedAnswer, correctOrIncorrectPopUp: "IncorrectPopUp", viewController: self)
            
            /* ---------- LOSE UI ALERT CONTROLLER PROMPT ---------------
            
            let losePrompt = UIAlertController(title: "Wrong! Step your game up", message: "", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default)
            losePrompt.addAction(okay)
            present(losePrompt, animated: true)
             */
            
            GameSetupManager.shared.scoreLabelInt -= 10
            scoreLabel.text = String(GameSetupManager.shared.scoreLabelInt)
            print("Wrong answer bud!!")
            
        }
        
    }
    

    
    @IBAction func ballonPressed(_ sender: UIButton) {
       
        GameSetupManager.shared.ballonHelper(numOfIncorrectAnswersToRemove: 2, answerButtons: answerButtons, scoreLabelText: scoreLabel, smallOrRegCorrectSignKeyFromJokesArray: correctSignKeyFromJokesArray)
        print("\(GameSetupManager.shared.scoreLabelInt) from VC")
    }
    
    
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        
        // Play sound when button pushed
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
       performSegue(withIdentifier: "GoToHomeViewController", sender: nil)
    }
    
    
}
