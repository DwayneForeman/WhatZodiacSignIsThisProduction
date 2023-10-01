//
//  GameSetupManager.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/24/23.
//

import UIKit
import StoreKit

// We will use this class to
// 1. Get a Random Jokes
// 2. Get Random Answers w/one of those Answers being the correct one for the joke displayed

class GameSetupManager: UIViewController {
    
    static let shared = GameSetupManager()
    
    var correctSignKeyFromJokesArray: String = ""
    
    var smallCorrectSignKeyFromJokesArray: String = ""
    
    // We will set this value equal to JokesLabel.text when initiaing our GamePlayViewControllers
    var jokesLabelText: String = ""
    
    var scoreLabelInt = 100
    
    var hasShownStreakPrompt = false
    
    var currentHotStreakHelper = CoreDataManager.shared.fetchLatestStreak() ?? 0
    
    
    
    // Fetch random joke from the jokes array of Jokes singleton Model
    func getRandomJoke() {
        
        // Grab a randon Sign/Key from the jokes array
        // IF we can grab a random key THEN
        if let randomSignKey = Jokes.shared.jokesArray.randomElement() {
            // Let's tap into the value of that random key. Value are teh arrays assicated with each key and then we grab a random one and grab a random joke. Aka let randomJoke
            
            // Capturing the random key so I can use in the getAnswers function below
            correctSignKeyFromJokesArray = randomSignKey.key
            
            // This handles teh case for the smaller icons in which we named them starting with "Small..."
            smallCorrectSignKeyFromJokesArray = "Small" + correctSignKeyFromJokesArray
            
            let randomJoke = randomSignKey.value.randomElement()
            // Now let's let the text of that random joke equal our jokes label so we can display the randomJoke on the screen
            jokesLabelText = randomJoke!
        }
        
    }
    
    
    func getAnswers(totalAnswersToDisplay: Int, answerButtons: [UIButton], answerButtonNames: [String], typeSmall: Bool) {
        
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
        
        if typeSmall == false {
            
            // Add the correct answer to the list from the auto generated correctSignKeyFromJokesArray
            createAnswers.append(correctSignKeyFromJokesArray)
            
        } else {
            
            createAnswers.append(smallCorrectSignKeyFromJokesArray)
            
        }
        
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
    
    
    func ballonHelper(numOfIncorrectAnswersToRemove: Int, answerButtons: [UIButton], scoreLabelText: UILabel, smallOrRegCorrectSignKeyFromJokesArray: String) {
        
        
        
        var incorrectAnswersToRemove = numOfIncorrectAnswersToRemove
        
        
     
        
        if scoreLabelInt >= 5 {
            
            
            // Play baloon pop sound
            AudioManager.shared.playSound(soundName: "PopSound", shouldLoop: false)
            
            
            // Remove 5 points
            scoreLabelInt -= 5
            print(scoreLabelInt)
            
            
            // Update score label via String
            scoreLabelText.text = String(scoreLabelInt)
            print(scoreLabelText.text!)
            
            
         
            // Shuffle the answerButtons array before entering the loop
            var shuffledAnswerButtons = answerButtons
            shuffledAnswerButtons.shuffle()
            
            // Loop throug the answerButtons and remove image for incorrect buttons
            for button in shuffledAnswerButtons {
                
                //answerButtons.shuffle()
                
                if button.accessibilityIdentifier != smallOrRegCorrectSignKeyFromJokesArray {
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
            let notEnoughPointsAlert = UIAlertController(title: "Whoops! Not enough points", message: "The balloon button will remove two incorrect answers. You need at least 5 points to use this lifeline.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default)
            notEnoughPointsAlert.addAction(okay)
            present(notEnoughPointsAlert, animated: true)
        }
        
        
    }
    
    
    // Answer Prompt Pop Up
    func answerPrompt(userAnswer: String, correctOrIncorrectPopUp: String, viewController: UIViewController) {
       
        // Initializing pop up name created from our combination of the users answer andcorrectOrIncorrectPopUp
        var popUp = ""
        
        // Create UIView to serve as  background
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        // Create string with same name as asset but we need to drop "Small" to match images in assets
        // If user anser contaings "small" the dropFirst(5) letters, if it doesnt then DO NOT
        if userAnswer.localizedStandardContains("small") {
            popUp = String(userAnswer.dropFirst(5)) + correctOrIncorrectPopUp
        } else {
            popUp = userAnswer + correctOrIncorrectPopUp
        }
        
        //  Create UIImageView with image or UIimage named of our asset
        let popUpUIImage = UIImageView(image: UIImage(named: popUp))
        // Give it a frame
        popUpUIImage.frame = CGRect(x: 0, y: 0, width: 300, height: 360)
        // Center it. The center property of our UIImageView should equal the center of the view (akak view.center
        popUpUIImage.center = viewController.view.center
        // Setting content mode to scaleAspectFit to maintain aspect ratio
        popUpUIImage.contentMode = .scaleAspectFit
        // Add the background view as subview first
        viewController.view.addSubview(backgroundView)
        // add it as a subview to the current view on top
        viewController.view.addSubview(popUpUIImage)
        
        // add timer for subview to dissapear
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
            popUpUIImage.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
    }
    
    
    
    
    // Cretaing function to call when user reaches 0 points - we will pass in the scoreLabel
    func gameOver(scoreLabel: UILabel, viewController: UIViewController) {
        
        if scoreLabel.text! <= "0" {
            
            DispatchQueue.main.async {
                // let gameOverAlert = UIAlertController(title: "GAME OVER", message: "Get em again next time tiger!", preferredStyle: .alert)
                // let okay = UIAlertAction(title: "Okay", style: .default)
                // gameOverAlert.addAction(okay)
                // self.present(gameOverAlert, animated: true)
                // set score back to 100
                self.scoreLabelInt = 100
                scoreLabel.text = String(100)
                //viewController.performSegue(withIdentifier: "GoToGameOverViewController", sender: nil)
            }
        }
    }
    
    
    func getHotStreaks(streak: [String], viewController: UIViewController) {
        var consideredAHotStreak = 0

        if !streak.contains("Lose") && streak.count > 1 {
            consideredAHotStreak = streak.count
            
            // Save the new high to core data
                CoreDataManager.shared.addScoreAndStreak(score: GameSetupManager.shared.scoreLabelInt, streak: currentHotStreakHelper)

            if consideredAHotStreak > currentHotStreakHelper {
                print("Current hot streak: \(currentHotStreakHelper)")
                print("New hot streak: \(consideredAHotStreak)")
                
                
                currentHotStreakHelper = consideredAHotStreak
                
                
                    
                // Save the new high to core data
                CoreDataManager.shared.addScoreAndStreak(score: GameSetupManager.shared.scoreLabelInt, streak: currentHotStreakHelper)
                print("Chiking to see of currentHotStreak updated after being saved and fetch: \(CoreDataManager.shared.fetchLatestStreak()!)")
                 
                        
                        if !hasShownStreakPrompt {
                            print("New high streak achieved and prompt not shown yet.")
                            
                            //CoreDataManager.shared.addScoreAndStreak(score: GameSetupManager.shared.scoreLabelInt, streak: currentHotStreakHelper)

                            let alarmEmoji = "🚨" // You can copy and paste this emoji
                            let hotStreakTitle = "HOT STREAK ALERT \(alarmEmoji)"

                            let newHotStreakPrompt = UIAlertController(title: hotStreakTitle, message: "Coming in hot with a new hot streak of \(currentHotStreakHelper) correct answers in a row!", preferredStyle: .alert)

                            let okay = UIAlertAction(title: "Duh, I'm awesome", style: .default) { _ in
                                // Set the flag to true after showing the prompt
                                self.hasShownStreakPrompt = true
                                print("Streak prompt shown.")
                            }
                            newHotStreakPrompt.addAction(okay)

                            // Present the alert on the provided view controller
                            viewController.present(newHotStreakPrompt, animated: true, completion: nil)

                            // Request a review when the user achieves a new high streak for this round
                            requestAppReview(from: viewController)
                        }
                    }
                
            
        }
    }
    
    
    
    func captureAndFilterFetchResults(scoreLabel: UILabel) {
        
        // ---------- CAPTURE AND FILTER FECTH RESULTS CODE ----------------
        
        // Create fetchedScores object from our core data manager singleton fetchScores function
      
        let fetchedScores = CoreDataManager.shared.fetchScores()
        
        
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
        
            currentHotStreakHelper = CoreDataManager.shared.fetchLatestStreak() ?? 0
    }
    
    
    
    @available(iOS 14.0, *)
    func requestAppReview(from viewController: UIViewController) {
        if let windowScene = viewController.view.window?.windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        } else {
            // Fallback for older iOS versions where requestReview is not available
            // You can implement your custom review prompt here if needed
        }
    }
    
    
    
}
