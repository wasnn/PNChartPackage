//
//  PNBar.swift
//  PNChartSwift
//
//  Created by YiChen Zhou on 12/29/16.
//  Copyright © 2016 YiChen Zhou. All rights reserved.
//

import UIKit

public class PNBar: UIView {

    // Time brfore bar starts to animate
    public var startAnimationTime: Double = 0
    public var chartLine: CAShapeLayer = {
        return CAShapeLayer()
        
    }()
    
    public var barColor = PNFreshGreen
    public var barRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = self.barRadius
        }
    }
    
    public var grade: CGFloat = 0 {
        didSet {
            UIGraphicsBeginImageContext(self.frame.size)
            let path = CABasicAnimation(keyPath: "strokeEnd")
            path.duration = 1
			path.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            path.fromValue = 0
            path.toValue = 1
            self.chartLine.add(path, forKey: "strokeEndAnimation")
            self.chartLine.strokeEnd = 1
            self.delay(delay: self.startAnimationTime, closure: {
                () -> () in
                self.chartLine.add(path, forKey: "strokeEndAnimation")
                let progressLine = UIBezierPath()
                progressLine.move(to: CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height))
                progressLine.addLine(to: CGPoint(x: self.frame.size.width / 2.0, y: (1 - self.grade) * self.frame.size.height))
                progressLine.lineCapStyle = .square
                self.chartLine.path = progressLine.cgPath
                self.chartLine.strokeColor = self.barColor.cgColor
            })
            UIGraphicsEndImageContext()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.chartLine = CAShapeLayer()
		self.chartLine.lineCap = CAShapeLayerLineCap.butt
        self.chartLine.fillColor = UIColor.white.cgColor
        self.chartLine.lineWidth = self.frame.size.width
        self.chartLine.strokeEnd = 0
        self.clipsToBounds = true
        self.backgroundColor = PNLightGrey
        self.layer.addSublayer(self.chartLine)
        self.barRadius = 10
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        // Draw BackGround
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor((self.backgroundColor?.cgColor)!)
        context.addRect(rect)
    }
    
    public func delay(delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            () -> () in
            closure()
        }
    }
    
    public func rollBack() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: ({
            self.chartLine.strokeColor = UIColor.clear.cgColor
        }), completion: nil)
    }
}
