//
//  GameSetupManager.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/24/23.
//

import UIKit
import SAConfettiView
import AVFoundation
import CoreData
import StoreKit
import RevenueCat
import Firebase
import FirebaseFirestore

class GameSetupManager: UIViewController {
    
    // Createing a singleton to use through GamePlayOneViewController, Two and Three
    static let shared = GameSetupManager()
    
    //MARK: - Variables
    
    var correctSignKeyFromJokesArray: String = ""
    
    var smallCorrectSignKeyFromJokesArray: String = ""
    
    var usersSelectedAnswer: String = ""
    
    // We will set this value equal to JokesLabel.text when initiaing our GamePlayViewControllers
    var jokesLabelText: String = ""
    
    var scoreLabelInt = 100
    
    var hasShownStreakPrompt = false
    
    var currentHotStreakHelper = CoreDataManager.shared.fetchLatestStreak() ?? 0
    
    var streaks = [String]()
    
    var newRoundCallback: (() -> Void)?
    
    var isUpgraded: Bool = false
    
    var gameCenterHighestScoreAbove100 = 0
    
    //var shouldHighlightAnswerButtons = true
    
    var losses = 0

    var ballonPressed = false
   
    //MARK: - Get Jokes Function
    
    // Fetch random joke from the jokes array of Jokes singleton Model
       func getRandomJoke() {
           
           if isUpgraded == false {
               
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
               
           } else if isUpgraded == true {
               // Grab a randon Sign/Key from the UPGRADED jokes array
               // IF we can grab a random key THEN
               if let randomSignKey = UpgradedJokes.shared.upgradedJokesArray.randomElement() {
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
       }
    
    
    //MARK: - Firebase Get Jokes Function
    
    /*
     
    func getRandomJoke(completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        
        // Define a reference to your Firestore collection
        let jokeCollection = db.collection("JokeQuestions")
        
        // Generate a random number to select a random document from Firestore
        let randomIndex = Int.random(in: 0..<3)  // Assuming you have 3 jokes
        
        jokeCollection.whereField("AccessLevel", isEqualTo: "1").limit(to: 3).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching jokes: \(error.localizedDescription)")
                completion(nil) // Notify the caller that fetching failed
            } else if let documents = querySnapshot?.documents, documents.count > randomIndex {
                // Get the question and answer from the retrieved Firestore document
                let document = documents[randomIndex]
                let randomJoke = document["Question"] as? String ?? ""
                let answerToJoke = document["Answer"] as? String ?? ""
                
                print(randomJoke)
                print(answerToJoke)
                
                // Capturing the answer to the joke so I can use it in the completion handler
                self.correctSignKeyFromJokesArray = answerToJoke
                
                // This handles the case for the smaller icons in which we named them starting with "Small..."
                self.smallCorrectSignKeyFromJokesArray = "Small" + self.correctSignKeyFromJokesArray
                
                // Notify the caller with the fetched joke
                completion(randomJoke)
            } else {
                completion(nil) // Notify the caller that no joke was found
            }
        }
    }
    
     */
    
    
    //MARK: - Get Answers Function
    
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
            print("This is appending correctSignKeyFromJokesArray: \(correctSignKeyFromJokesArray)")
            
        } else {
            
            createAnswers.append(smallCorrectSignKeyFromJokesArray)
            print("This is appending smallCorrectSignKeyFromJokesArray: \(smallCorrectSignKeyFromJokesArray)")
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
    
    
    
    //MARK: - Highlight Selected Button Helpher Function
    
    func highlightSelectedButtonHelper(sender: UIButton, theUsersSelectedAnswer: String, regOrSmallCorrectSignKeyFromJokesArray: String, answerButtons: [UIButton], myStreaks: [String], scoreLabel: UILabel, viewController: UIViewController) {
        
        // TIf you are uograded OR your loos doesnt equal 1 you can continue
        if isUpgraded == true || losses != 1 {
            
            usersSelectedAnswer = theUsersSelectedAnswer
            
            if let imageNameOfButton = sender.accessibilityIdentifier {
                usersSelectedAnswer = imageNameOfButton
                print("You selected \(usersSelectedAnswer)")
                print("The correct answer is \(correctSignKeyFromJokesArray)")
            }
            
            
            streaks = myStreaks
            
            // IF USER WINS
            if usersSelectedAnswer == regOrSmallCorrectSignKeyFromJokesArray {
                
                
                
                // Append every win to streaks
                streaks.append("Win")
                
                print(streaks)
                
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
                viewController.view.addSubview(confettiView)
                
                // Show correct answer prompt
                GameSetupManager.shared.answerPrompt(userAnswer: usersSelectedAnswer, correctOrIncorrectPopUp: "CorrectPopUp", viewController: viewController)
                
                // Start the confetti animation
                confettiView.startConfetti()
                
                // Tap into the main Disoatch Queue and update UI
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                    // Stop confetti
                    confettiView.stopConfetti()
                    // Hide confetti
                    confettiView.isHidden = true
                    // Bring main vuew to front
                    viewController.view.bringSubviewToFront(self.view)
                    // Start new round
                    self.newRoundCallback?()
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
                
                print(streaks)
                
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
                    
                    self.newRoundCallback?()
                }
                
                
                // Show incorrect answer prompt
                GameSetupManager.shared.answerPrompt(userAnswer: usersSelectedAnswer, correctOrIncorrectPopUp: "IncorrectPopUp", viewController: viewController)
                
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
            // If shouldHighlightAnswerButtons is false this will run where is user gets 0 and clicks on button GoToGameOverViewController pops up
        } else {
            
            // If shouldHighlightAnswerButtons is false this will run where if the user gets 0 points and clicks on a button, it will redirect to the "GoToGameOverViewController."
            if isUpgraded == false && losses == 1 {
                for button in answerButtons {
                    if button.isTouchInside {
                        // Check the user's status again because they could have upgraded
                        Purchases.shared.getCustomerInfo { (customerInfo, error) in
                            if let error = error {
                                print("Error fetching customer info: \(error.localizedDescription)")
                            } else if let customerInfo = customerInfo {
                                if customerInfo.entitlements.all["premium"]?.isActive == true {
                                    print("User has a premium entitlement. Dismissing.")
                                    
                                    self.isUpgraded = true
                                    UserDefaults.standard.set(true, forKey: "IsUpgraded")
                                    self.losses = 0
                                    UserDefaults.standard.set(self.losses, forKey: "losses")
                                    self.handleUpgradedUser(button, theUsersSelectedAnswer: self.usersSelectedAnswer, regOrSmallCorrectSignKeyFromJokesArray: regOrSmallCorrectSignKeyFromJokesArray, answerButtons: answerButtons, myStreaks: myStreaks, scoreLabel: scoreLabel, viewController: viewController)
//
                                    
                                } else {
                                    print("User does not have a premium entitlement.")
                                    viewController.performSegue(withIdentifier: "GoToGameOverViewController", sender: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    func handleUpgradedUser(_ sender: UIButton, theUsersSelectedAnswer: String, regOrSmallCorrectSignKeyFromJokesArray: String, answerButtons: [UIButton], myStreaks: [String], scoreLabel: UILabel, viewController: UIViewController) {
        usersSelectedAnswer = theUsersSelectedAnswer

        if let imageNameOfButton = sender.accessibilityIdentifier {
            usersSelectedAnswer = imageNameOfButton
            print("You selected \(usersSelectedAnswer)")
            print("The correct answer is \(correctSignKeyFromJokesArray)")
        }

        streaks = myStreaks

        // IF USER WINS
        if usersSelectedAnswer == regOrSmallCorrectSignKeyFromJokesArray {
            // Your win logic here
            // For example, handle a win, play sounds, and update UI
            // Append every win to streaks
            streaks.append("Win")

            print(streaks)
            
            let correctAnswerSoundArray = ["CorrectAnswer1", "CorrectAnswer2", "CorrectAnswer3", "CorrectAnswer4", "CorrectAnswer5"]
            let randomCorrectAnswerSound = correctAnswerSoundArray.randomElement()!
            print(randomCorrectAnswerSound)
            AudioManager.shared.playSound(soundName: randomCorrectAnswerSound, shouldLoop: false)

            // Once you get the correct answer, disable all buttons so users cannot click multiple buttons within the same round
            for button in answerButtons {
                button.isEnabled = false
            }

            let customHighlightColor = UIColor(named: "OrangeHighlightGradient")
            sender.backgroundColor = customHighlightColor
            sender.layer.cornerRadius = 18

            let confettiView = SAConfettiView(frame: self.view.bounds)
            viewController.view.addSubview(confettiView)

            // Show the correct answer prompt
            GameSetupManager.shared.answerPrompt(userAnswer: usersSelectedAnswer, correctOrIncorrectPopUp: "CorrectPopUp", viewController: viewController)

            // Start the confetti animation
            confettiView.startConfetti()

            // Tap into the main Dispatch Queue and update UI
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                // Stop confetti
                confettiView.stopConfetti()
                // Hide confetti
                confettiView.isHidden = true
                // Bring the main view to the front
                viewController.view.bringSubviewToFront(self.view)
                // Start a new round
                self.newRoundCallback?()
            }

            GameSetupManager.shared.scoreLabelInt += 10
            print("\(GameSetupManager.shared.scoreLabelInt) from VC")
            scoreLabel.text = String(GameSetupManager.shared.scoreLabelInt)
            print("Hooray, you win!")
        } else {
            // Handle the logic when the user loses
            // Append every loss to streaks
            streaks.append("Lose")
            print(streaks)
            
            
            let wrongAnswerSoundArray = ["WrongAnswer1", "WrongAnswer2", "WrongAnswer3", "WrongAnswer4"]
            let randomWrongAnswerSound = wrongAnswerSoundArray.randomElement()!

            DispatchQueue.main.async {
                AudioManager.shared.playSound(soundName: randomWrongAnswerSound, shouldLoop: false)
                let customHighlightColor = UIColor(named: "OrangeHighlightGradient")
                sender.backgroundColor = customHighlightColor
                sender.layer.cornerRadius = 18
            }

            // Once you get an incorrect answer, disable all buttons so users cannot click multiple buttons within the same round
            for button in answerButtons {
                button.isEnabled = false
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                // Handle the logic for a loss and start a new round
                self.newRoundCallback?()
            }

            // Show the incorrect answer prompt
            GameSetupManager.shared.answerPrompt(userAnswer: usersSelectedAnswer, correctOrIncorrectPopUp: "IncorrectPopUp", viewController: viewController)

            GameSetupManager.shared.scoreLabelInt -= 10
            scoreLabel.text = String(GameSetupManager.shared.scoreLabelInt)
            print("Wrong answer, bud!")
        }
    }

    
  
    //MARK: - Ballon Helpher Function
    
    func ballonHelper(numOfIncorrectAnswersToRemove: Int, answerButtons: [UIButton], scoreLabelText: UILabel, smallOrRegCorrectSignKeyFromJokesArray: String, viewController: UIViewController) {
        
        
        var incorrectAnswersToRemove = numOfIncorrectAnswersToRemove
        
        // Check if the balloon has already been pressed in this round
        if ballonPressed == true {
            
            
            
            // Display a message indicating that the balloon can only be used once per round
            let alreadyUsedAlert = UIAlertController(title: "Balloon Already Used", message: "You can only use the balloon lifeline once per round.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default)
            alreadyUsedAlert.addAction(okay)
            viewController.present(alreadyUsedAlert, animated: true)
            return
        }

        // Continue with the rest of the function
        
        // Check if the user has enough points to use the balloon
        if scoreLabelInt >= 5 {
            // Play balloon pop sound
            AudioManager.shared.playSound(soundName: "PopSound", shouldLoop: false)

            // Remove 5 points
            scoreLabelInt -= 5
            scoreLabelText.text = String(scoreLabelInt)

            // Shuffle the answerButtons array before entering the loop
            var shuffledAnswerButtons = answerButtons
            shuffledAnswerButtons.shuffle()

            // Loop through the answerButtons and remove image for incorrect buttons
            for button in shuffledAnswerButtons {
                if button.accessibilityIdentifier != smallOrRegCorrectSignKeyFromJokesArray {
                    // Removing image for incorrect buttons
                    button.setImage(UIImage(named: "X.pdf"), for: .normal)
                    button.accessibilityIdentifier = "X.pdf"
                    button.isEnabled = false

                    // Decrement count of incorrectAnswersToRemove
                    incorrectAnswersToRemove -= 1

                    // If we have removed the required number of incorrect buttons, break out of the loop
                    if incorrectAnswersToRemove == 0 {
                        break
                    }
                }
            }

            // Set ballonPressed to true after the balloon has been used
            ballonPressed = true
            
        } else {
            // Display a message indicating that the user doesn't have enough points
            let notEnoughPointsAlert = UIAlertController(title: "Not Enough Points", message: "You need at least 5 points to use the balloon lifeline.", preferredStyle: .alert)
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
    
    
    
 

    
    
    //MARK: - Game Over Function
    
    // Cretaing function to call when user reaches 0 points - we will pass in the scoreLabel
    func gameOver(scoreLabel: UILabel, viewController: UIViewController, answerButtons: [UIButton]) {
        
        
        
        
        //MARK: - GameOver function helpers
        func upgradedGameOverPopUp(){
            
            DispatchQueue.main.async {
                let gameOverAlert = UIAlertController(title: "GAME OVER", message: "Not you going out sad again LMFAO Step it up!", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Okay", style: .default)
                gameOverAlert.addAction(okay)
                viewController.present(gameOverAlert, animated: true)
               //set score back to 100
               self.scoreLabelInt = 100
               scoreLabel.text = String(100)
            }
           
        }
        
        func notUpgradedGameOverOverPopup(){

            self.scoreLabelInt = 100
            scoreLabel.text = String(100)

            isUpgraded = false

            viewController.performSegue(withIdentifier: "GoToGameOverViewController", sender: nil)


    }
        
        
        // When game is over check if use is upgraded or not
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if let error = error {
                print("Error fetching customer info: \(error.localizedDescription)")
            } else if let customerInfo = customerInfo {
                if customerInfo.entitlements.all["premium"]?.isActive == true {
                    print("User has premium entitlement. Dismissing.")
                    
               

                    // Save the isUpgraded value in UserDefaults
                    UserDefaults.standard.set(true, forKey: "IsUpgraded")
                    
                    if scoreLabel.text! <= "0" && viewController is GamePlayOneViewController && self.isUpgraded == true {
                        upgradedGameOverPopUp()
                        
                    }
                   
                } else {
                    print("User does not have premium entitlement.")
                    
                    self.isUpgraded = false
                    // Save the isUpgraded value in UserDefaults
                    UserDefaults.standard.set(false, forKey: "IsUpgraded")
                }
            }
        }
          
               
        
        if scoreLabel.text! <= "0" {
            
            
            
            DispatchQueue.main.async {
                
                if viewController is GamePlayOneViewController && self.isUpgraded == false {
                    
                    self.losses = 1
                    UserDefaults.standard.set(self.losses, forKey: "losses")
                    
                    notUpgradedGameOverOverPopup()
                    
                } else if viewController is GamePlayOneViewController || viewController is GamePlayTwoViewController || viewController is GamePlayThreeViewController && self.isUpgraded == true {
                    upgradedGameOverPopUp()
                }
            }
        }

    }
    
    
    
    
    //MARK: - Get Hot Streaks Function
    
    func getHotStreaks(streak: [String], viewController: UIViewController) {
        
        var consideredAHotStreak = 0
        
        
        if !streak.contains("Lose") && streak.count > 1 {
            
            consideredAHotStreak = streak.count
            
            print("Current hot streak: \(currentHotStreakHelper)")
            print("New hot streak: \(consideredAHotStreak)")
            
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
    
    

    
    
    //MARK: - Core Data Capture and Filter Helpher Function
    
    func captureAndFilterFetchResults(scoreLabel: UILabel, viewController: UIViewController? = nil) {
        
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
            
            
            // We need to also capture teh highest pointsNumber above 100 so we can use for GameCnter leaderboard
            // In this code, we first use the max() function to find the highest value in the pointsNumbers array. Then, we check if it's greater than 100 before assigning it to HomeViewController.shared.scoreReporter
            if let highestScoreAbove100 = pointsNumbers.max(), highestScoreAbove100 > 100 {
                gameCenterHighestScoreAbove100 = highestScoreAbove100
                
               
            }
            
            // ---------- CAPTURE AND FILTER FECTH RESULTS CODE ----------------
            
        }
        
            currentHotStreakHelper = CoreDataManager.shared.fetchLatestStreak() ?? 0
            print("the CURRRENT HOT STREAK IS \(currentHotStreakHelper)")
    }
    
    
    
    
    //MARK: - Request A Review Function
    
    @available(iOS 14.0, *)
    func requestAppReview(from viewController: UIViewController) {
        if let windowScene = viewController.view.window?.windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        } else {
            // Fallback for older iOS versions where requestReview is not available
            // You can implement your custom review prompt here if needed
        }
    }
    


    
    func highScoreAlert(viewController: UIViewController, scoreLabel: UILabel) {
     
        let fetchedScores = CoreDataManager.shared.fetchScores()
        let pointsNumbers = fetchedScores.map { Int($0.pointsNumber) }
        let maxPointsNumbersScoredinHistory = pointsNumbers.max() ?? 0

        print("THE MAX NUMBER SCORED IN HISTORY IS \(maxPointsNumbersScoredinHistory)")

        let numScoreLabel = Int(scoreLabel.text ?? "0")
        print("THE NUM SCORE LABEL IS \(numScoreLabel!)")

        if numScoreLabel! > 100 && numScoreLabel! >= maxPointsNumbersScoredinHistory {
            // The first time this runs, `promptWasShown` will be false
            if UserDefaults.standard.bool(forKey: "PromptWasShown") == false {
                print("High score achieved AT THIS MOMENT: \(numScoreLabel!)")
                print("Highest score in history: \(pointsNumbers.max()!)")

                // At this point is where we want to set the high score alert
                let highScoreAlert = UIAlertController(title: "High Score Alert🚨", message: "Congrats your high score of \(numScoreLabel!) points! To see where you rank among your peers, check out the Charts 📊 button on the Home Screen.", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Okay", style: .default)

                highScoreAlert.addAction(okay)

                viewController.present(highScoreAlert, animated: true)

                // Update the Game Centre Top Score
                HomeViewController.shared.updateGameCenterScore()

               
                // Set the flag to true after showing the alert
                UserDefaults.standard.set(true, forKey: "PromptWasShown")
            }
        }
    }

}
