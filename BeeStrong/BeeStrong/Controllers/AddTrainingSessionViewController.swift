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
        startTimePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
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
        tsManager.add(for: getDate(timePicker: startTimePicker), for: getDate(timePicker: endTimePicker), with: workouts)
        saveEventInGoogleCalendar(workouts)
        alertOnSave()
    }
    
    fileprivate func saveEventInGoogleCalendar(_ workouts: [Workout]) {
        //TODO set the selected time on the date. It should really be an interval.
        var sessionDescription = "<h2>Workouts</h2>"
        for workout in workouts {
            let workoutTitle = workout.title ?? ""
            sessionDescription += ("\n<b>" + workoutTitle + "</b>\n")
            sessionDescription += workoutToString(workout)
        }
        let title = titleLabel.text != nil ? titleLabel.text! : "Training session"
        self.googleCalendarAPI.createEventEndpoint(name: title, description: sessionDescription, startDate: getDate(timePicker: startTimePicker), endDate: getDate(timePicker: endTimePicker))
    }
    
    func alertOnSave() {
        let inputAlert = UIAlertController(title: "Training session is saved", message: "If you are logged in with Google, an entry is created in Google Calendar as well.", preferredStyle: .alert)
        inputAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(inputAlert, animated: true)
    }
    
    fileprivate func workoutToString(_ workout: Workout?) -> String {
        return workout?.exercises?.array.map{e in e as! Exercise}.map{e in
            "\(e.exerciseType!.title!) \n   " + e.sets!.array.map{s in s as! WorkingSet}.map{s in "\(s.repetitions) reps @ \(s.weight) kg"}.joined(separator: "\n   ")
        }.joined(separator: "\n") ?? "?"
    }
    
    @objc func datePickerValueChanged(_ datePicker: UIDatePicker) {
        endTimePicker.minimumDate = startTimePicker.date
    }
    
    /// To avoid mismatch between date picker and time pickers date and time are merged
    func getDate (timePicker: UIDatePicker) -> Date {
        let hour = Calendar.current.component(.hour, from: timePicker.date)
        let minute = Calendar.current.component(.minute, from: timePicker.date)
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: self.datePicker.date)!
    }
}
