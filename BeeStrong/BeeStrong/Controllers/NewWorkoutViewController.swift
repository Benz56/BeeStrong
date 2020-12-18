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
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell") as! ExerciseTableViewCell
        for (i, tf) in cell.repsTextFields.enumerated() {
            tf.delegate = self
            tf.addTarget(self, action: #selector(textFieldEdited), for: .editingDidEnd)
            tf.fieldType = .reps
            tf.row = indexPath.section
            tf.set = i
        }
        for (i, tf) in cell.kgTextFields.enumerated() {
            tf.delegate = self
            tf.addTarget(self, action: #selector(textFieldEdited), for: .editingDidEnd)
            tf.fieldType = .kg
            tf.row = indexPath.section
            tf.set = i
        }
        let et = exercises[indexPath.section]
        cell.titleLabel.text = et.exerciseType?.title
        return cell
    }
    
    //TODO Could use some refactoring.
    @objc func textFieldEdited(_ textField: ExerciseTextField) {
        let exercise = exercises[textField.row]
        switch textField.fieldType {
        case .kg:
            if let weight = Double(textField.text!) {
                if exercise.sets?.count ?? 0 <= textField.set {
                    let workingSet = WorkingSet(context: workoutManager.context)
                    workingSet.weight = weight
                    exercise.addToSets(workingSet)
                } else {
                    (exercise.sets![textField.set] as! WorkingSet).weight = weight
                }
            } else {
                textField.text = ""
            }
            break
        case .reps:
            if let reps = Int64(textField.text!) {
                if exercise.sets?.count ?? 0 <= textField.set {
                    let workingSet = WorkingSet(context: workoutManager.context)
                    workingSet.repetitions = reps
                    exercise.addToSets(workingSet)
                } else {
                    (exercise.sets![textField.set] as! WorkingSet).repetitions = reps
                }
            } else {
                textField.text = ""
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
        let allDataEntered = exercises.allSatisfy{e in e.sets!.count > 0 && (e.sets?.array.map{$0 as! WorkingSet}.allSatisfy{ws in ws.weight >= 0 && ws.repetitions >= 0} ?? false)}
        if !(workoutTitleLabel.text?.isEmpty == true) && exercises.count > 0 && allDataEntered {
            workoutManager.add(title: workoutTitleLabel.text!, with: exercises)
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Missing Input", message: "Please make sure that you have entered a title and valid numbers in all REPS/KG input fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
