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
    
    // Let's grab a hold of our viewContext/scratch pad by tapping into this current applications app delegate
    // Tapping into our ENTIRE app, via shared singleton format and tapping into teh delegate of it, we then casy it as OUR current AppDelegate and close perenthisis enseitally creating and object in which we can now tap into the persistantCOntainer then into our viewCOntent
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // Create an array of scores we we can equal i to teh valie we fetch in our fetchScores method
    var scoresArray = [Score]()
    
    
    // Add score and streak to Core Data
    func addScoreAndStreak(score: Int, streak: Int) {
        
        // Create newScore object and pass in context aka viewContext from the persistant container into the pre created context parameter
        let newScore = Score(context: context)
        newScore.streaksNumber = Int64(streak)
        newScore.pointsNumber = Int64(score)
        
        // Try will throw an error so we will wrap it in a do/catch block
        do {
            try context.save()
        } catch {
            print("Error saving streak \(error)")
        }
    }
   

    func fetchScores() -> [Score] {
   
   // Create fetch request of type NSFetchRequest of Scores for class/enity name "Score" per our Coredata creation
    let fetchRequest = NSFetchRequest<Score>(entityName: "Score")
   
        
        
        // Try will throw an error so we will wrap it in a do/catch block
              do {
                  scoresArray = try context.fetch(fetchRequest)
             } catch {
                 print("Issues with fetching scores \(error)")
              }
        // Thsi will return scores array which we will then capture in out GamePlayOneViewCOntroller and set equal to its hotStreaksCountTableViewArray array
             return scoresArray
          }
   
    
   
}
    
    
