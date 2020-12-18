//
//  CalenderViewController.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 02/11/2020.
//

import UIKit
import KDCalendar

class CalenderViewController: UIViewController, CalendarViewDataSource, CalendarViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var calendar: CalendarView!
    @IBOutlet weak var upcomingSessionsTableView: UITableView!
    
    let traningSessionManager = TrainingSessionsManager()
    var trainingSessions: [TrainingSession]?
    let dateFormatter = DateFormatter()
    var selectedDate = "No date specified"
    var selectedTrainingSession: TrainingSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarSetup()
        tableViewSetup()
    }
    
    func calendarSetup() {
        calendar.dataSource = self
        calendar.delegate = self
        calendar.setDisplayDate(Date(), animated: false)
        let style = CalendarView.Style()
        style.cellShape = CalendarView.Style.CellShapeOptions.round
        style.cellColorDefault = .systemYellow
        style.cellTextColorDefault = .white
        style.cellTextColorWeekend = .white
        style.cellColorToday = .systemRed
        style.cellTextColorToday = .white
        style.cellColorOutOfRange = .systemGray
        style.cellSelectedBorderColor = .systemYellow
        style.cellSelectedBorderWidth = 5
        calendar.style = style
    }
    
    func startDate() -> Date {
        return Date()
    }
    
    func endDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 3
        let threeMonthsAgo = calendar.calendar.date(byAdding: dateComponents, to: Date())
        return threeMonthsAgo!
    }
    
    func headerString(_ date: Date) -> String? {
        return nil
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        calendar.selectedDates.filter{ $0 != date }.forEach { calendar.deselectDate($0) }
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "NewTrainingSession") {
            (segue.destination as! AddTrainingSessionViewController).date = calendar.selectedDates.first
        }
        if (segue.identifier == "goToDetailViewFromCalendar") {
            if let detailView = segue.destination as? TrainingSessionDetailViewController {
                let trainingSession = (trainingSessions?[self.upcomingSessionsTableView.indexPathForSelectedRow!.row])! as TrainingSession
                detailView.date = dateFormatter.string(from: trainingSession.startDate!)
                detailView.trainingSession = trainingSession
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        trainingSessions = traningSessionManager.getAllTrainingSessions()
        upcomingSessionsTableView.reloadData()
    }
    
    func tableViewSetup() {
        upcomingSessionsTableView.delegate = self
        upcomingSessionsTableView.dataSource = self
        dateFormatter.dateFormat = "dd-MM-YYYY HH.mm"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainingSessions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingTrainingSessionCell") as! UpcomingTrainingSessionCell
        let trainingSession = (trainingSessions?[indexPath.row])! as TrainingSession
        
        cell.dateLabel.text = dateFormatter.string(from: trainingSession.startDate!)
        cell.workouts.text = Array(trainingSession.workouts as! Set<Workout>).map{$0.title!}.joined(separator: "\n")
        return cell
    }
}
