//
//  MainMenuViewController.swift
//  RCBB
//
//  Created by Michal Szmaj on 2017-03-29.
//  Copyright © 2017 Michal Szmaj. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    //UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     Default orientation is Portrait
     */
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    /**
     Does not allow auto-rotation
     */
    open override var shouldAutorotate: Bool {
        return false
    }
    
    /**
     Default orientation is Portrait
     */
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {
            return .portrait
        }
    }
    
    //Interface Builder functions
    /**
     Navigates to the user conenct menu
    */
    @IBAction func StartButtonPressed(_ sender: UIButton) {
        let connectViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConnectView") as! ConnectViewController
        self.navigationController?.pushViewController(connectViewController, animated: true)
        self.navigationController?.navigationBar.topItem?.title = "Menu"
    }
    
    /**
     Navigates to the debug menu
     */
    @IBAction func DebuggingButtonPressed(_ sender: UIButton) {
        let debugStartViewController = self.storyboard?.instantiateViewController(withIdentifier: "DebugStartView")
        self.navigationController?.pushViewController(debugStartViewController!, animated: true)
    }
    //Public methods
    
    /**
     Navigates to the user connect menu
     */
    func UserButtonPressed (sender: UIButton!) {
        let connectViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConnectView") as! ConnectViewController
        self.navigationController?.pushViewController(connectViewController, animated: true)
        self.navigationController?.navigationBar.topItem?.title = "Menu"
    }
    
    /**
     Navigates to the debug menu
     */
    func DebugButtonPressed (sender: UIButton!) {
        let debugStartViewController = self.storyboard?.instantiateViewController(withIdentifier: "DebugStartView")
        self.navigationController?.pushViewController(debugStartViewController!, animated: true)
    }
}
