//
//  ViewController.swift
//  TowerOfHanoiV2
//
//  Created by Kevin Tanuhardi on 20/04/21.
//

import UIKit

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

    @IBOutlet weak var MoveCountLabel: UILabel!
    
    var diskViewArr = [UIView]()
    
    var initialCenter = CGPoint();
    var diskNumber = 3;
    var moveCount = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupDiskNumber(number: diskNumber)
        DispatchQueue.main.async {
            self.renderDisks()
        }
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
    
    func cleanUpDisks() {
        for (index, diskView) in diskViewArr.enumerated() {
            diskView.removeFromSuperview()
            diskPositionArr = Array(repeating: Array(repeating: 0, count: 0), count: 3);
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
        
        diskViewArr.append(viewObject)
                
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
            var newAreaCenterX: CGFloat;
            let movingDiskNum = diskPositionArr[diskPositionDict[oldArea]!].last ?? 0;
            let topTargetDiskNum = diskPositionArr[diskPositionDict[newArea]!].last ?? 0;
            
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
            diskPositionArr[diskPositionDict[newArea]!].append(diskPositionArr[diskPositionDict[oldArea]!].popLast()!)
            moveCount += 1
            MoveCountLabel.text = String(moveCount);
        }
        
        
        guard recognizer.view != nil else {return}
        let piece = recognizer.view
        let translation = recognizer.translation(in: piece?.superview)
        
        let leftAreaCoordinate = LeftStickArea.superview?.convert(LeftStickArea.frame, to: view)
        let middleAreaCoordinate = MiddleStickArea.superview?.convert(MiddleStickArea.frame, to: view)
        
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
        diskPositionArr = Array(repeating: Array(repeating: 0, count: 0), count: 3);
        for i in (1 ..< number + 1).reversed() {
            diskPositionArr[0].append(i)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! PreferenceVC
        dest.diskNumber = self.diskNumber
        dest.delegate = self
        return
    }
}

extension ViewController: StackViewDelegate {
    
    private func resetStack() {
        cleanUpDisks()
        setupDiskNumber(number: self.diskNumber)
        renderDisks()
        moveCount = 0
        MoveCountLabel.text = String(moveCount);
    }
    
    func increaseDiskStack(sender: PreferenceVC) {
        self.diskNumber += 1
        
        resetStack()
        sender.diskNumber = self.diskNumber
    }
    
    func decreaseDiskStack(sender: PreferenceVC) {
        
        self.diskNumber -= 1
        
        resetStack()
        sender.diskNumber = self.diskNumber
    }
    
    func restartGame(sender: PreferenceVC) {
        resetStack()
    }
}
