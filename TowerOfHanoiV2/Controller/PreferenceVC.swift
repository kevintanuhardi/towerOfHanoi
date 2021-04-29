//
//  PreferenceVC.swift
//  TowerOfHanoiV2
//
//  Created by Kevin Tanuhardi on 25/04/21.
//

import Foundation
import UIKit


class PreferenceVC: UIViewController {
    
    @IBOutlet weak var MoveCountLabel: UILabel!
    
    @IBAction func DownArrowButtonClicked(_ sender: Any) {
        print(sender)
    }
    
    
    override func viewDidLoad() {
        print("loading")
        super.viewDidLoad()
    }
}
