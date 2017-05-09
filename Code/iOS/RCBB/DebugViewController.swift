//
//  ViewController.swift
//  RCBB
//
//  Created by Michal Szmaj on 2017-03-10.
//  Copyright © 2017 Michal Szmaj. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController {
    //Private declarations
    private var socket: Socket!
    private var readData: RCBBData?
    private var command: String = Constants.Command.latest
    private var count = 0
    private var timer: Timer?
    
    //Private UI Declarations
    private var addressTextField: UITextField! = nil
    private var dataTextField: UITextField! = nil
    private var returnTextField: UITextView! = nil
    
    //UIViewController Overrides
    /**
     Starts socket and sets up user interface manually instead of using Interface Builder
    */
    override func viewDidLoad() {
        socket = Socket(withHost: Constants.Connection.address, withPort: Constants.Connection.port, withDelegate: self)
        super.viewDidLoad()
        SetupUserInterface()
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
    
    //MainViewController Button Methods
    
    /**
        Connects the application to the specific host/disconnects from host
    */
    func ConnectButtonPressed (sender: UIButton!) {
        socket.host = addressTextField.text!
        if socket.ConnectToHost() != 0 {
            print("Cannot connect")
            return
        }
        //timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.ReceiveData), userInfo: nil, repeats: true)
    }
    
    /**
        Sends the specified text to the server
     */
    func SendButtonPressed (sender: UIButton!) {
        let data = dataTextField.text != "" ? dataTextField.text! : "[invalid]"
        socket.WriteBytes(data: data)
    }
    
    /**
        Reads the bytes sent from the server and sets the return textfield to that value.
     */
    func ReadButtonPressed (sender: UIButton!) {
        let data = GetData()
        var string = ""
        for datum in data {
            string += datum.asString() + " ; "
        }
        readData = data[0]
        returnTextField.text = string
    }
    
    /**
        Navigates to the DataView view
     */
    func NextButtonPressed (sender: UIButton!) {
        let debugDataViewController = self.storyboard?.instantiateViewController(withIdentifier: "DebugDataView") as! DebugDataViewController
        debugDataViewController.data = readData
        self.navigationController?.pushViewController(debugDataViewController, animated: true)
    }
    
    //Private MainViewController Methods
    
    /**
        Callback for the timer which receices data while the socket is connected.
     */
    private func ReceiveData () {
        if (socket.connected && socket.socketError == nil) {
            socket.WriteBytes(data: command)
            let data = GetData()
            var string = ""
            for datum in data {
                string += datum.asString() + ";"
            }
            count += 1
            returnTextField.text = string + String(count)
        }
    }
    
    /**
        Reads the bytes sent from the server and parses them accordingly.
        @return RCBBData list filled with data from server
     */
    private func GetData () -> [RCBBData] {
        let test = socket.ReadBytes()
        let data = test.components(separatedBy: ";")
        var parseData: [RCBBData] = []
        for datum in data {
            let parsedString = JSONParser.Decode(data: datum)
            if parsedString != nil {
                parseData.append(parsedString!)
            }
        }
        return parseData
    }
    
    //UI Setup
    /**
        Sets up the UI for the main UIView in the Main storyboard
    */
    private func SetupUserInterface () {
        //Address label start:
        let addressLabel = UILabel(frame: CGRect(x: 100, y: 150, width: 100, height: 25))
        addressLabel.center.x = self.view.frame.width / 4
        addressLabel.text = "Address:"
        self.view.addSubview(addressLabel)
        //Address label end
        
        //Address text field start:
        addressTextField = UITextField(frame: CGRect(x: 100, y: 150, width: 100, height: 25))
        addressTextField.center.x = self.view.frame.width / 2
        addressTextField.backgroundColor = .white
        addressTextField.borderStyle = .roundedRect
        self.view.addSubview(addressTextField)
        //Address text field end
        
        //Connect button start:
        let connectButton = UIButton(frame: CGRect(x: 100, y: 150, width: 100, height: 25))
        connectButton.center.x = self.view.frame.width / 1.25
        connectButton.setTitleColor(.blue, for: .normal)
        connectButton.setTitleColor(.lightGray, for: .highlighted)
        connectButton.setTitle("Connect", for: .normal)
        connectButton.addTarget(self, action: #selector(ConnectButtonPressed), for: .touchUpInside)
        self.view.addSubview(connectButton)
        //Connect button end
        
        //Data label start:
        let dataLabel = UILabel(frame: CGRect(x: 100, y: 175, width: 100, height: 25))
        dataLabel.center.x = self.view.frame.width / 4
        dataLabel.text = "Send data:"
        self.view.addSubview(dataLabel)
        //Data label end
        
        //Data text field start:
        dataTextField = UITextField(frame: CGRect(x: 100, y: 175, width: 100, height: 25))
        dataTextField.center.x = self.view.frame.width / 2
        dataTextField.backgroundColor = .white
        dataTextField.borderStyle = .roundedRect
        self.view.addSubview(dataTextField)
        //Data text field end
        
        //Send button start:
        let sendButton = UIButton(frame: CGRect(x: 100, y: 175, width: 100, height: 25))
        sendButton.center.x = self.view.frame.width / 1.25
        sendButton.setTitleColor(.blue, for: .normal)
        sendButton.setTitleColor(.lightGray, for: .highlighted)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(SendButtonPressed), for: .touchUpInside)
        self.view.addSubview(sendButton)
        //Send button end
        
        //Read button start:
        let readButton = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 25))
        readButton.center.x = self.view.frame.width / 2
        readButton.setTitleColor(.blue, for: .normal)
        readButton.setTitleColor(.lightGray, for: .highlighted)
        readButton.setTitle("Read", for: .normal)
        readButton.addTarget(self, action: #selector(ReadButtonPressed), for: .touchUpInside)
        self.view.addSubview(readButton)
        //Read button end
        
        //Return text field start:
        returnTextField = UITextView(frame: CGRect(x: 100, y: 225, width: 300, height: 100))
        returnTextField.center.x = self.view.frame.width / 2
        returnTextField.backgroundColor = .gray
        returnTextField.textAlignment = NSTextAlignment.center
        self.view.addSubview(returnTextField)
        //Return text field 
        
        //Send button start:
        let nextButton = UIButton(frame: CGRect(x: 100, y: 325, width: 100, height: 25))
        nextButton.center.x = self.view.frame.width / 2
        nextButton.setTitleColor(.blue, for: .normal)
        nextButton.setTitleColor(.lightGray, for: .highlighted)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(NextButtonPressed), for: .touchUpInside)
        self.view.addSubview(nextButton)
        //Send button end
    }
}



