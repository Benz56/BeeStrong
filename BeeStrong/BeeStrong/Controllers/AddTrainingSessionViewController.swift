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
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    var date: Date?
    let googleCalendarAPI = GoogleCalendarAPI();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedWorkoutsTableView.delegate = self
        selectedWorkoutsTableView.dataSource = self
        /// Give date object the current hour and minute. Otherwise it will always show 1:00 on the time pickers.
        if let dateWithoutHours = date {
            let hour = Calendar.current.component(.hour, from: Date())
            let minute = Calendar.current.component(.minute, from: Date())
            self.date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: dateWithoutHours)!
        } else {
            self.date = Date()
        }
        datePicker.date = date!
        startTimePicker.date = date!
        endTimePicker.date = Date(timeInterval: 120*60, since: date!)
        datePicker.minimumDate = Date()
        startTimePicker.minimumDate = Date()
        endTimePicker.minimumDate = Date()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        allWorkouts = workoutManager.getAllWorkouts()
        selectedWorkoutsTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allWorkouts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell") as! SavedWorkoutTableViewCell
        let workout = allWorkouts?[indexPath.row]

        cell.titleLabel.text = workout?.title
        cell.exercisesLabel.text = workoutToString(workout)
        
        return cell
    }
    
    @IBAction func onSaveTrainingSession(_ sender: UIBarButtonItem) {
        let tsManager = TrainingSessionsManager()
        var workouts = [Workout]()
        selectedWorkoutsTableView.indexPathsForSelectedRows?.forEach{workouts.append((allWorkouts?[$0.row])!)}
        tsManager.add(for: date!, with: workouts) //TODO set the selected time on the date. It should really be an interval.
        var sessionDescription = "<h2>Workouts</h2>"
        for workout in workouts {
            let workoutTitle = workout.title ?? ""
            sessionDescription += ("\n<b>" + workoutTitle + "</b>\n")
            sessionDescription += workoutToString(workout)
        }
        let title = titleLabel.text != nil ? titleLabel.text! : "Training session"
        self.googleCalendarAPI.createEventEndpoint(name: title, description: sessionDescription, startDate: startTimePicker.date, endDate: endTimePicker.date)
        alertOnSave()
    }
    
    func alertOnSave() {
        let inputAlert = UIAlertController(title: "Saved", message: "Training session is saved.", preferredStyle: .alert)
        inputAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(inputAlert, animated: true, completion: nil)
    }
    
    fileprivate func workoutToString(_ workout: Workout?) -> String {
        return workout?.exercises?.array.map{e in e as! Exercise}.map{e in
            "\(e.exerciseType!.title!) \n   " + e.sets!.array.map{s in s as! WorkingSet}.map{s in "\(s.repetitions) reps @ \(s.weight) kg"}.joined(separator: "\n   ")
        }.joined(separator: "\n") ?? "?"
    }
    
    @objc func datePickerValueChanged(_ datePicker: UIDatePicker) {
        endTimePicker.minimumDate = Date(timeInterval: 60, since: startTimePicker.date)
    }
}
