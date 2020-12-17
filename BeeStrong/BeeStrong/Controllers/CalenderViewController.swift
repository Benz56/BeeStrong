//
//  CalenderViewController.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 02/11/2020.
//

import UIKit
import KDCalendar

class CalenderViewController: UIViewController, CalendarViewDataSource, CalendarViewDelegate {

    @IBOutlet weak var calendar: CalendarView!
    @IBOutlet weak var upcomingSessionsTableView: UpcomingSessionsUITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarSetup()
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier == "NewTrainingSession" && calendar.selectedDates.count == 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "NewTrainingSession") {
            (segue.destination as! AddTrainingSessionViewController).date = calendar.selectedDates.first
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        upcomingSessionsTableView.reloadData()
    }
}
