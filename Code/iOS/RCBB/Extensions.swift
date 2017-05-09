//
//  Extensions.swift
//  RCBB
//
//  Created by Michal Szmaj on 02/04/2017.
//  Copyright © 2017 Michal Szmaj. All rights reserved.
//

import Foundation
import UIKit

//Allows the DebugViewController to receive status updates from the input/output streams
extension DebugViewController: ConnectionDelegate {
    func ConnectedStatus (message: String) {
        print(message)
    }
}

//Allows the ConnectViewController to receive status updates from the input/output streams
extension ConnectViewController: ConnectionDelegate {
    func ConnectedStatus (message: String) {
        SetStatusButtonText(with: message)
        if message == Constants.ConnectionStatus.connected {
            GoToUserDataView()
            SetStatusButtonText(with: Constants.ConnectionStatus.disconnect)
        }
    }
}

extension UINavigationController {
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {
            if let vc = visibleViewController {
                return vc.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            if let vc = visibleViewController {
                return vc.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }
    
    open override var shouldAutorotate: Bool {
        get {
            if let vc = visibleViewController {
                return vc.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
}
