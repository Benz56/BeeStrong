//
//  TrainingSessionDetailViewController.swift
//  BeeStrong
//
//  Created by Sofie Louise Madsen on 18/12/2020.
//

import UIKit
import CoreData

class TrainingSessionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let workoutManager = WorkoutManager()
    var workouts: [Workout]?
    var exercises: [Exercise]?
    var trainingSession: TrainingSession?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var workoutsTableView: UITableView!
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "WorkoutDetailTableViewCell", bundle: nil)
        workoutsTableView.register(nib, forCellReuseIdentifier: "WorkoutDetailTableViewCell")
        workoutsTableView.delegate = self
        workoutsTableView.dataSource = self
        dateLabel.text = date ?? ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(trainingSession != nil) {
            workouts = Array(trainingSession?.workouts as! Set<Workout>)
            exercises = []
            for workout in workouts! {
                let workoutExercises = workout.exercises?.array.map{e in e as! Exercise}
                if(workoutExercises != nil) {
                    exercises?.append(contentsOf: workoutExercises!)
                }
            }
        }
        workoutsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts![section].exercises?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return workouts![section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutDetailTableViewCell") as! WorkoutDetailTableViewCell
        let e = workouts?[indexPath.section].exercises?.array.map{e in e as! Exercise}[indexPath.row]
        cell.title.text = e!.exerciseType!.title! + "\n   " + ((e?.sets!.array.map{s in s as! WorkingSet}.map{s in "\(s.repetitions) reps @ \(s.weight) kg"}.joined(separator: "\n   "))!)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workouts?.count ?? 0
    }
    
}
