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
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workouts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedWorkoutCell") as! SavedWorkoutTableViewCell
        let workout = workouts?[indexPath.section]

        cell.titleLabel.text = workout?.title
        cell.exercisesLabel.text = workout?.exercises?.array.map{e in e as! Exercise}.map{e in
            "\(e.exerciseType!.title!) \n   " + e.sets!.array.map{s in s as! WorkingSet}.map{s in "\(s.repetitions) reps @ \(s.weight) kg"}.joined(separator: "\n   ")
        }.joined(separator: "\n") ?? "?"
        
        return cell
    }
}
