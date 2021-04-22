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

var stick1Arr = [Int]();
var stick2Arr = [Int]();
var stick3Arr = [Int]();


class ViewController: UIViewController {
    
    @IBOutlet weak var LeftStickArea: UIView!
    @IBOutlet weak var MiddleStickArea: UIView!
    @IBOutlet weak var RightStickArea: UIView!
    
    var initialCenter = CGPoint();
    var diskPosition = DiskPosition();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(diskPosition)
        
        setupDiskNumber(number: 5)
        renderDisks()
    }
    
    func renderDisks() {

        let frameGlobalPosition = MiddleStickArea.superview?.convert(MiddleStickArea.frame, to: view);
        
        
        for (index, diskDatum) in diskPosition.left.enumerated() {
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
        
        func moveDisk( oldArea: String, newArea: String) {
            print(oldArea, newArea)
            var newStickArr: [Int];
            var oldStickArr: [Int];
            var newAreaCenterX: CGFloat;
            var newAreaMaxY: CGFloat;
            var diskPositionPointer = UnsafePointer(&diskPosition)
            
            if newArea == "left" {
                newStickArr = diskPosition.left
                newAreaCenterX = LeftStickArea.center.x
                newAreaMaxY = leftAreaCoordinate!.maxY
            } else if newArea == "middle" {
                newStickArr = diskPosition.middle
                newAreaCenterX = MiddleStickArea.center.x
                newAreaMaxY = middleAreaCoordinate!.maxY
            } else {
                newStickArr = diskPosition.right
                newAreaCenterX = RightStickArea.center.x
                newAreaMaxY = rightAreaCoordinate!.maxY
            }
            
            if oldArea == "left" {
                oldStickArr = diskPosition.left
            } else if oldArea == "middle" {
                oldStickArr = diskPosition.middle
            } else {
                oldStickArr = diskPosition.right
            }
            
            
            
            let yCoordinate = CGFloat(middleAreaCoordinate!.maxY) - CGFloat(newStickArr.count * diskHeight)
            piece?.center = CGPoint(x: newAreaCenterX, y: yCoordinate - (0.5 * CGFloat(diskHeight)))
            print(newStickArr, "new")
            print(oldStickArr, "old")
            newStickArr.append(oldStickArr.popLast()!)
            print(newStickArr, "new")
            print(oldStickArr, "old")
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
        
        
        if recognizer.state != .cancelled{
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece?.center = newCenter
        } else {
            piece?.center = initialCenter
        }
        
        if(recognizer.state == .ended) {
            let targetArea = classifyArea(piece!.center);
            if targetArea != originArea {
                moveDisk(oldArea: originArea, newArea: targetArea)
//                if ((middleAreaCoordinate?.contains(piece!.center)) == true) {
//                    let yCoordinate = CGFloat(Int(middleAreaCoordinate!.maxY) - (stick2Arr.count * diskHeight))
//                    piece?.center = CGPoint(x: MiddleStickArea.center.x, y: yCoordinate - (0.5 * CGFloat(diskHeight)))
//                    stick2Arr.append(stick1Arr.popLast()!)
//                } else if (rightAreaCoordinate?.contains(piece!.center)) == true {
//                    let yCoordinate = CGFloat(Int(middleAreaCoordinate!.maxY) - (stick3Arr.count * diskHeight))
//                    piece?.center = CGPoint(x: RightStickArea.center.x, y: yCoordinate - (0.5 * CGFloat(diskHeight)))
//                    stick3Arr.append(stick1Arr.popLast()!)
//                } else {
//                    print("it was here")
//                    piece?.center = initialCenter
//                }
            } else {
                piece?.center = initialCenter;
            }
        }
    }
    
    func setupDiskNumber(number: Int) {
        for i in (1 ..< number + 1).reversed() {
            diskPosition.left.append(i)
        }
    }
}

