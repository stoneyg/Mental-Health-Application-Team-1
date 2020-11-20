//
//  WeightsViewController.swift
//  Mental Health Application
//
//  Created by Jason with use of Charts Framework
//  Requires Charts.xcodeproj and Charts.framework to be in main project settings
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
//

import Charts
import UIKit

class WeightsViewController: UIViewController, ChartViewDelegate{

    struct weights{
        var Call: Double
        var Text: Double
        var FaceTime: Double
        init(call: Double, text: Double, facetime: Double){
            Call = call
            Text = text
            FaceTime = facetime
        }
    }
    ////Set weights to initial values, will change to what is inputted / outputted
    var weight = weights(call: 1, text: 0.5, facetime: 0.3)
    
    @IBOutlet weak var radarChart: RadarChartView!

    @IBOutlet weak var callValue: UILabel!
    @IBOutlet weak var textValue: UILabel!
    @IBOutlet weak var facetimeValue: UILabel!
    
    
    @IBAction func CallSlider(_ sender: UISlider) {
        let value = sender.value
        weight.Call = Double(value)
        callValue.text = String(value)
        setData(call: weight.Call, text: weight.Text, facetime: weight.FaceTime)
        radarChart.yAxis.axisMinimum = 0
        radarChart.yAxis.axisMaximum = 1
        radarChart.notifyDataSetChanged()
        radarChart.setNeedsDisplay()
    }
    
    @IBAction func TextSlider(_ sender: UISlider) {
        let value = sender.value
        weight.Text = Double(value)
        textValue.text = String(value)
        setData(call: weight.Call, text: weight.Text, facetime: weight.FaceTime)
        radarChart.yAxis.axisMinimum = 0
        radarChart.yAxis.axisMaximum = 1
        radarChart.notifyDataSetChanged()
        radarChart.setNeedsDisplay()
    }
    
    @IBAction func FaceTimeSlider(_ sender: UISlider) {
        let value = sender.value
        weight.FaceTime = Double(value)
        facetimeValue.text = String(value)
        setData(call: weight.Call, text: weight.Text, facetime: weight.FaceTime)
        radarChart.yAxis.axisMinimum = 0
        radarChart.yAxis.axisMaximum = 1
        radarChart.notifyDataSetChanged()
        radarChart.setNeedsDisplay()
    }
    
    @IBAction func DragEnd(_ send: UISlider){
        //Animate?
        radarChart.animate(/*xAxisDuration: 0.3, */yAxisDuration: 0.5, easingOption: .easeOutSine)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // X axis
        let xAxis = radarChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .bold)
        xAxis.labelTextColor = .black
        xAxis.xOffset = 2.5
        xAxis.yOffset = 2.5
        xAxis.valueFormatter = self
        //xAxis.valueFormatter = XAxisFormatter()

        // Y axis
        let yAxis = radarChart.yAxis
        //yAxis.drawLabelsEnabled = false
        yAxis.labelFont = .systemFont(ofSize:10, weight: .light)
        yAxis.labelCount = 4
        yAxis.forceLabelsEnabled = true
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.axisMinimum = 0
        //yAxis.axisMaximum = 1
        //yAxis.valueFormatter = YAxisFormatter()
        
        // Interactions
        radarChart.rotationEnabled = true
        radarChart.legend.enabled = false
        //Animate
        radarChart.animate(xAxisDuration: 2.4, yAxisDuration: 2.4, easingOption: .easeOutBack)
        radarChart.sizeToFit()
        
        //Formating, line colors
        radarChart.webLineWidth = 2
        radarChart.innerWebLineWidth = 1.5
        radarChart.webColor = .black
        radarChart.innerWebColor = .darkGray
        

        //Format radarChart/set
        radarChart.backgroundColor = .systemGray    //Background colorss
        setData(call: weight.Call, text: weight.Text, facetime: weight.FaceTime)
    }
        //Draggable adjust attempt
    private func chartValueSelected( chartView: RadarChartView, entry: RadarChartDataEntry, highlight: Highlight) {
        print("Test")
    }

    //Set Data based on weight struct
    func setData(call: Double, text: Double, facetime: Double){
     //let data = RadarChartData(dataSets: [greenDataSet, redDataSet])
        let redDataSet = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: call),
               RadarChartDataEntry(value: text),
               RadarChartDataEntry(value: facetime)
            ]
        )
        redDataSet.lineWidth = 2.5
        let redColor = UIColor(red: 250/255, green: 60/255, blue: 100/255, alpha: 1)
        let redFillColor = UIColor(red: 247/255, green: 67/255, blue: 115/255, alpha: 0.75)
        redDataSet.colors = [redColor]
        redDataSet.fillColor = redFillColor
        redDataSet.drawFilledEnabled = true
        redDataSet.drawHighlightCircleEnabled = true
        redDataSet.drawVerticalHighlightIndicatorEnabled = false
        redDataSet.drawHorizontalHighlightIndicatorEnabled = false

        //redDataSet.valueFormatter = madeupfunc()
        let data = RadarChartData(dataSet: redDataSet)
        radarChart.data = data
    }
    
}
    //Y axis Labels
extension WeightsViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let activities = ["Call", "Text", "FaceTime"]
        return activities[Int(value) % activities.count]
    }
}

