//
//  WorkoutsViewController.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 02/11/2020.
//

import UIKit

class WorkoutsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let workoutManager = WorkoutManager()
    var workouts: [Workout]?
    
    @IBOutlet weak var savedWorkoutsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedWorkoutsTableView.delegate = self
        savedWorkoutsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        workouts = workoutManager.getAllWorkouts()
        savedWorkoutsTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedWorkoutCell") as! SavedWorkoutTableViewCell
        let workout = workouts?[indexPath.row]

        cell.titleLabel.text = workout?.title
        cell.exercisesLabel.text = workout?.exercises?.array.map{e in e as! Exercise}.map{e in e.exerciseType!.title!}.joined(separator: "\n") ?? "?"
        
        return cell
    }
}
