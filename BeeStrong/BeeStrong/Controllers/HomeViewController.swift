//
//  ViewController.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 02/11/2020.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let model = ["a", "b", "c", "d"] // Test.
    
    @IBOutlet weak var upcomingWorkoutsTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell") as! HomeTableViewCell
        
        cell.dateLabel.text = model[indexPath.row]
        cell.trainingSessionTitleLabel.text = model[indexPath.row]
        
        return cell
    }
    
    @IBAction func onCalenderTouched(_ sender: UIButton) {
        self.tabBarController?.selectedViewController = tabBarController?.viewControllers?.first(where: {$0 is CalenderViewController})
    }
    
    @IBAction func onWorkoutsTouched(_ sender: UIButton) {
        self.tabBarController?.selectedViewController = tabBarController?.viewControllers?.first(where: {$0 is WorkoutsViewController})
    }
    
    @IBAction func onProgressTouched(_ sender: UIButton) {
        self.tabBarController?.selectedViewController = tabBarController?.viewControllers?.first(where: {$0 is ProcessViewController})
    }
    
    @IBAction func onGoogleCalenderTouched(_ sender: UIButton) {
        //TODO Go to Google Calender
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        upcomingWorkoutsTableView.delegate = self
        upcomingWorkoutsTableView.dataSource = self
    }
    
    
}
