//
//  SplashScreenViewController.swift
//  Tic-Tac-Toe
//
//  Created by Amit on 20/11/17.
//  Copyright © 2017 Amit. All rights reserved.
//

import UIKit
import Firebase

class SplashScreenViewController: UIViewController {

    @IBAction func online(_ sender: UIButton) {
        Messaging.messaging().subscribe(toTopic: "news")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
