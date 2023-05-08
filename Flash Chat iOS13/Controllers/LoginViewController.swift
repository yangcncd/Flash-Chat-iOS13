//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var myLabel: UILabel!
     
    @IBAction func myButtonPressed(_ sender: UIButton) {
        print("i am pressed")
        let helloSequence0 = Observable.of(1,2,3)
        let helloSequence = Observable.of([1,2,3])
        
        let helloSequence2 = Observable.from([1,2,3])
        
        
        let helloSequence3 = Observable<[Int]>.just([1,2,4])
        let helloSequence4 = Observable<Int>.just(4)
        
        let subscription = helloSequence0.subscribe { event in
            switch event {
            case .next(let value):
                print(value)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
        
        print()
        print()
    }
    
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if let err = error{
                    print(err.localizedDescription)
                } else {
                    strongSelf.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
                
            }
        }
    }
    
}
