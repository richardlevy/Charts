//
//  BarChartVerticalLabelRenderer.swift
//  ManualLapper
//
//  Created by Richard Levy on 11/09/2019.
//  Copyright © 2019 Richard Levy. All rights reserved.
//

import Foundation
import UIKit

open class BarChartVerticalLabelRenderer : BarChartRenderer {
    
    // this method should call super then add in labels for those indexes in the array
    // those indexes formater should print nothing
    
    open override func drawValues(context: CGContext) {
        super.drawValues(context: context)

        if isDrawingValuesAllowed(dataProvider: dataProvider) {
            
            guard
                let dataProvider = dataProvider,
                let barData = dataProvider.barData
                else { return }
            
            let dataSets = barData.dataSets

            for dataSetIndex in 0 ..< barData.dataSetCount {
                guard let dataSet = dataSets[dataSetIndex] as? BarChartDataSet else { continue }
                
                if !shouldDrawValues(forDataSet: dataSet) {
                    continue
                }
                
                if (dataProvider.isInverted(axis: dataSet.axisDependency)) {
                    print ("Inverted dataset not supported")
                    continue
                }
                
                // if only single values are drawn (sum)
                if dataSet.isStacked {
                    print ("Stacked dataset not supported")
                    continue
                }
                
                let buffer = _buffers[dataSetIndex]
                guard let formatter = dataSet.valueFormatter else { continue }

                for lap in 0 ..< Int(ceil(Double(dataSet.count) * animator.phaseX)) {
                    if dataSet.verticalLabelIndicies.contains(lap) {

                        guard let e = dataSet.entryForIndex(lap) as? BarChartDataEntry else { continue }

                        if !shouldDrawValues(forDataSet: dataSet) {
                            continue
                        }
                        
                        // calculate the correct offset depending on the draw position of the value
                        var valueFont = dataSet.valueFont
                        //
                        valueFont = UIFont(name: "BarlowCondensed-MediumItalic", size : 14)!
                        
                        let rect = buffer.rects[lap]
                        
                        // x,y,w,h
                        let x = rect.origin.x + rect.size.width / 2.0
                        let y = rect.origin.y + rect.size.height / 2.0
                        
                        let val = e.y
                        var strToDraw : String = formatter.stringForValue(val, entry: e, dataSetIndex: dataSetIndex, viewPortHandler:viewPortHandler)
                        
                        strToDraw = "Rest"
                        
                        if dataSet.isDrawValuesEnabled {
                            drawVerticalValue(
                                context: context,
                                value: strToDraw,
                                xPos: x,
                                yPos: y,
                                font: valueFont,
                                align: .left,
                                color: dataSet.valueTextColorAt(lap))
                        }
                    }
                }
            }
        }
    }
    
    open func drawVerticalValue(context: CGContext, value: String, xPos: CGFloat, yPos: CGFloat, font: NSUIFont, align: NSTextAlignment, color: NSUIColor)
    {
        drawVerticalText(context: context, text: value, point: CGPoint(x: xPos, y: yPos), align: align, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
    }
    
    open func drawVerticalText(context: CGContext, text: String, point: CGPoint, align: NSTextAlignment, attributes: [NSAttributedString.Key : Any]?)
    {
        var point = point
        
        if align == .center
        {
            point.x -= text.size(withAttributes: attributes).width / 2.0
        }
        else if align == .right
        {
            point.x -= text.size(withAttributes: attributes).width
        }
        
        //NSUIGraphicsPushContext(context)
        context.saveGState()
        
        let textSize = text.size(withAttributes: attributes)
 
        // Translate the origin to the drawing location and rotate the coordinate system.
        context.translateBy(x: point.x, y: point.y)
        context.rotate(by: 270 * .pi / 180)
        // Draw the text centered at the point.
        text.draw(at: CGPoint(x: -textSize.width / 2, y: -textSize.height / 2), withAttributes: attributes)
        
        // NSUIGraphicsPopContext()
        context.restoreGState()
        
    }
    
    
}
