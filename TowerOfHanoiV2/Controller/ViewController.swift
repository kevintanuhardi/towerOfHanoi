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
var diskPosition = Array(repeating: Array(repeating: 0, count: 0), count: 3)

class ViewController: UIViewController {
    
    @IBOutlet weak var LeftStickArea: UIView!
    @IBOutlet weak var MiddleStickArea: UIView!
    @IBOutlet weak var RightStickArea: UIView!
    
    var initialCenter = CGPoint();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(diskPosition)
        
        setupDiskNumber(number: 5)
        renderDisks()
    }
    
    func renderDisks() {
        

        
        let frameGlobalPosition = MiddleStickArea.superview?.convert(MiddleStickArea.frame, to: view);
        print(stick1Arr)
        
        for (index, diskDatum) in stick1Arr.enumerated() {
            print(diskDatum)
            let diskWidth = diskWidths[diskDatum - 1];
            let diskColor = diskColors[diskDatum - 1];
            createRectangle(
                x: Int(LeftStickArea.center.x),
                y: Int(frameGlobalPosition!.maxY) - ((index + 1) * diskHeight),
                color: diskColor,
                width: diskWidth,
                height: diskHeight
            )
        }
        
        for (index, diskDatum) in stick2Arr.enumerated() {
            let diskWidth = diskWidths[diskDatum - 1];
            let diskColor = diskColors[diskDatum - 1];
            createRectangle(
                x: Int(MiddleStickArea.center.x),
                y: Int(frameGlobalPosition!.maxY) - ((index + 1) * diskHeight),
                color: diskColor,
                width: diskWidth,
                height: diskHeight
            )
        }
        
        for (index, diskDatum) in stick3Arr.enumerated() {
            let diskWidth = diskWidths[diskDatum - 1];
            let diskColor = diskColors[diskDatum - 1];
            createRectangle(
                x: Int(RightStickArea.center.x),
                y: Int(frameGlobalPosition!.maxY) - ((index + 1) * diskHeight),
                color: diskColor,
                width: diskWidth,
                height: diskHeight
            )
        }
    }
    
    func createRectangle(
        x: Int,
        y: Int,
        color: UIColor,
        width: Int,
        height: Int
//        targetView: UIView
    ) {
        let viewObject = UIView();
        viewObject.frame = CGRect(x: 0, y: y, width: width, height: height);
        let currentY = viewObject.center.y;
        viewObject.center = CGPoint(x: x, y: Int(currentY))
        viewObject.backgroundColor = color;

        view.addSubview(viewObject)
                
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:)))
        viewObject.addGestureRecognizer(panGesture)

        viewObject.isUserInteractionEnabled = true
    }
    
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer){
        func classifyArea(_ currentCoordinate: CGPoint) -> String {
            if leftAreaCoordinate?.contains(currentCoordinate) == true {
                return "left"
            } else if middleAreaCoordinate?.contains(currentCoordinate) == true {
                return "middle"
            } else {
                return "right"
            }
        }
        
        guard recognizer.view != nil else {return}
        let piece = recognizer.view
        let translation = recognizer.translation(in: piece?.superview)
        
        let leftAreaCoordinate = LeftStickArea.superview?.convert(LeftStickArea.frame, to: view)
        let middleAreaCoordinate = MiddleStickArea.superview?.convert(MiddleStickArea.frame, to: view)
        let rightAreaCoordinate = RightStickArea.superview?.convert(RightStickArea.frame, to: view)
        
        if recognizer.state == .began{
            initialCenter = piece!.center
        }
        
        let originArea:String = classifyArea(initialCenter);
        
        print(originArea)
        
        if recognizer.state != .cancelled{
            print("not canceled")
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece?.center = newCenter
        } else {
            print("canceled")
            piece?.center = initialCenter
        }
        
        if(recognizer.state == .ended) {
            let middleAreaCoordinate = MiddleStickArea.superview?.convert(MiddleStickArea.frame, to: view)
            let rightAreaCoordinate = RightStickArea.superview?.convert(RightStickArea.frame, to: view)
            if ((middleAreaCoordinate?.contains(piece!.center)) == true) {
                let yCoordinate = CGFloat(Int(middleAreaCoordinate!.maxY) - (stick2Arr.count * diskHeight))
                piece?.center = CGPoint(x: MiddleStickArea.center.x, y: yCoordinate - (0.5 * CGFloat(diskHeight)))
                stick2Arr.append(stick1Arr.popLast()!)
            } else if (rightAreaCoordinate?.contains(piece!.center)) == true {
                let yCoordinate = CGFloat(Int(middleAreaCoordinate!.maxY) - (stick3Arr.count * diskHeight))
                piece?.center = CGPoint(x: RightStickArea.center.x, y: yCoordinate - (0.5 * CGFloat(diskHeight)))
                stick3Arr.append(stick1Arr.popLast()!)
            } else {
                print("it was here")
                piece?.center = initialCenter
            }
        }
    }
    
    func setupDiskNumber(number: Int) {
        for i in (1 ..< number + 1).reversed() {
            stick1Arr.append(i)
        }
    }
}

