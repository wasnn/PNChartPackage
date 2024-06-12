//
//  PNBarChart.swift
//  PNChartSwift
//
//  Created by YiChen Zhou on 12/29/16.
//  Copyright © 2016 YiChen Zhou. All rights reserved.
//

import UIKit
public class PNBarChart: UIView {
    public var bars = NSMutableArray()
    public var xLabelWidth: CGFloat!
    public var yValueMax: CGFloat!
    public var strokeColor = PNGreen
    public var strokeColors: Array<Any>!
    public var xLabelHeight: CGFloat = 11
    public var yLabelHeight: CGFloat = 20
    public var labels: NSMutableArray = []
    public var xLabels = [String]() {
        didSet {
            if self.showLabel {
                self.xLabelWidth = (self.frame.size.width - self.chartMargin * 2.0 - yChartLabelWidth) / CGFloat(self.xLabels.count)
            }
        }
    }
    
    public var yLabels = [String]()
    public var yValues = [CGFloat]() {
        didSet {
            if self.yMaxValue != nil {
                self.yValueMax = self.yMaxValue
            } else {
                self.getYValueMax(yLabels: self.yValues)
            }
            self.xLabelWidth = (self.frame.size.width - self.chartMargin * 2 - yChartLabelWidth) / CGFloat(self.yValues.count)
        }
    }
    public var yChartLabelWidth: CGFloat = 18
    public var chartMargin: CGFloat = 15
    public var showLabel = true
    public var showChartBorder = false
    public var chartBottomLine = CAShapeLayer()
    public var chartLeftLine = CAShapeLayer()
    public var barRadius: CGFloat = 0
    public var barWidth: CGFloat!
    public var labelMarginTop: CGFloat = 0
    public var barBackgroundColor = PNLightGrey
    public var labelTextColor = UIColor.darkGray
    public var labelTextFont = UIFont(name: "Avenir-Medium", size: 11.0)
    public var xLabelSkip = 1
    public var yLabelSum = 4
    // Max value of the chart
    public var yMaxValue: CGFloat!
    // Min value of the chart
    public var yMinValue: CGFloat!
    public var animationType: AnimationType = .Default
    // Initialize Methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = PNLightGrey
        self.clipsToBounds = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func strokeChart() {
        self.viewCleanUpForCollection(arr: self.labels)
        
        if self.showLabel {
            // Add X Labels
            var labelAddCount = 0
            for index in 0..<self.xLabels.count {
                labelAddCount = labelAddCount + 1
                if labelAddCount == self.xLabelSkip {
                    let labeltext = self.xLabels[index]
                    let label = PNChartLabel(frame: CGRect.zero)
                    label.font = self.labelTextFont
                    label.textColor = self.labelTextColor
                    label.textAlignment = .center
                    label.text = labeltext
                    label.sizeToFit()
                    let labelXPosition = (CGFloat(index) * self.xLabelWidth + yChartLabelWidth + self.chartMargin + self.xLabelWidth / 2)
                    label.center = CGPoint(x: labelXPosition, y: self.frame.size.height - self.xLabelHeight - self.chartMargin + label.frame.size.height / 2.0 + self.labelMarginTop)
                    labelAddCount = 0
                    self.labels.add(label)
                    self.addSubview(label)
                }
            }
            
            // Add Y Labels
            let yLabelSectionHeight = (self.frame.size.height - self.chartMargin * 2 - self.xLabelHeight) / CGFloat(self.yLabelSum)
            for index in 0..<self.yLabelSum {
                let labelText = String(describing: Int(self.yValueMax * (CGFloat(self.yLabelSum - index) / CGFloat(self.yLabelSum))))
                let label = PNChartLabel(frame: CGRect(x: self.chartMargin / 2, y: yLabelSectionHeight * CGFloat(index) + self.chartMargin - self.yLabelHeight / 2.0, width: self.yChartLabelWidth, height: self.yLabelHeight))
                label.font = self.labelTextFont
                label.textColor = self.labelTextColor
                label.textAlignment = .right
                label.text = labelText
                self.labels.add(label)
                self.addSubview(label)
            }
        }
        
        self.viewCleanUpForCollection(arr: self.bars)
        
        // Add bars
        let chartCarvanHeight = self.frame.size.height - self.chartMargin * 2 - self.xLabelHeight
        var index = 0
        for value in self.yValues {
            let grade = value / self.yValueMax
            var barXPosition: CGFloat!
            if self.barWidth != nil && self.barWidth > 0 {
                barXPosition = CGFloat(index) * self.xLabelWidth + self.yChartLabelWidth + self.chartMargin + (self.xLabelWidth / 2) - (self.barWidth / 2)
            } else {
                barXPosition = CGFloat(index) * self.xLabelWidth + self.yChartLabelWidth + self.chartMargin + self.xLabelWidth * 0.25
                if self.showLabel {
                    self.barWidth = self.xLabelWidth * 0.5
                } else {
                    self.barWidth = self.xLabelWidth * 0.6
                }
            }
            
            let bar = PNBar(frame: CGRect(x: barXPosition, y: self.frame.size.height - chartCarvanHeight - self.xLabelHeight - self.chartMargin, width: self.barWidth, height: chartCarvanHeight))
            bar.barRadius = self.barRadius
            bar.backgroundColor = self.barBackgroundColor
            if self.strokeColor != UIColor.black {
                bar.barColor = self.strokeColor
            } else {
                bar.barColor = self.barColorAtIndex(index: index)
            }
            
            if self.animationType == .Waterfall {
                bar.startAnimationTime = Double(index) * 0.1
            }
            
            // Height of Bar
            bar.grade = grade
            // For Click Index
            bar.tag = index
            self.bars.add(bar)
            self.addSubview(bar)
            index += 1
        }
        
        // Add Chart Border Lines
        if self.showChartBorder {
            self.chartBottomLine = CAShapeLayer()
			self.chartBottomLine.lineCap = CAShapeLayerLineCap.butt
            self.chartBottomLine.fillColor = UIColor.white.cgColor
            self.chartBottomLine.lineWidth = 1
            self.chartBottomLine.strokeEnd = 0
            let progressLine = UIBezierPath()
            progressLine.move(to: CGPoint(x: self.chartMargin, y: self.frame.size.height - self.xLabelHeight - self.chartMargin))
            progressLine.addLine(to: CGPoint(x: self.frame.size.width - self.chartMargin, y: self.frame.size.height - self.xLabelHeight - self.chartMargin))
            progressLine.lineWidth = 1
            progressLine.lineCapStyle = .square
            self.chartBottomLine.path = progressLine.cgPath
            let path = CABasicAnimation(keyPath: "strokeEnd")
            path.duration = 0.5
			path.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            path.fromValue = 0
            path.toValue = 1
            self.chartBottomLine.add(path, forKey: "strokeEndAnimation")
            self.chartBottomLine.strokeEnd = 1
            self.layer.addSublayer(self.chartBottomLine)
            // Add Left Chart Line
            self.chartLeftLine = CAShapeLayer()
			self.chartLeftLine.lineCap = CAShapeLayerLineCap.butt
            self.chartLeftLine.fillColor = UIColor.white.cgColor
            self.chartLeftLine.lineWidth = 1
            self.chartLeftLine.strokeEnd = 0
            let progressLeftLine = UIBezierPath()
            progressLeftLine.move(to: CGPoint(x: self.chartMargin + self.yChartLabelWidth, y: self.frame.size.height - self.xLabelHeight - self.chartMargin))
            progressLeftLine.addLine(to: CGPoint(x: self.chartMargin + self.yChartLabelWidth, y: self.chartMargin))
            progressLeftLine.lineWidth = 1
            progressLeftLine.lineCapStyle = .square
            self.chartLeftLine.path = progressLeftLine.cgPath
            self.chartLeftLine.strokeColor = PNLightGrey.cgColor
            let pathLeft = CABasicAnimation(keyPath: "strokeEnd")
            pathLeft.duration = 0.5
			pathLeft.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            pathLeft.fromValue = 0
            pathLeft.toValue = 1
            self.chartLeftLine.add(pathLeft, forKey: "strokeEndAnimation")
            self.chartLeftLine.strokeEnd = 1
            self.layer.addSublayer(self.chartLeftLine)
        }
    }
    
}

extension PNBarChart {
    public enum AnimationType {
        case Default
        case Waterfall
    }
    
    public func getYValueMax(yLabels: [CGFloat]) {
        let max = yLabels.max()
        if max == 0 {
            self.yValueMax = self.yMinValue
        } else {
            self.yValueMax = max
        }
    }
    
    public func viewCleanUpForCollection(arr: NSMutableArray) {
        if arr.count > 0 {
            for object in arr {
                let view = object as! UIView
                view.removeFromSuperview()
            }
            arr.removeAllObjects()
        }
    }
    
    public func barColorAtIndex(index: Int) -> UIColor {
        if self.strokeColors.count == self.yValues.count {
            return self.strokeColors[index] as! UIColor
        } else {
            return self.strokeColor
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchPoint(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    
    public func touchPoint(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchPoint = touch?.location(in: self)
        let subview = hitTest(touchPoint!, with: nil)
        
        if let barView = subview as? PNBar {
            self.userClickedOnBarChartIndex(barIndex: barView.tag)
        }
    }
    
    public func userClickedOnBarChartIndex(barIndex: Int) {
        print("Click on bar \(barIndex)")
    }
}
