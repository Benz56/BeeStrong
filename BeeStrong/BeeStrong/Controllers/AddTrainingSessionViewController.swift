//
//  AddTrainingSessionViewController.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 16/12/2020.
//

import UIKit
import CoreData
import GoogleSignIn
import GoogleAPIClientForREST

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
    let defaults = UserDefaults.standard
    
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
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            saveEventInGoogleCalendar(workouts)
            print("User is signed in. Event is saved.")
            _ = self.navigationController?.popViewController(animated: true)
        } else if (defaults.bool(forKey: "dontShowAgain")) {
            print("Don't show is true.")
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            alertOnSave(workouts)
        }
    }
    
    private func saveEventInGoogleCalendar(_ workouts: [Workout]) {
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
    
    func alertOnSave(_ workouts: [Workout]) {
        let inputAlert = UIAlertController(title: "Google Sign In", message: "You are not logged in with Google. If you sign in with Google, an entry is created in Google Calendar as well. Would you like to sign in?", preferredStyle: .alert)
        inputAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            // Go to sign in. After sign in come back here and save to google calendar
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance()?.scopes.append(contentsOf: [kGTLRAuthScopeCalendarEvents, kGTLRAuthScopeCalendar])
            GIDSignIn.sharedInstance()?.signIn()
        }))
        inputAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        inputAlert.addAction(UIAlertAction(title: "Don't show again", style: .default, handler: { (UIAlertAction) in
            //Remember this setting in storage
            self.defaults.setValue(true, forKey: "dontShowAgain");
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(inputAlert, animated: true)
    }
    
    private func workoutToString(_ workout: Workout?) -> String {
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
