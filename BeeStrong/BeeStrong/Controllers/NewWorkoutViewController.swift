//
//  NewWorkoutViewController.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 17/12/2020.
//

import UIKit
import CoreData

class NewWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var workoutTitleLabel: UITextField!
    @IBOutlet weak var exercisesTableView: UITableView!
    
    private let workoutManager = WorkoutManager()
    
    var exercises = [Exercise]() {
        didSet {
            exercisesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exercisesTableView.delegate = self
        exercisesTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell") as! ExerciseTableViewCell
        cell.reps.forEach{tf in
            tf.delegate = self
            tf.addTarget(self, action: #selector(textFieldEdited), for: .editingDidEnd)
        }
        cell.kg.forEach{tf in
            tf.delegate = self
            tf.addTarget(self, action: #selector(textFieldEdited), for: .editingDidEnd)
        }
        let et = exercises[indexPath.row]
        cell.title.text = et.exerciseType?.title
        return cell
    }
    
    @objc func textFieldEdited(_ textField: UITextField) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExercise" {
            (segue.destination as! ExerciseTypeViewController).previouslySelectedExerciseTypes = exercises.map{$0.exerciseType!}
        }
    }
    
    @IBAction func onSaveWorkout(_ sender: UIBarButtonItem) {
        if !(workoutTitleLabel.text?.isEmpty ?? true) && exercises.count > 0 {            
            workoutManager.add(title: title!, with: exercises)
            navigationController?.popViewController(animated: true)
        }
    }
}
