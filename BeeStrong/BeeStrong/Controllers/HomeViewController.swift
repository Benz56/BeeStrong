//
//  ViewController.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 02/11/2020.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var upcomingWorkoutsTableView: UpcomingSessionsUITableView!
    
    @IBAction func onCalenderTouched(_ sender: UIButton) {
        self.tabBarController?.selectedViewController = tabBarController?.viewControllers?.first{$0 is CalenderViewController}
    }
    
    @IBAction func onWorkoutsTouched(_ sender: UIButton) {
        self.tabBarController?.selectedViewController = tabBarController?.viewControllers?.first{$0 is WorkoutsViewController}
    }
    
    @IBAction func onProgressTouched(_ sender: UIButton) {
        self.tabBarController?.selectedViewController = tabBarController?.viewControllers?.first{$0 is ProcessViewController}
    }
    
    @IBAction func onGoogleCalenderTouched(_ sender: UIButton) {
        //TODO Go to Google Calender
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        upcomingWorkoutsTableView.reloadData()
    }
}
