//
//  UpcomingSessionsUITableView.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 16/12/2020.
//

import Foundation
import UIKit
import CoreData

class UpcomingSessionsUITableView: UITableView, UITableViewDelegate, UITableViewDataSource{
    
    var traningSessionManager = TrainingSessionsManager()
    var trainingSessions: [TrainingSession]?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
        dataSource = self
    }
    
    override func reloadData() {
        trainingSessions = traningSessionManager.getAllTrainingSessions()
        super.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainingSessions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingTrainingSessionCell") as! UpcomingTrainingSessionCell
        let trainingSession = trainingSessions?[indexPath.row]
        
        let date = (trainingSession?.value(forKey: "date") as! Date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY HH.mm"
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        cell.workouts.text = Array(trainingSession?.value(forKey: "workouts") as! Set<Workout>).map{$0.title!}.joined(separator: "\n")
        return cell
    }
}
