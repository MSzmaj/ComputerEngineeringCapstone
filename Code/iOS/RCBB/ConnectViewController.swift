//
//  ConnectViewController.swift
//  RCBB
//
//  Created by Michal Szmaj on 2017-03-29.
//  Copyright © 2017 Michal Szmaj. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {
    //Public variables
    var statusText: String = Constants.ConnectionStatus.connect
    
    //Private variables
    private var socket: Socket!
    private var connected: Bool = false
    
    //Interface builder outlets
    @IBOutlet weak var ConnectButton: UIButton!
    
    //Interface builder actions
    @IBAction func ConnectButtonPressed () {
        if statusText == Constants.ConnectionStatus.connect {
            Connect()
        } else if statusText == Constants.ConnectionStatus.retry {
            Disconnect()
            Connect()
        } else if statusText == Constants.ConnectionStatus.disconnect {
            Disconnect()
            SetStatusButtonText(with: Constants.ConnectionStatus.connect)
        }
    }
    
    //UIViewController overrides
    
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
    
    override func viewDidLoad() {
        ResetSocket()
        super.viewDidLoad()
        self.title = Constants.ConnectionStatus.connect
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Navigates to the user data view. Transfers the socket connection
     */
    func GoToUserDataView () {
        if !connected {
            let userDataViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserDataView") as! UserDataViewController
            userDataViewController.socket = socket
            connected = true
            self.navigationController?.pushViewController(userDataViewController, animated: true)
        }
    }
    
    /**
     Sets the status button text
     */
    func SetStatusButtonText (with text: String) {
        statusText = text
        ConnectButton!.setTitle(statusText, for: .normal)
    }
    
    /**
     Connects the socket to the host. Sets the button text appropriately
     */
    private func Connect () {
        let serverResponse = socket.ConnectToHost()
        if serverResponse != 0 {
            statusText = Constants.ConnectionStatus.retry
            ResetSocket()
            return
        }
        ConnectButton!.setTitle(statusText, for: .normal)
    }
    
    /**
     Disconnects the socket and restarts it
     */
    private func Disconnect () {
        connected = false
        socket.DisconnectFromHost()
    }
    
    /**
     Restarts the socket
     */
    private func ResetSocket () {
        socket = Socket(withHost: Constants.Connection.address, withPort: Constants.Connection.port, withDelegate: self)
    }
}
