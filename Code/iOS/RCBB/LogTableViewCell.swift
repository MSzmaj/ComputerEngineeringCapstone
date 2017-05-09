//
//  LogTableViewCell.swift
//  RCBB
//
//  Created by Michal Szmaj on 07/04/2017.
//  Copyright © 2017 Michal Szmaj. All rights reserved.
//

import UIKit

//Defines the values for a LogTableViewCell, for use in LogTableViewController
class LogTableViewCell: UITableViewCell {
    //Interface builder outlets
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var satellitesLabel: UILabel!
    
    //UITableViewCell overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
