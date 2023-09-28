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

class GamePlayOneViewController: UIViewController {
    
    static let shared = GamePlayOneViewController()
    
    @IBOutlet weak var jokesLabel: UILabel!
    
    @IBOutlet var answerButtons: [UIButton]!
    
    var correctSignKeyFromJokesArray: String = ""
    
    var usersSelectedAnswer: String = ""
    
    var correctAnswer: String = ""
    
    var streaks = [String]()
    
    var currentHotStreak = 0
    
    var currentHotStreakHelper = 0
    
    var newHotStreak = 0
    
    // To Capture all hot streaks and display them in table view
    var hotStreaksCountTableViewArray = [Int]()
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var scoreLabelInt = GameSetupManager.shared.scoreLabelInt
    
    var answerButtonNames = ["AquariusButton", "AriesButton", "CancerButton", "CapricornButton", "GeminiButton", "LeoButton", "LibraButton", "PiscesButton", "SagittariusButton", "ScorpioButton", "TaurusButton", "VirgoButton"]
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Hideing the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Capture, Filter and Assign to our components of this ViewController from CoreData fetch reults when teh view loads
        captureAndFilterFetchResults()
      
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
        print(scoreLabelInt)
        print(currentHotStreakHelper)
        // Save score and streak to core data when we leave the screen
        CoreDataManager.shared.addScoreAndStreak(score: scoreLabelInt, streak: currentHotStreakHelper)
        
    }
    
    
    
    
    
    
    
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
            
            scoreLabelInt += 10
            scoreLabel.text = String(scoreLabelInt)
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
            
            scoreLabelInt -= 100
            scoreLabel.text = String(scoreLabelInt)
            print("Wrong answer bud!!")
            
        }
        
    }
    
    
    
    
    func newRound() {
        self.view.bringSubviewToFront(self.view)
        AudioManager.shared.playSound(soundName: "WaitingForAnswerSound", shouldLoop: true)
        GameSetupManager.shared.getRandomJoke()
        correctSignKeyFromJokesArray = GameSetupManager.shared.correctSignKeyFromJokesArray
        jokesLabel.text = GameSetupManager.shared.jokesLabelText
        GameSetupManager.shared.getAnswers(totalAnswersToDisplay: 4, answerButtons: answerButtons, answerButtonNames: answerButtonNames, typeSmall: false)
        scoreLabelInt = Int(scoreLabel.text!)!
        getHotStreaks(streak: streaks)
        gameOver(score: scoreLabel.text!)
        
    }
    
    

    
    
    
    @IBAction func ballonPressed(_ sender: UIButton) {
       
        GameSetupManager.shared.ballonHelper(numOfIncorrectAnswersToRemove: 2, answerButtons: answerButtons, scoreLabelText: scoreLabel, smallOrRegCorrectSignKeyFromJokesArray: correctSignKeyFromJokesArray, scoreLabelIntFromVC: scoreLabelInt)
       
    }
    
    
    
    
    // Cretaing function to call when user reaches 0 points - we will pass in the scoreLabel
    func gameOver(score: String) {
        
        if score <= "0" {
            
            DispatchQueue.main.async {
                
                //let gameOverAlert = UIAlertController(title: "GAME OVER", message: "Get em again next time tiger!", preferredStyle: .alert)
                //let okay = UIAlertAction(title: "Okay", style: .default)
                //gameOverAlert.addAction(okay)
                //self.present(gameOverAlert, animated: true)
                // set score back to 100
                self.scoreLabelInt = 100
                self.scoreLabel.text = String(100)
                self.performSegue(withIdentifier: "GoToGameOverViewController", sender: nil)
                
                
            }
        }
    }
    
    
    func getHotStreaks(streak: [String]){
        
        if !streak.contains("Lose") {
            
            newHotStreak = streak.count

            if newHotStreak > 1 {
                
                currentHotStreak = newHotStreak
                
            }
            
        } else {
            
            if currentHotStreak > 1 {
                
                // Append to our array
                hotStreaksCountTableViewArray.append(currentHotStreak)
                
            }
            
            // Empty the count container
            streaks = []
            
            // transfer value of current hot streak so we can pass it into our coredata function before we clear currentHotStreaK
            currentHotStreakHelper = currentHotStreak
            
            // Set current streaks back to 0 again
            currentHotStreak = 0
        }
    }
    
    @IBAction func fireButtonPressed(_ sender: UIButton) {
        
        // When btn pressed we will go to the HotStreaksViewController
        let hotStreaksVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HotStreaksViewController") as! HotStreaksViewController
        hotStreaksVC.hotStreaksCountTableViewArray = hotStreaksCountTableViewArray
        self.present(hotStreaksVC, animated: true, completion: nil)
    }
    
    

    
    
    

 
    
    
    func captureAndFilterFetchResults() {
        
        // ---------- CAPTURE AND FILTER FECTH RESULTS CODE ----------------
        
        // Create fetchedScores object from our core data manager singleton fetchScores function
        // Populate the arrays to show on screen - remeber the array is then passed to our HotStreaksViewcontroller with the TableView
        let fetchedScores = CoreDataManager.shared.fetchScores()
        // Filter (using closure) out streaks greater than 1 where $0 is the plcaeholder of each element and map/create a new array out streaks (using closure) then covert to integers since they are orginally Int64 as created in CoreData
        hotStreaksCountTableViewArray = fetchedScores
            .filter { $0.streaksNumber > 1 }
            .map { Int($0.streaksNumber) }
        
        // Tap into our fetchedSocres and map out points then covert to integers since they are orginally Int64 as created in CoreData
        let pointsNumbers = fetchedScores.map { Int($0.pointsNumber) }
        print(pointsNumbers)
        
        // Grab the last point saved in our poimysNumbers array by using .last which us an optional so we unwrap using if let
        if let lastPointsNumberInArray = pointsNumbers.last {
            print(lastPointsNumberInArray)
            // Equal out score labels text to be equal to the lastPointsNumberInArray aka pointsNumbers.last so it will appear upon load up as this function will be called in viewDidLoad
            scoreLabel.text = String(lastPointsNumberInArray)
            
            // ---------- CAPTURE AND FILTER FECTH RESULTS CODE ----------------
            
        }
    }
    
   
    
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        
        // Play sound when button pushed
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
       performSegue(withIdentifier: "GoToHomeViewController", sender: nil)
    }
    
    
}
