//
//  ViewController.swift
//  TowerOfHanoiV2
//
//  Created by Kevin Tanuhardi on 20/04/21.
//

import UIKit


struct DiskPosition {
    var left = [Int]();
    var middle = [Int]();
    var right = [Int]();
    var leftArea = UIView();
    var rightArea = UIView();
    var middleArea = UIView();
}

var diskPositionDict = [
    "left": 0,
    "middle": 1,
    "right": 2
]
var diskPositionArr = Array(repeating: Array(repeating: 0, count: 0), count: 3);


class ViewController: UIViewController {
    
    @IBOutlet weak var LeftStickArea: UIView!
    @IBOutlet weak var MiddleStickArea: UIView!
    @IBOutlet weak var RightStickArea: UIView!
    
    var initialCenter = CGPoint();
    var diskPosition = DiskPosition();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupDiskNumber(number: 5)
        renderDisks()
    }
    
    func renderDisks() {

        let frameGlobalPosition = MiddleStickArea.superview?.convert(MiddleStickArea.frame, to: view);
        
        
        for (index, diskDatum) in diskPositionArr[0].enumerated() {
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
        
    }
    
    func createRectangle(
        x: Int,
        y: Int,
        color: UIColor,
        width: Int,
        height: Int
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
        
        func moveDisk( oldArea: String, newArea: String ,_ onCancel: () -> Void) {
            print(oldArea, newArea)
            var newAreaCenterX: CGFloat;
            var movingDiskNum = diskPositionArr[diskPositionDict[oldArea]!].last ?? 0;
            var topTargetDiskNum = diskPositionArr[diskPositionDict[newArea]!].last ?? 0;
            
            print(movingDiskNum, "moving")
            print(topTargetDiskNum, "new")
            
            if (movingDiskNum > topTargetDiskNum && topTargetDiskNum != 0) {
                onCancel()
                return print("done")
            }
            
            if newArea == "left" {
                newAreaCenterX = LeftStickArea.center.x
            } else if newArea == "middle" {
                newAreaCenterX = MiddleStickArea.center.x
            } else {
                newAreaCenterX = RightStickArea.center.x
            }
            
            let yCoordinate = CGFloat(middleAreaCoordinate!.maxY) - CGFloat(diskPositionArr[diskPositionDict[newArea]!].count * diskHeight)
            piece?.center = CGPoint(x: newAreaCenterX, y: yCoordinate - (0.5 * CGFloat(diskHeight)))
//            print(diskPositionArr[diskPositionDict[newArea]!], "new")
//            print(diskPositionArr[diskPositionDict[oldArea]!], "old")
            diskPositionArr[diskPositionDict[newArea]!].append(diskPositionArr[diskPositionDict[oldArea]!].popLast()!)
//            print(diskPositionArr[diskPositionDict[newArea]!], "new")
//            print(diskPositionArr[diskPositionDict[oldArea]!], "old")
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
        
        let setToInitialPosition = { () -> Void in
            piece?.center = self.initialCenter
        }
        
        let originArea:String = classifyArea(initialCenter);
        
        
        if recognizer.state != .cancelled{
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece?.center = newCenter
        } else {
            piece?.center = initialCenter
        }
        
        if(recognizer.state == .ended) {
            let targetArea = classifyArea(piece!.center);
            if targetArea != originArea {
                moveDisk(oldArea: originArea, newArea: targetArea, setToInitialPosition)
            } else {
                piece?.center = initialCenter;
            }
        }
    }
    
    func setupDiskNumber(number: Int) {
        for i in (1 ..< number + 1).reversed() {
            diskPositionArr[0].append(i)
        }
    }
}

