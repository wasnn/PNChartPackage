//
//  PNPieChartDataItem.swift
//  PNChartSwift
//
//  Created by YiChen Zhou on 12/27/16.
//  Copyright © 2016 YiChen Zhou. All rights reserved.
//

import UIKit

public class PNPieChartDataItem: NSObject {
    public var color: UIColor?
    public var text: String?
    public var value: CGFloat?
    
    public init(dateColor color: UIColor, description text: String) {
        self.color = color
        self.text = text
    }
    
    public init(dateValue value: CGFloat, dateColor color: UIColor, description text: String) {
        self.value = value
        self.color = color
        self.text = text
    }
    
    public func setValue(newValue: CGFloat) {
        guard newValue > 0 else {
            print("Value should >= 0")
            return
        }
        self.value = (self.value != newValue) ? newValue : value
    }
}
