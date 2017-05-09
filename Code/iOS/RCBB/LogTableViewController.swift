//
//  LogTableViewController.swift
//  RCBB
//
//  Created by Michal Szmaj on 07/04/2017.
//  Copyright © 2017 Michal Szmaj. All rights reserved.
//

import UIKit

class LogTableViewController: UITableViewController {
    //Public variables
    var data: [RCBBData]?
    
    //UITableViewController overrides
    /**
     Loads the view and sets the current orientation to landscape left.
    */
    override func viewDidLoad() {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /**
     Override for number of sections set to 1
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /**
     Override for table cell count set to the data count
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data?.count)!
    }

    /**
     Creates a new cell for each datum available. Sets the labels appropriately
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let datum = (data?[indexPath.row])!
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogTableViewCell", for: indexPath) as! LogTableViewCell
        cell.timeStampLabel.text = datum.date.substring(from: datum.date.index(datum.date.endIndex, offsetBy: -12))
        cell.xLabel.text = datum.x
        cell.yLabel.text = datum.y
        cell.zLabel.text = datum.z
        cell.temperatureLabel.text = datum.temperature
        cell.pressureLabel.text = datum.pressure
        cell.altitudeLabel.text = datum.altitude
        cell.latitudeLabel.text = datum.latitude
        cell.longitudeLabel.text = datum.longitude
        cell.qualityLabel.text = datum.quality
        cell.satellitesLabel.text = datum.satellites
        return cell
    }
}
