//
//  PieChartViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#endif
import Charts

class PieChartViewController: DemoBaseViewController {

    @IBOutlet var chartView: ShadowPieChartView!
    @IBOutlet var sliderX: UISlider!
    @IBOutlet var sliderY: UISlider!
    @IBOutlet var sliderTextX: UITextField!
    @IBOutlet var sliderTextY: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        self.title = "Pie Chart"

        self.options = [.toggleValues,
                        .toggleXValues,
                        .togglePercent,
                        .toggleHole,
                        .toggleIcons,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .spin,
                        .drawCenter,
                        .saveToGallery,
                        .toggleData]

//        self.setup(pieChartView: chartView)

        chartView.delegate = self
        chartView.transparentCircleColor = .clear
        chartView.drawSlicesUnderHoleEnabled = false        


        // entry label styling
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)

        chartView.drawSlicesUnderHoleEnabled = false
        chartView.highlightPerTapEnabled = false

        chartView.shadowColor = UIColor.gray
        chartView.shadowOffset = CGSize(width: 3, height: 4)
        chartView.shadowBlur = 10

        sliderX.value = 4
        sliderY.value = 100
        self.slidersValueChanged(nil)

        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }

    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }

        self.setDataCount(Int(sliderX.value), range: UInt32(sliderY.value))
    }

    func setDataCount(_ count: Int, range: UInt32) {
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(arc4random_uniform(range) + range / 5),
                                     label: parties[i % parties.count],
                                     icon: #imageLiteral(resourceName: "icon"))
        }

        let set = PieChartDataSet(entries: entries)
        set.valueLineColor = .black
        set.valueLineWidth = 0


        //set.useValueColorForLine = true
        set.useValueColorForLine  = false
        set.drawIconsEnabled = false
        set.highlightEnabled = true
        set.sliceSpace = 0


        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]

        let data = PieChartData(dataSet: set)

        chartView.data = data
        chartView.highlightValues(nil)
    }

    override func optionTapped(_ option: Option) {
        switch option {
        case .toggleXValues:
            chartView.drawEntryLabelsEnabled = !chartView.drawEntryLabelsEnabled
            chartView.setNeedsDisplay()

        case .togglePercent:
            chartView.usePercentValuesEnabled = !chartView.usePercentValuesEnabled
            chartView.setNeedsDisplay()

        case .toggleHole:
            chartView.drawHoleEnabled = !chartView.drawHoleEnabled
            chartView.setNeedsDisplay()

        case .drawCenter:
            chartView.drawCenterTextEnabled = !chartView.drawCenterTextEnabled
            chartView.setNeedsDisplay()

        case .animateX:
            chartView.animate(xAxisDuration: 1.4)

        case .animateY:
            chartView.animate(yAxisDuration: 1.4)

        case .animateXY:
            chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)

        case .spin:
            chartView.spin(duration: 2,
                           fromAngle: chartView.rotationAngle,
                           toAngle: chartView.rotationAngle + 360,
                           easingOption: .easeInCubic)

        default:
            handleOption(option, forChartView: chartView)
        }
    }

    // MARK: - Actions
    @IBAction func slidersValueChanged(_ sender: Any?) {
        sliderTextX.text = "\(Int(sliderX.value))"
        sliderTextY.text = "\(Int(sliderY.value))"

        self.updateChartData()
    }
}
