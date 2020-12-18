//
//  TrainingSessionDetailViewController.swift
//  BeeStrong
//
//  Created by Sofie Louise Madsen on 18/12/2020.
//

import UIKit
import CoreData

class TrainingSessionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    let workoutManager = WorkoutManager()
    var workouts: [Workout]?
    
    @IBOutlet weak var workoutsTableViewCell: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutsTableViewCell.delegate = self
        workoutsTableViewCell.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        workouts = workoutManager.getAllWorkouts()
        workoutsTableViewCell.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutDetailsCell")!
        let workout = workouts?[indexPath.row]

        cell.textLabel?.text = workout?.title
        /*
        cell.exercisesLabel.text = workout?.exercises?.array.map{e in e as! Exercise}.map{e in
            "\(e.exerciseType!.title!) \n   " + e.sets!.array.map{s in s as! WorkingSet}.map{s in "\(s.repetitions) reps @ \(s.weight) kg"}.joined(separator: "\n   ")
        }.joined(separator: "\n") ?? "?"
        */
        return cell
    }
    
}
