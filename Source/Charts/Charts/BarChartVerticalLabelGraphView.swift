//
//  BarChartVerticalLabelGraph.swift
//  ManualLapper
//
//  Created by Richard Levy on 11/09/2019.
//  Copyright © 2019 Richard Levy. All rights reserved.
//

import Foundation

open class BarChartVerticalLabelView : BarChartView {
        
    internal override func initialize()
    {
        super.initialize()
   
        renderer = BarChartVerticalLabelRenderer(dataProvider: self, animator: _animator, viewPortHandler: _viewPortHandler)
        
        self.highlighter = BarHighlighter(chart: self)
        
        self.xAxis.spaceMin = 0.5
        self.xAxis.spaceMax = 0.5
    }

}
