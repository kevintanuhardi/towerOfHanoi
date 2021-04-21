//
//  ViewController.swift
//  TowerOfHanoiV2
//
//  Created by Kevin Tanuhardi on 20/04/21.
//

import UIKit

var stick1Arr = [Int]();
var stick2Arr = [Int]();
var stick3Arr = [Int]();

class ViewController: UIViewController {
    
    @IBOutlet weak var LeftStickArea: UIView!
    @IBOutlet weak var MiddleStickArea: UIView!
    @IBOutlet weak var RightStickArea: UIView!
    
    var initialCenter = CGPoint();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDiskNumber(number: 5)
        renderDisks()
    }
    
    func renderDisks() {
        
        print(stick1Arr)
        print(LeftStickArea.superview?.convert(LeftStickArea.frame, to: nil))
        print(LeftStickArea.superview!.frame.minY)
        print(LeftStickArea.center)
        print(LeftStickArea.frame)
        print(MiddleStickArea.center)
        print(MiddleStickArea.frame)
        
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        print(rootView)
        print(MiddleStickArea.superview?.convert(MiddleStickArea.frame, to: view))
        
        for (index, diskDatum) in stick1Arr.enumerated() {
            let diskWidth = diskWidths[diskDatum - 1];
            let diskColor = diskColors[diskDatum - 1];
            createRectangle(
                y: 391 + 143 - ((index + 1) * diskHeight),
                color: diskColor,
                width: diskWidth,
                height: diskHeight
            )
        }
    }
    
    func createRectangle(
        y: Int,
        color: UIColor,
        width: Int,
        height: Int
//        targetView: UIView
    ) {
        let viewObject = UIView();
        viewObject.frame = CGRect(x: 69 - (width / 2), y: y, width: width, height: height);
        viewObject.backgroundColor = color;

        view.addSubview(viewObject)
                
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:)))
        viewObject.addGestureRecognizer(panGesture)

        viewObject.isUserInteractionEnabled = true
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer){
        guard recognizer.view != nil else {return}
        let piece = recognizer.view
        let translation = recognizer.translation(in: piece?.superview)
        
        if recognizer.state == .began{
            initialCenter = piece!.center
        }
        
        if recognizer.state != .cancelled{
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece?.center = newCenter
        } else {
            piece?.center = initialCenter
        }
        
        if(recognizer.state == .ended) {
            piece?.center = initialCenter
        }
    }
    
    func setupDiskNumber(number: Int) {
        for i in (1 ..< number + 1).reversed() {
            stick1Arr.append(i)
        }
    }
}

