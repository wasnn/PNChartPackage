//
//  PNChartLabel.swift
//  PNChartSwift
//
//  Created by YiChen Zhou on 11/11/16.
//  Copyright © 2016 YiChen Zhou. All rights reserved.
//

import UIKit

public class PNChartLabel: UILabel {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.boldSystemFont(ofSize: 10.0)
        self.textColor = PNGrey
        self.backgroundColor = UIColor.clear
        self.textAlignment = NSTextAlignment.center
        self.isUserInteractionEnabled = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: NSCode) has not been implemented.")
    }

}
