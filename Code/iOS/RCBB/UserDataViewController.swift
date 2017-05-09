//
//  UserDataViewController.swift
//  RCBB
//
//  Created by Michal Szmaj on 2017-03-29.
//  Copyright © 2017 Michal Szmaj. All rights reserved.
//

import UIKit
import GoogleMaps

class UserDataViewController: UIViewController {
    //Public variables
    var socket: Socket!
    var timer: Timer?
    
    //Private variables
    private var latestCoordinates: [Double] = [1,1]
    private var getCommand: String = Constants.Command.latest
    private var mapZoom: Float = 18.0
    
    //Interface builder outlets
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var xLabel: UILabel?
    @IBOutlet weak var yLabel: UILabel?
    @IBOutlet weak var zLabel: UILabel?
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var pressureLabel: UILabel?
    @IBOutlet weak var altitudeLabel: UILabel?
    @IBOutlet weak var gpsQualityLabel: UILabel?
    @IBOutlet weak var latitudeLabel: UILabel?
    @IBOutlet weak var longitudeLabel: UILabel?
    @IBOutlet weak var satellitesLabel: UILabel?
    @IBOutlet weak var speedLabel: UILabel?
    
    //Interface builder actions
    /**
     Opens the log view with the correct data.
     Stops timer and waits 1 second to collect all the incoming data.
     If no data available, present user with dialog.
    */
    @IBAction func GoToLogView (with sender: UIBarButtonItem) {
        StopTimer()
        socket.WriteBytes(data: sender.tag == 0 ? Constants.Command.all : Constants.Command.today)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            if (self.socket.connected && self.socket.socketError == nil) {
                var data = self.GetData()
                if data.count > 0 {
                    data.remove(at: 0) //Removes duplicate from previous response
                    if data.count < 1 {
                        let alert = UIAlertController(title: "No Data", message: "Sorry, there is no data available to display", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let logTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogView") as! LogTableViewController
                        logTableViewController.data = data
                        self.navigationController?.pushViewController(logTableViewController, animated: true)
                    }
                }
            }
        })
    }
    
    /**
     Clears all the data from the RCBB device
     */
    @IBAction func ClearData (with sender: UIBarButtonItem) {
        StopTimer()
        socket.WriteBytes(data: Constants.Command.clearData)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            let alert = UIAlertController(title: "Data cleared", message: "Data clearing finished", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.StartTimer()
        })
    }
    
    /**
     Changes the zoom on the mapview
    */
    @IBAction func ChangeZoom(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapZoom = 20.0
            break
        case 1:
            mapZoom = 18.0
            break
        case 2:
            mapZoom = 15.0
        default:
            break
        }
    }
    
    /**
     Switches to and from demo mode. This only presents demo GPS data, all other data is live.
    */
    @IBAction func SwitchDemo (with sender: UIBarButtonItem) {
        StopTimer()
        getCommand = getCommand == Constants.Command.latest ? Constants.Command.demo : Constants.Command.latest
        sender.title = getCommand == Constants.Command.latest ? "Demo" : "Live"
        StartTimer()
    }
    
    //UIViewController Overrides
    override func viewDidLoad() {
        SetUpBackButton()
        StartTimer()
        LoadMapView()
        super.viewDidLoad()
    }
    
    /**
     Sets up custom back button in order to stop timer when going back to connect screen.
    */
    private func SetUpBackButton () {
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(UserDataViewController.Back))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    /**
     Back button press callback. Stops timer and navigates back to connect view.
    */
    internal func Back () {
        StopTimer()
        _ = navigationController?.popViewController(animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        StartTimer()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        super.viewDidAppear(animated)
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
        return true
    }
    
    /**
     Default orientation is Portrait
     */
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {
            return .portrait
        }
    }
    
    /**
     Loads the map view with default coordinates
     */
    private func LoadMapView () {
        let camera = GMSCameraPosition.camera(withLatitude: -33.8683, longitude: 151.2086, zoom: 14)
        mapView.camera = camera
    }
    
    /**
     Starts the scheduled timer at a 100 millisecond interval. Calls ReceiveData()
     */
    private func StartTimer () {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: Constants.Connection.pollRate, target: self, selector: #selector(ReceiveData), userInfo: nil, repeats: true)
        }
    }
    
    /**
     Stops the timer, and assigns it to nil
     */
    private func StopTimer () {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    /**
     Receives data from the socket if it is connected and there are no errors.
     Sends 'L' in order to retrieve the latest data
     */
    internal func ReceiveData () {
        if (socket.connected && socket.socketError == nil) {
            socket.WriteBytes(data: getCommand)
            let data = GetData()
            SetData(with: data)
        }
        if !socket.connected || socket.socketError != nil {
            let alert = UIAlertController(title: "Disconnected", message: "Sorry, it seems that the connection to the RCBB device has been lost", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            StopTimer()
        }
    }
    
    /**
     Reads the bytes sent from the server and parses them accordingly.
     @return RCBBData list filled with data from server
     */
    private func GetData () -> [RCBBData] {
        let data = socket.ReadBytes().components(separatedBy: ";")
        var parseData: [RCBBData] = []
        for datum in data {
            let parsedString = JSONParser.Decode(data: datum)
            if parsedString != nil {
                parseData.append(parsedString!)
            }
        }
        return parseData
    }
    
    /**
     Sets the labels according to the data given
     */
    private func SetData (with data: [RCBBData]) {
        if data.count == 1 {
            let datum = data[0]
            dateLabel?.text = datum.date
            xLabel?.text = "X: " + datum.x
            yLabel?.text = "Y: " + datum.y
            zLabel?.text = "Z: " + datum.z
            temperatureLabel?.text = "Temp: " + datum.temperature + "°C"
            pressureLabel?.text = "Pressure: " + datum.pressure + "kPa"
            if datum.quality == "" || datum.satellites == "" || datum.quality == "0" || datum.satellites == "0" || datum.quality == "None" || datum.satellites == "None" {
                altitudeLabel?.text = "Weak or no GPS signal."
                gpsQualityLabel?.text = " "
                latitudeLabel?.text = "Unable to determine location"
                longitudeLabel?.text = " "
                satellitesLabel?.text = " "
                speedLabel?.text = " "
            } else {
                altitudeLabel?.text = "Alt: " + datum.altitude + "m"
                gpsQualityLabel?.text = "Quality: " + datum.quality
                latitudeLabel?.text = datum.latitude + datum.latitudeDirection
                longitudeLabel?.text = datum.longitude + datum.longitudeDirection
                satellitesLabel?.text = "Satellites: " + datum.satellites
                speedLabel?.text = "Speed: " + ConvertSpeed(speed: datum.speed)
                UpdateMapView(with: datum)
            }
        }
    }
    
    /**
     Converts knots (from GPS) into km/h
    */
    private func ConvertSpeed (speed: String) -> String {
        if speed == "None" || speed == "" { return "Unavailable" }
        let speed = Double(speed)! * 1.852
        return String(speed) + "km/h"
    }
    
    /**
     Updates the map view with the latest coordinates.
     Only updates if the difference between last coordinates and new coordinates
     is significant (this is to prevent high CPU usage)
     */
    private func UpdateMapView (with datum: RCBBData) {
        if let coordinates = ConvertCoordinates(latitude: datum.latitude, latDir: datum.latitudeDirection, longitude: datum.longitude, longDir: datum.longitudeDirection) {
            if IsBeyond(coordinates, and: latestCoordinates)  {
                latestCoordinates = coordinates
                mapView.clear()
                let camera = GMSCameraPosition.camera(withLatitude: coordinates[0], longitude: coordinates[1], zoom: mapZoom)
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1]))
                marker.map = mapView
                mapView.camera = camera
            }
        }
    }
    
    /**
     Returns true if the given coordinates are significantly different
     */
    private func IsBeyond (_ next: [Double], and values: [Double]) -> Bool {
        if next[0] - values[0] > Constants.Distance.maximumDifference { return true}
        if values[0] - next[0] > Constants.Distance.maximumDifference { return true}
        if next[1] - values[1] > Constants.Distance.maximumDifference { return true}
        if values[1] - next[1] > Constants.Distance.maximumDifference { return true}
        return false
    }
    
    /**
     Given latitude, longitude, and their respective directions, returns the values represented as positive/negative numbers
     instead of directional letters. This is used for the Google Maps API.
     */
    private func ConvertCoordinates (latitude: String, latDir: String, longitude: String, longDir: String) -> [Double]? {
        if latitude == "" || longitude == "" || latitude == "None" || longitude == "None" { return nil }
        let latitude = latDir == "N" ? Double(latitude)! : Double(latitude)! * -1
        let longitude = longDir == "E" ? Double(longitude)! : Double(longitude)! * -1
        return [latitude/100, longitude/100]
    }
}
