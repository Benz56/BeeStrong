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
    
    var calendarName = "BeeStrong Training sessions";
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
        
        self.authorizeCurrentUser()
        return service
    }()
    
    func authorizeCurrentUser(){
        guard let service = self.calendarService,
              let currentUser = GIDSignIn.sharedInstance().currentUser,
              let authentication = currentUser.authentication else {
            return
        }
        service.authorizer = authentication.fetcherAuthorizer()
    }
    
    func createTrainingCalendar() -> String? {
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
        service.executeQuery(query, completionHandler: { (ticket, result, error) in
            guard error == nil, let calendar = (result as? GTLRCalendar_Calendar) else {
                print(error!)
                return
            }
            self.calendarId = calendar.identifier!
        })
        return self.calendarId;
    }
    
    func getListOfCalendars() -> [GTLRCalendar_CalendarListEntry]?{
        guard let service = self.calendarService else {
            print("No calendar service found.")
            return nil
        }
        
        /// Querying API for list of calendars
        let query = GTLRCalendarQuery_CalendarListList.query();
        service.executeQuery(query, completionHandler : { (ticket, result, error) in
            guard error == nil, let calendars = (result as? GTLRCalendar_CalendarList)?.items else {
                print(error!)
                return
            }
            if calendars.count > 0 {
                for calendar in calendars {
                    print(calendar.summary!)
                    print(calendar.identifier!)
                    print("")
                }
            }
            self.calendarList = calendars;
            
        });
        return calendarList;
    }
    
    func getIdOfTrainingCalendar() -> String? {
        if (self.calendarList == nil){
            self.getListOfCalendars();
        }
        if let calendars = self.calendarList {
            for calendar in calendars {
                if (calendar.summary == self.calendarName) {
                    print("Training calendar found. \(calendar.identifier!)")
                    self.calendarId = calendar.identifier!
                    return calendar.identifier!
                }
            }
        }
        print("No training calendar found.")
        return self.createTrainingCalendar()
    }
    
    func createEvent(name: String, startDate: Date, endDate: Date) {
        guard let service = self.calendarService else {
            print("Creating event failed. Error with calendar service")
            return
        }
        
        let newEvent = GTLRCalendar_Event();
        newEvent.summary = "Training session 1"
        
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
            print(event.summary!)
            print(event.identifier!)
        });
    }
    
    func createTestEvent(name: String, startDate: Date, endDate: Date) {
        guard let service = self.calendarService else {
            print("Creating event failed. Error with calendar service")
            return
        }
        
        let newEvent = GTLRCalendar_Event();
        newEvent.summary = "Training session 1"
        
        //Start Date.
        let startDateTime: GTLRDateTime = GTLRDateTime(date: Date())
        let startEventDateTime: GTLRCalendar_EventDateTime = GTLRCalendar_EventDateTime()
        startEventDateTime.dateTime = startDateTime
        newEvent.start = startEventDateTime
        
        //Same as start date, but for the end date
        let endDateTime: GTLRDateTime = GTLRDateTime(date: Date(timeInterval: 3600, since: Date()))
        let endEventDateTime: GTLRCalendar_EventDateTime = GTLRCalendar_EventDateTime()
        endEventDateTime.dateTime = endDateTime
        newEvent.end = endEventDateTime
        
        //The query
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
            print(event.summary!)
            print(event.identifier!)
        });
    }
}

