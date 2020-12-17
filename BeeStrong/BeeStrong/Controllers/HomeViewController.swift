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
        selectController(type: CalenderViewController.self)
    }
    
    @IBAction func onWorkoutsTouched(_ sender: UIButton) {
        selectController(type: WorkoutsViewController.self)
    }
    
    @IBAction func onProgressTouched(_ sender: UIButton) {
        selectController(type: ProcessViewController.self)
    }
    
    @IBAction func onGoogleCalenderTouched(_ sender: UIButton) {
        selectController(type: GoogleSignInViewController.self)
    }
    
    func selectController(type: AnyClass) {
        self.tabBarController?.selectedViewController = tabBarController?.viewControllers?.first{$0.isKind(of: type) || ($0 is UINavigationController && ($0 as! UINavigationController).viewControllers.contains{c in c.isKind(of: type)})}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        upcomingWorkoutsTableView.reloadData()
    }
}
