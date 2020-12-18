//
//  GoogleCalendarAPI.swift
//  BeeStrong
//
//  Created by Sofie Louise Madsen on 16/12/2020.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

class GoogleCalendarAPI {
    
    var calendarName = "BeeStrong Training Sessions";
    var calendarId = "";
    var calendarList : [GTLRCalendar_CalendarListEntry]?;
    
    /// Creates calendar service with current authentication
    fileprivate lazy var calendarService: GTLRCalendarService? = {
        let service = GTLRCalendarService()
        /// Have the service object set tickets to fetch consecutive pages of the feed so we do not need to manually fetch them
        service.shouldFetchNextPages = true
        /// Have the service object set tickets to retry temporary error conditions automatically
        service.isRetryEnabled = true
        service.maxRetryInterval = 15
        
        guard let currentUser = GIDSignIn.sharedInstance().currentUser,
              let authentication = currentUser.authentication else {
            print("Problems with authenticating user for calendar service.")
            return service
        }
        service.authorizer = authentication.fetcherAuthorizer()
        return service
    }()
    
    init() {
        guard let currentUser = GIDSignIn.sharedInstance().currentUser,
              let authentication = currentUser.authentication else {
            return
        }
        fetchListOfCalendars()
        // Register notification to load data again, after user successfully signed in
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadDataOnLogin(_:)),
                                               name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
    }
    
    @objc func loadDataOnLogin(_ notification: Notification) {
        fetchListOfCalendars()
    }
    
    func createEventEndpoint(name: String, description: String, startDate: Date, endDate: Date) {
        guard let currentUser = GIDSignIn.sharedInstance().currentUser,
              let authentication = currentUser.authentication else {
            print("Event not created. User is not authenticated.")
            return
        }
        getIdOfTrainingCalendar()
        if (calendarId != "") {
            createEvent(name: name, description: description, startDate: startDate, endDate: endDate)
        } else {
            createCalendarAndEvent(name, description, startDate, endDate)
        }
    }
    
    private func fetchListOfCalendars() -> GTLRServiceTicket? {
        guard let service = self.calendarService else {
            print("No calendar service found.")
            return nil
        }
        
        /// Querying API for list of calendars
        let query = GTLRCalendarQuery_CalendarListList.query();
        return service.executeQuery(query, completionHandler : { (ticket, result, error) in
            guard error == nil, let calendars = (result as? GTLRCalendar_CalendarList)?.items else {
                print(error!)
                return
            }
            self.calendarList = calendars;
        });
    }
    
    private func createTrainingCalendar() -> GTLRServiceTicket? {
        print("Creating training calendar")
        guard let service = self.calendarService else {
            print("No calendar service found.")
            return nil
        }
        /// Define calendar properties
        let calendar = GTLRCalendar_Calendar();
        calendar.summary = self.calendarName
        calendar.timeZone = "Europe/Zurich"
        
        ///Running the query to the Google Calendar API to insert Calendar
        let query = GTLRCalendarQuery_CalendarsInsert.query(withObject: calendar);
        query.fields = "id"
        return service.executeQuery(query, completionHandler: { (ticket, result, error) in
            guard error == nil, let calendar = (result as? GTLRCalendar_Calendar) else {
                print(error!)
                return
            }
            self.calendarId = calendar.identifier!
        })
    }
    
    private func getIdOfTrainingCalendar() -> String? {
        guard self.calendarList != nil else {
            print("Fetching id failed. No calendars to validate against.")
            return nil
        }
        if let calendars = self.calendarList {
            for calendar in calendars {
                if (calendar.summary == self.calendarName) {
                    print("Training calendar found. \(calendar.identifier!)")
                    self.calendarId = calendar.identifier!
                    return self.calendarId
                }
            }
        }
        print("No training calendar found.")
        return nil
    }
    
    private func createEvent(name: String, description: String, startDate: Date, endDate: Date) {
        guard let service = self.calendarService, calendarId != "" else {
            print("Creating event failed. Error with calendar service or calendarId")
            return
        }
        
        let newEvent = GTLRCalendar_Event();
        newEvent.summary = name
        newEvent.descriptionProperty = description
        
        ///Start Date
        let startDateTime: GTLRDateTime = GTLRDateTime(date: startDate)
        let startEventDateTime: GTLRCalendar_EventDateTime = GTLRCalendar_EventDateTime()
        startEventDateTime.dateTime = startDateTime
        newEvent.start = startEventDateTime
        
        ///End date
        let endDateTime: GTLRDateTime = GTLRDateTime(date: endDate)
        let endEventDateTime: GTLRCalendar_EventDateTime = GTLRCalendar_EventDateTime()
        endEventDateTime.dateTime = endDateTime
        newEvent.end = endEventDateTime
        
        /// Querying API to insert event with existing
        let query =
            GTLRCalendarQuery_EventsInsert.query(withObject: newEvent, calendarId: self.calendarId)
        
        //This is the part that I forgot. Specify your fields! I think this will change when you add other perimeters, but I need to review how this works more.
        query.fields = "id,summary";
        
        //This is actually running the query you just built
        service.executeQuery(query, completionHandler: { (ticket, result, error) in
            guard error == nil, let event = (result as? GTLRCalendar_Event) else {
                print(error!)
                return
            }
            print("Event created in Google Calendar: \(event.identifier!)")
        });
    }
    
    fileprivate func createCalendarAndEvent(_ name: String, _ description: String, _ startDate: Date, _ endDate: Date) {
        guard let service = self.calendarService else {
            print("Creating event failed. Error with calendar service")
            return
        }
        /// Create training calendar and new event
        /// Define calendar properties
        let calendar = GTLRCalendar_Calendar();
        calendar.summary = self.calendarName
        calendar.timeZone = "Europe/Zurich"
        
        ///Running the query to the Google Calendar API to insert Calendar
        let query = GTLRCalendarQuery_CalendarsInsert.query(withObject: calendar);
        query.fields = "id"
        service.executeQuery(query, completionHandler: { (ticket, result, error) in
            guard error == nil, let calendar = (result as? GTLRCalendar_Calendar) else {
                print(error!)
                return
            }
            self.calendarId = calendar.identifier!
            self.createEvent(name: name, description: description, startDate: startDate, endDate: endDate)
        })
    }
    
    func createTestEvent() {
        print("Creating test event")
        let description = """
Chest:
5 sets Bench

Glutes:
5 sets Deadlift
5 sets Hip Thrusters
"""
        self.createEventEndpoint(name: "Training session", description: description, startDate: Date(), endDate: Date(timeInterval: 3600, since: Date()))
    }
}
