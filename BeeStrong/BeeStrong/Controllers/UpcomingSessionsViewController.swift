//
//  UpcomingSessionsViewController.swift
//  BeeStrong
//
//  Created by Sofie Louise Madsen on 18/12/2020.
//

import UIKit

class UpcomingSessionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let traningSessionManager = TrainingSessionsManager()
    var trainingSessions: [TrainingSession]?
    
    @IBOutlet var upcomingSessionsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingSessionsTableView.delegate = self
        upcomingSessionsTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        trainingSessions = traningSessionManager.getAllTrainingSessions()
        upcomingSessionsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainingSessions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingTrainingSessionCell") as! UpcomingTrainingSessionCell
        let trainingSession = trainingSessions?[indexPath.row]
        
        let date = (trainingSession?.value(forKey: "startDate") as! Date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY HH.mm"
        
        cell.dateLabel.text = dateFormatter.string(from: date)
        cell.workouts.text = Array(trainingSession?.workouts as! Set<Workout>).map{$0.title!}.joined(separator: "\n")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
