//
//  CalenderViewController.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 02/11/2020.
//

import UIKit
import KDCalendar

class CalenderViewController: UIViewController, CalendarViewDataSource, CalendarViewDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var workoutPickerView: UIPickerView!
    @IBOutlet weak var workoutToolbar: UIToolbar!
    @IBOutlet weak var workourToolBarButton: UIBarButtonItem!
    @IBOutlet weak var calendar: CalendarView!
    
    @IBOutlet weak var upcomingSessionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerSetup()
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
    
    func tableViewSetup() {
        upcomingSessionsTableView.delegate = self
        upcomingSessionsTableView.dataSource = self
    }
    
    func pickerSetup() {
        workoutPickerView.delegate = self
        workoutPickerView.dataSource = self
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //TODO model count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingSessionTableCell") as! UpcomingSessionsTableViewCell
        
        cell.sessionText.text = "x" //TODO Replace with actual data.
        
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10 // TODO number of workouts.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "x" //TODO Return model[row]
    }
    
    @IBAction func onWorkoutSelected(_ sender: UIBarButtonItem) {
        workoutPickerView.isHidden = true
        workoutToolbar.isHidden = true
        workoutPickerView.selectedRow(inComponent: 0)
        //TODO Save the workout with the name at the row in the model.
    }
    
    @IBAction func onAddWorkout(_ sender: UIButton) {
        if calendar.selectedDates.count > 0 {
            workoutPickerView.isHidden = false
            workoutToolbar.isHidden = false
            workoutPickerView.selectRow(0, inComponent: 0, animated: false)
        }
    }
}
