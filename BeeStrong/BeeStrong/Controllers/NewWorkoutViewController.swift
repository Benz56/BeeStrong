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
        cell.repsTextFields.forEach{tf in
            tf.delegate = self
            tf.addTarget(self, action: #selector(textFieldEdited), for: .editingDidEnd)
            tf.fieldType = .reps
            tf.row = indexPath.row
        }
        cell.kgTextFields.forEach{tf in
            tf.delegate = self
            tf.addTarget(self, action: #selector(textFieldEdited), for: .editingDidEnd)
            tf.fieldType = .kg
            tf.row = indexPath.row
        }
        let et = exercises[indexPath.row]
        cell.titleLabel.text = et.exerciseType?.title
        return cell
    }
    
    //TODO Refactor. Duplicated code.
    @objc func textFieldEdited(_ textField: ExerciseTextField) {
        let exercise = exercises[textField.row]
        switch textField.fieldType {
        case .kg:
            if exercise.sets?.count ?? 0 <= textField.set {
                let workingSet = WorkingSet(context: workoutManager.context)
                workingSet.weight = Double(textField.text!)! //TODO Dont force
                exercise.addToSets(workingSet)
            } else {
                (exercise.sets![textField.set] as! WorkingSet).weight = Double(textField.text!)!
            }
            break
        case .reps:
            if exercise.sets?.count ?? 0 <= textField.set {
                let workingSet = WorkingSet(context: workoutManager.context)
                workingSet.repetitions = Int64(textField.text!)! //TODO Dont force
                exercise.addToSets(workingSet)
            } else {
                (exercise.sets![textField.set] as! WorkingSet).repetitions = Int64(textField.text!)!
            }
            break
        case .none:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExercise" {
            (segue.destination as! ExerciseTypeViewController).previouslySelectedExerciseTypes = exercises.map{$0.exerciseType!}
        }
    }
    
    @IBAction func onSaveWorkout(_ sender: UIBarButtonItem) {
        if !(workoutTitleLabel.text?.isEmpty ?? true) && exercises.count > 0 {
            print(exercises)
            workoutManager.add(title: workoutTitleLabel.text!, with: exercises)
            navigationController?.popViewController(animated: true)
        }
    }
}
