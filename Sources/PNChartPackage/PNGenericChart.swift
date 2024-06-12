//
//  PNGenericChart.swift
//  PNChartSwift
//
//  Created by YiChen Zhou on 12/27/16.
//  Copyright © 2016 YiChen Zhou. All rights reserved.
//

import UIKit

public class PNGenericChart: UIView {
    var hasLegend: Bool!
    var legendPosition: PNLegendPosition!
    var legendStyle: PNLegendItemStyle!
    var legendFont: UIFont!
    var legendFontColor: UIColor!
    var labelRowsInSerialMode: Int!
    var displayAnimation: Bool = false
    
    public func setupDefaultValues() {
        hasLegend = true
        legendPosition = .Bottom
        legendStyle = .Stacked
        labelRowsInSerialMode = 1
        displayAnimation = true
    }
    
    public func getLegendWIthMaxWidth(maxWidth: Float) -> UIView! {
        //self.doesNotRecognizeSelector(_cmd)
        return nil
    }
    
    public func setLabelRowsInSerialMode(num: Int) {
        if legendStyle == .Serial {
            labelRowsInSerialMode = num
        } else {
            labelRowsInSerialMode = 1
        }
    }
}

extension PNGenericChart {
    public enum PNLegendPosition: Int {
        case Top = 0
        case Bottom = 1
        case Left = 2
        case Right = 3
    }
    
    public enum PNLegendItemStyle: Int {
        case Stacked = 0
        case Serial = 1
    }
}
