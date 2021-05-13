//
//  PreferenceVC.swift
//  TowerOfHanoiV2
//
//  Created by Kevin Tanuhardi on 25/04/21.
//

import Foundation
import UIKit

protocol StackViewDelegate {
    func increaseDiskStack(sender: PreferenceVC)
    func decreaseDiskStack(sender: PreferenceVC)
}


class PreferenceVC: UIViewController {
    
    var diskNumber = 1
    
    @IBOutlet weak var DiskCountLabel: UILabel!
    
    @IBOutlet weak var DownArrowButton: UIButton!
    @IBOutlet weak var UpArrowButton: UIButton!
    
    var delegate: StackViewDelegate?
    
    func setupUI () {
        //Update disk count label
        DiskCountLabel.text = String(diskNumber)
        
        //condition for down button
        if diskNumber == 1 {
            DownArrowButton.set(isEnabled: false)
        } else {
            DownArrowButton.set(isEnabled: true)
        }
        
        //condition for up button
        if diskNumber == 7 {
            UpArrowButton.set(isEnabled: false)
        } else {
            UpArrowButton.set(isEnabled: true)
        }
    }
    
    @IBAction func DownArrowButtonClicked(_ sender: PreferenceVC) {
        delegate?.decreaseDiskStack(sender: self)
        setupUI()
    }
    
    @IBAction func UpArrowButtonClicked(_ sender: PreferenceVC) {
        delegate?.increaseDiskStack(sender: self)
        setupUI()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
}

extension UIButton {
    func set (isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.alpha = isEnabled ? 1.0 : 0.5
    }
}
