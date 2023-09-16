//
//  HotStreaksController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 8/27/23.
//

import UIKit

class HotStreaksViewController: UIViewController {

    

    var hotStreaksCountTableViewArray = [Int]()
    
    // Now we can access the tableview and populate it with data
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegate and Datasouce linked via storyboard
    }
    
}

// How many cells will be displayed
extension HotStreaksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hotStreaksCountTableViewArray.count
    }
    
    // Where we will get the data to display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreakCell", for: indexPath)
        
        // Spicing things up and assigning a random text label to each cell returned
        let textLabels = [
            "You got \(String(hotStreaksCountTableViewArray[indexPath.row])) correct answers in a row",
            "\(String(hotStreaksCountTableViewArray[indexPath.row])) in a row, you are really that guy!",
            "Impressive! \(String(hotStreaksCountTableViewArray[indexPath.row])) in a row!",
            "Unstoppable! \(String(hotStreaksCountTableViewArray[indexPath.row])) consecutive answers!",
            "Bravo! \(String(hotStreaksCountTableViewArray[indexPath.row])) right answers in a row!",
            "You're on fire! \(String(hotStreaksCountTableViewArray[indexPath.row])) answers in a row!",
            "Wow! \(String(hotStreaksCountTableViewArray[indexPath.row])) correct answers in a row!",
            "Keep it up! \(String(hotStreaksCountTableViewArray[indexPath.row])) in a row!",
            "\(String(hotStreaksCountTableViewArray[indexPath.row])) consecutive wins! Impressive!",
            "Incredible! \(String(hotStreaksCountTableViewArray[indexPath.row])) right answers in a row!",
            "Champion! \(String(hotStreaksCountTableViewArray[indexPath.row])) in a row! Keep it up!"
        ]
        
        let randomTextLabel = textLabels.randomElement()
        
        // We want to update the name of each cell to equal the number of hot streaks in the hotStreaksCountTableViewArray
        cell.textLabel?.text = randomTextLabel
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        // Return the cell
        return cell
    }
    
}
