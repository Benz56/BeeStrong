//
//  ProcessViewController.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 02/11/2020.
//

import UIKit
import Charts
import TinyConstraints

class ProcessViewController: UIViewController, ChartViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let selectFromPickerView = ["Benchpress", "Squats"]
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemYellow
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        let xAxis = chartView.xAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        // yAxis.setLabelCount(2, force: false)
        yAxis.axisLineColor = .white
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
        xAxis.setLabelCount(5, force: false)
        xAxis.axisLineColor = .white
        
        return chartView
    }()
    
    @IBOutlet var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // Do any additional setup after loading the view.
        
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        benchpress()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func benchpress(){
        let set1 = LineChartDataSet(entries: benchPress, label: "Benchpress")
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.lineWidth = 2
        set1.setColor(.white)
        set1.fill = Fill(color: .white)
        set1.fillAlpha = 0.5
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
        data.setDrawValues(false)
        lineChartView.animate(xAxisDuration: 2.5)
    }
    
    func squats(){
        let set2 = LineChartDataSet(entries: squatsTraining, label: "Squats")
        set2.drawCirclesEnabled = false
        set2.mode = .cubicBezier
        set2.lineWidth = 2
        set2.setColor(.white)
        set2.fill = Fill(color: .white)
        set2.fillAlpha = 0.5
        set2.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set2)
        lineChartView.data = data
        data.setDrawValues(false)
        lineChartView.animate(xAxisDuration: 2.5)
    }
    
    let benchPress : [ChartDataEntry] = [
        ChartDataEntry(x: 3, y: 30),
        ChartDataEntry(x: 7, y: 32),
        ChartDataEntry(x: 11, y: 32),
        ChartDataEntry(x: 14, y: 34),
        ChartDataEntry(x: 22, y: 35),
        ChartDataEntry(x: 23, y: 35),
        ChartDataEntry(x: 26, y: 38),
        ChartDataEntry(x: 29, y: 40),
    ]
    
    let squatsTraining  : [ChartDataEntry] = [
        ChartDataEntry(x: 2, y: 44),
        ChartDataEntry(x: 5, y: 46),
        ChartDataEntry(x: 13, y: 46),
        ChartDataEntry(x: 17, y: 48),
        ChartDataEntry(x: 21, y: 51),
        ChartDataEntry(x: 24, y: 53),
        ChartDataEntry(x: 28, y: 53),
        ChartDataEntry(x: 31, y: 55),
    ]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectFromPickerView.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectFromPickerView[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            benchpress()
        } else {
            squats()
        }
    }
}



