//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = K.appName
        
//        var charIdx = 0.0
//        let wholeTitle = "⚡️FlashChat"
//        titleLabel.text = ""
//
//        for char in wholeTitle {
//            print("---------------")
//            print(char)
//            Timer.scheduledTimer(withTimeInterval: 0.1*charIdx, repeats: false) { _ in
//                self.titleLabel.text?.append(char)
//            }
//            charIdx+=1
//        }

       
    }
    

}
