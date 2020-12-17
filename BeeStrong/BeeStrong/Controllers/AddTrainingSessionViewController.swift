//
//  AddTrainingSessionViewController.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 16/12/2020.
//

import UIKit
import CoreData

class AddTrainingSessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let workoutManager = WorkoutManager()
    private var allWorkouts: [Workout]?
    @IBOutlet weak var selectedWorkoutsTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    var date: Date? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedWorkoutsTableView.delegate = self
        selectedWorkoutsTableView.dataSource = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        dateLabel.text = dateFormatter.string(from: date!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        allWorkouts = workoutManager.getAllWorkouts()
        selectedWorkoutsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allWorkouts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath)
        cell.textLabel?.text = allWorkouts?[indexPath.row].title //TODO Show exercises as well.
        return cell
    }
    
    @IBAction func onSaveTrainingSession(_ sender: UIBarButtonItem) {
        let tsManager = TrainingSessionsManager()
        var workouts = [Workout]()
        selectedWorkoutsTableView.indexPathsForSelectedRows?.forEach{workouts.append((allWorkouts?[$0.row])!)}
        tsManager.add(for: Date(), with: workouts)
    }

}
