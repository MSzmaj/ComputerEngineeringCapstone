//
//  DataViewController.swift
//  RCBB
//
//  Created by Michal Szmaj on 2017-03-13.
//  Copyright © 2017 Michal Szmaj. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class DebugDataViewController: UIViewController {
    //Public DataViewController Declarations
    var data: RCBBData?
    
    //Private DataViewController Declarations
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
    
    //UIViewController Overrides
    override func viewDidLoad() {
        LoadMapView()
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {
            return .portrait
        }
    }
    
    //DataViewController Methods
    /**
     Sets up data labels
    */
    private func SetDataLabels () {
        let unpackedData = data!
        dateLabel?.text = "Timestamp: " + unpackedData.date
        xLabel?.text = "X: " + unpackedData.x
        yLabel?.text = "Y: " + unpackedData.y
        zLabel?.text = "Z: " + unpackedData.z
        temperatureLabel?.text = "Temperature: " + unpackedData.temperature
        
    }
    
    /**
     Loads map view with default values
    */
    private func LoadMapView () {
        let camera = GMSCameraPosition.camera(withLatitude: Double(38.1075), longitude: Double(-122.264), zoom: 15)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.title = "TEST"
        marker.snippet = "TEST"
        marker.map = mapView
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
    }
}
