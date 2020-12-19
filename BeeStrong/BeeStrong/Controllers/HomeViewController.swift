//
//  ViewController.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 02/11/2020.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let traningSessionManager = TrainingSessionsManager()
    var trainingSessions: [TrainingSession]?
    let dateFormatter = DateFormatter()
    var selectedDate = "No date specified"
    var selectedTrainingSession: TrainingSession?
    
    @IBOutlet weak var upcomingSessionsTableView: UITableView!
    
    @IBAction func onCalenderTouched(_ sender: UIButton) {
        selectController(type: CalenderViewController.self)
    }
    
    @IBAction func onWorkoutsTouched(_ sender: UIButton) {
        selectController(type: WorkoutsViewController.self)
    }
    
    @IBAction func onProgressTouched(_ sender: UIButton) {
        selectController(type: ProcessViewController.self)
    }
    
    @IBAction func onGoogleCalenderTouched(_ sender: UIButton) {
        selectController(type: GoogleSignInViewController.self)
    }
    
    func selectController(type: AnyClass) {
        self.tabBarController?.selectedViewController = tabBarController?.viewControllers?.first{$0.isKind(of: type) || ($0 is UINavigationController && ($0 as! UINavigationController).viewControllers.contains{c in c.isKind(of: type)})}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingSessionsTableView.delegate = self
        upcomingSessionsTableView.dataSource = self
        dateFormatter.dateFormat = "dd-MM-YYYY HH.mm"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        trainingSessions = traningSessionManager.getAllTrainingSessions()
        upcomingSessionsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainingSessions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingTrainingSessionCell") as! UpcomingTrainingSessionCell
        let trainingSession = (trainingSessions?[indexPath.row])! as TrainingSession
        
        cell.dateLabel.text = dateFormatter.string(from: trainingSession.startDate!)
        cell.workouts.text = Array(trainingSession.workouts as! Set<Workout>).map{$0.title!}.joined(separator: "\n")
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToDetailView") {
            if let detailView = segue.destination as? TrainingSessionDetailViewController {
                let trainingSession = (trainingSessions?[self.upcomingSessionsTableView.indexPathForSelectedRow!.row])! as TrainingSession
                detailView.date = dateFormatter.string(from: trainingSession.startDate!)
                detailView.trainingSession = trainingSession
            }
        }
    }
}
