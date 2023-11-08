//
//  CoreDataManager.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 8/30/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    // Creating a "shared" singleton object of our CorData Manager to access in other classes/files
    static let shared = CoreDataManager()
    
    // Let's grab a hold of our viewContext/scratch pad by tapping into this current application's app delegate
    // Tapping into our ENTIRE app, via shared singleton format and tapping into the delegate of it, we then cast it as OUR current AppDelegate and close parentheses essentially creating an object in which we can now tap into the persistentContainer and then into our viewContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // Create an array of scores we can equal it to the value we fetch in our fetchScores method
    var scoresArray = [Score]()
    
    // Add score and streak to Core Data
    func addScoreAndStreak(score: Int, streak: Int) {
        // Create newScore object and pass in context aka viewContext from the persistent container into the pre-created context parameter
        let newScore = Score(context: context)
        newScore.streaksNumber = Int64(streak)
        newScore.pointsNumber = Int64(score)
        
        print("This is the steaks number fro coreeeeeeeeee dataaaa manager \(newScore.streaksNumber)")
        
        // Try will throw an error so we will wrap it in a do/catch block
        do {
            try context.save()
        } catch {
            print("Error saving streak \(error)")
        }
    }
    
    // Fetch the latest streak from Core Data
    func fetchLatestStreak() -> Int? {
        let fetchRequest = NSFetchRequest<Score>(entityName: "Score")
        let sortDescriptor = NSSortDescriptor(key: "pointsNumber", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1  // Limit the result to one object (the latest score)
        
        do {
            let scores = try context.fetch(fetchRequest)
            if let latestScore = scores.first {
                return Int(latestScore.streaksNumber)
            }
        } catch {
            print("Error fetching latest streak: \(error)")
        }
        
        return nil
    }

    func fetchScores() -> [Score] {
        // Create fetch request of type NSFetchRequest of Scores for class/entity name "Score" per our Core Data creation
        let fetchRequest = NSFetchRequest<Score>(entityName: "Score")
        
        // Try will throw an error so we will wrap it in a do/catch block
        do {
            scoresArray = try context.fetch(fetchRequest)
        } catch {
            print("Issues with fetching scores \(error)")
        }
        
        // This will return the scores array which we will then capture in our GamePlayOneViewController and set it equal to its hotStreaksCountTableViewArray array
        return scoresArray
    }
}
