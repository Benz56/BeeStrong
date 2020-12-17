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
    let googleCalendarAPI = GoogleCalendarAPI();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedWorkoutsTableView.delegate = self
        selectedWorkoutsTableView.dataSource = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        dateLabel.text = dateFormatter.string(from: date!)
        
        //TODO Remove test
        workoutManager.add(title: "Chest", with: [Exercise]())
        workoutManager.add(title: "Tricepts", with: [Exercise]())
        workoutManager.add(title: "Stomach", with: [Exercise]())
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
        self.googleCalendarAPI.createEventEndpoint(name: "Training session", description: workouts.description, startDate: date ?? Date(), endDate: Date(timeInterval: 3600, since: date ?? Date()))
        alertOnSave()
    }
    
    func alertOnSave() {
        let inputAlert = UIAlertController(title: "Saved", message: "Training session is saved.", preferredStyle: .alert)
        inputAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(inputAlert, animated: true, completion: nil)
    }
}
