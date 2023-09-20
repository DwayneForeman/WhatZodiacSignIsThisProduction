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
    
    // Creating var of AVAudioPlayer type so we can use its features
    // AVAudioPlay is a data type from the AVFoundation
    var player: AVAudioPlayer!
    
    var streaks = [String]()
    
    var currentHotStreak = 0
    
    var currentHotStreakHelper = 0
    
    var newHotStreak = 0
    
    // To Capture all hot streaks and display them in table view
    var hotStreaksCountTableViewArray = [Int]()
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var scoreLabelInt = 100
    
    var answerButtonNames = ["AquariusButton", "AriesButton", "CancerButton", "CapricornButton", "GeminiButton", "LeoButton", "LibraButton", "PiscesButton", "SagittariusButton", "ScorpioButton", "TaurusButton", "VirgoButton"]
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Hideing the navigation bar
            navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Capture, Filter and Assign to our components of this ViewController from CoreData fetch reults when teh view loads
        captureAndFilterFetchResults()
      
        // Start new round
        newRound()
        
        // Grab file to run/see our SQL Lite datbase in action
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    

  
    
    // Fetch random joke from the jokes array of Jokes singleton Model
    func getRandomJoke() {
        
        // Grab a randon Sign/Key from the jokes array
        // IF we can grab a random key THEN
        if let randomSignKey = Jokes.shared.jokesArray.randomElement() {
            // Let's tap into the value of that random key. Value are teh arrays assicated with each key and then we grab a random one and grab a random joke. Aka let randomJoke
            
            // Capturing the random key so I can use in the getAnswers function below
            correctSignKeyFromJokesArray = randomSignKey.key
            
            let randomJoke = randomSignKey.value.randomElement()
            // Now let's let the text of that random joke equal our jokes label so we can display the randomJoke on the screen
            jokesLabel.text = randomJoke
        }
        
    }
    
    
    func getAnswers(totalAnswersToDisplay: Int) {
        
        // OUR GOAL HERE:
        // Clear the current images assigned to the buttons
        // Clear the background color previously selected
        // Setting all buttons to be enabled since 2 will be disabled when we us the baloon 50/50
        for button in answerButtons {
            button.setTitle("", for: .normal)
            button.backgroundColor = nil
            button.isEnabled = true
        }
        
        
        var createAnswers: [String] = []
        
        // Add the correct answer to the list from the auto generated correctSignKeyFromJokesArray
        createAnswers.append(correctSignKeyFromJokesArray)
        
        // Creating a WHILE LOOP to Add 3 random wrong answers to the list
        // WHILE the count of our createAnswers array is NOT more than 4
        while createAnswers.count < totalAnswersToDisplay {
            // Grabbing/capturing a random button name from our answerButtonNames array
            let randomAnswerButtonName = answerButtonNames.randomElement()!
            // Making sure that:
            // 1. Our random button name is NOT the correctSignKeyFromJokesArray
            // 2. Our createAnswer array DOES NOT ALREADY contain the randomAnswerButtonName
            if randomAnswerButtonName != correctSignKeyFromJokesArray && !createAnswers.contains(randomAnswerButtonName) {
                // If the conditons above are MET THEN we can append to the randomAnswerButtonName to our createAnswers array
                createAnswers.append(randomAnswerButtonName)
            }
        }
        
        // Checking the make sure our loop worked and that we only retuen 4 answers 1 of which is correct and 3 are incorrect with NO DUPLICATES
        print(createAnswers)
        
        // Shaking up the answer order to make sure they are in random order
        createAnswers.shuffle()
        
        // Assign the images to the buttons
        for (button, answerName) in zip(answerButtons, createAnswers) {
            if let addButtonImage = UIImage(named: answerName) {
                button.setImage(addButtonImage, for: .normal)
                // Setting the accessibilityIdentifier to each button name so we can access it within the highlightSelectedButton functions
                button.accessibilityIdentifier = answerName
            }
        }
        
        
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
            
            self.playSound(soundName: randomCorrectAnswerSound, shouldLoop: false)
            
            
            
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
            answerPrompt(userAnswer: usersSelectedAnswer, correctOrIncorrectPopUp: "CorrectPopUp")
            
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
                self.playSound(soundName: randomWrongAnswerSound, shouldLoop: false)
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
            answerPrompt(userAnswer: usersSelectedAnswer, correctOrIncorrectPopUp: "IncorrectPopUp")
            
            /* ---------- LOSE UI ALERT CONTROLLER PROMPT ---------------
            
            let losePrompt = UIAlertController(title: "Wrong! Step your game up", message: "", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default)
            losePrompt.addAction(okay)
            present(losePrompt, animated: true)
             */
            
            scoreLabelInt -= 10
            scoreLabel.text = String(scoreLabelInt)
            print("Wrong answer bud!!")
            
        }
        
    }
    
    
    func newRound() {
        self.view.bringSubviewToFront(self.view)
        playSound(soundName: "WaitingForAnswerSound", shouldLoop: true)
        getRandomJoke()
        getAnswers(totalAnswersToDisplay: 4)
        scoreLabelInt = Int(scoreLabel.text!)!
        getHotStreaks(streak: streaks)
        gameOver(score: scoreLabel.text!)
        
    }
    
    
    // Creating a function with code needed to play the file
    func playSound(soundName: String, shouldLoop: Bool) {
        
        DispatchQueue.main.async {
            // Stop prervious sound
            self.player?.stop()
            
            // Setting are URL to equal the location of where our sound file is held
            let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
            print(url!)
            
            // Then we put the url file into our player
            self.player = try! AVAudioPlayer(contentsOf: url!)
            // Then we play the sound
            self.player.play()
            
            // Then we loop it
            if shouldLoop {
                self.player.numberOfLoops = -1
            }
        }
        
    }
    
    
    
    @IBAction func ballonPressed(_ sender: UIButton) {
        
        scoreLabelInt = Int(scoreLabel.text!)!
        
        // BALLOON WILL REMOVE TWO INCORRECT ANSWERS TO HELP USER
        // BALLOON COSTS 5 POINTS
        
        // If the user has enough points (5 or more), then proceed
        if scoreLabelInt >= 10 {
            
            
            // Play baloon pop sound
            playSound(soundName: "PopSound", shouldLoop: false)
            
            
            // Remove 10 points
            scoreLabelInt -= 10
            
            
            // Update score label via String
            scoreLabel.text = String(scoreLabelInt)
            
            
            // Count th number of incorrect answers to remove
            var incorrectAnswersToRemove = 2
            
            
            // Loop throug the answerButtons and remove image for incorrect buttons
            for button in answerButtons {
                if button.accessibilityIdentifier != correctSignKeyFromJokesArray {
                    print("Removing image for button: \(button.accessibilityIdentifier ?? "Unknown")")
                    // Setting the image to my "X.pdf" asset
                    button.setImage(UIImage(named: "X.pdf"), for: .normal)
                    
                    // Settinh the accessibilityIdentifier
                    button.accessibilityIdentifier = "X.pdf"
                    
                    // Now disabiling the 2 buttons associated with the X button so user cannot click on them
                    if button.accessibilityIdentifier == "X.pdf" {
                        button.isEnabled = false
                    }
                    
                    print(button)
                    
                    // Decrement count of incorrectAnswersToRemove
                    incorrectAnswersToRemove -= 1
                    
                    // If we have removed the required number of incorrect buttons, break out ofthe loop
                    if incorrectAnswersToRemove == 0 {
                        break
                    }
                }
            }
            
            
        } else {
            let notEnoughPointsAlert = UIAlertController(title: "Whoops! Not enough points", message: "The balloon button will remove two incorrect answers. You need at least 10 points to use this lifeline.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default)
            notEnoughPointsAlert.addAction(okay)
            present(notEnoughPointsAlert, animated: true)
        }
    }
    
    
    
    
    // Cretaing function to call when user reaches 0 points - we will pass in the scoreLabel
    func gameOver(score: String) {
        
        if score <= "0" {
            
            DispatchQueue.main.async {
                let gameOverAlert = UIAlertController(title: "GAME OVER", message: "Get em again next time tiger!", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Okay", style: .default)
                gameOverAlert.addAction(okay)
                self.present(gameOverAlert, animated: true)
                // set score back to 100
                self.scoreLabelInt = 100
                self.scoreLabel.text = String(100)
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
    
    
    
    // Save before view dissapears
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.stop()
        print(scoreLabelInt)
        print(currentHotStreakHelper)
        // Save score and streak to core data when we leave the screen
        CoreDataManager.shared.addScoreAndStreak(score: scoreLabelInt, streak: currentHotStreakHelper)
        
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
    
    // Answer Prompt Pop Up
    func answerPrompt(userAnswer: String, correctOrIncorrectPopUp: String) {
       
        // Create UIView to serve as  background
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        // Create string with same name as asset
        let popUp = userAnswer + correctOrIncorrectPopUp
        //  Create UIImageView with image or UIimage named of our asset
        let popUpUIImage = UIImageView(image: UIImage(named: popUp))
        // Give it a frame
        popUpUIImage.frame = CGRect(x: 0, y: 0, width: 300, height: 360)
        // Center it. The center property of our UIImageView should equal the center of the view (akak view.center
        popUpUIImage.center = view.center
        // Setting content mode to scaleAspectFit to maintain aspect ratio
        popUpUIImage.contentMode = .scaleAspectFit
        // Add the background view as subview first
        view.addSubview(backgroundView)
        // add it as a subview to the current view on top
        view.addSubview(popUpUIImage)
        
        // add timer for subview to dissapear
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
            popUpUIImage.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
    }
    
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        
        // Play sound when button pushed
        playSound(soundName: "ButtonSound", shouldLoop: false)
        
       performSegue(withIdentifier: "GoToHomeViewController", sender: nil)
    }
    
    
    
    
    
    
    
    
}
