//
//  ViewController.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 02/11/2020.
//

import UIKit

class HomeViewController: UIViewController {
    
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
    }
    
    
}
