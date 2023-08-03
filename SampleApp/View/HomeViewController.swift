//
//  ViewController.swift
//  SampleApp
//
//  Created by DoodleBlue on 13/07/23.
//

import UIKit
import Reachability

class HomeViewController: UIViewController {

    let reachability = try! Reachability()
   
    @IBAction func btnToSignInPage(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SignUpScreen") as? SignUpScreen
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnToGoogleMaps(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "GoogleMapsScreen") as? GoogleMapsScreen
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        self.reach()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reachability.stopNotifier()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.reach()
    }
    
    func showToast(message: String) {
        let toastController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(toastController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            toastController.dismiss(animated: true, completion: nil)
            
        }
        }
    func reach(){
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                self.showToast(message: "Reachable via WiFi")
                print("Reachable via WiFi")
            } else {
                self.showToast(message: "Reachable via Cellular")
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            self.showToast(message: "Not reachable")
            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            self.showToast(message: "Unable to start notifier")
            print("Unable to start notifier")
        }
        
    }
    
}

