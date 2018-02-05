//
//  CryptoDetailViewController.swift
//  Tabele
//
//  Created by Matic on 01/02/2018.
//  Copyright © 2018 Matic. All rights reserved.
//

import UIKit
import Charts

struct HistoricalData: Codable
{
    let bpi: [String: Double]
    
    enum CodingKeys: String, CodingKey
    {
        case bpi = "bpi"
    }
}

class CryptoDetailViewController: UIViewController
{

    @IBOutlet weak var chtChart: LineChartView!
    @IBOutlet weak var coinNameBig: UILabel!
    
    var pricesArrayGlobal: [(String, Double)] = []
    var doubles = [Double]()
    
    let url = URL(string: "https://api.coindesk.com/v1/bpi/historical/close.json?index=[EUR]") // bitcoin historical data

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getHistoricalPriceFromApi()
        coinNameBig.text? = fullNames[myIndex]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //print(doubles.count)
        updateGraph()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateGraph()
    {
        chtChart.animate(xAxisDuration: 2.0)
        chtChart.backgroundColor = NSUIColor.black
        chtChart.leftAxis.labelTextColor = NSUIColor.white
        chtChart.legend.textColor = NSUIColor.white
        chtChart.rightAxis.labelTextColor = NSUIColor.white
        chtChart.rightAxis.enabled = false
        chtChart.xAxis.labelTextColor = NSUIColor.white
       
       // chtChart.setNeedsDisplay()
        
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<doubles.count
        {
            let value = ChartDataEntry(x: Double(i), y: doubles[i])
            lineChartEntry.append(value)
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Price")
        line1.axisDependency = .left
        line1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        line1.lineWidth = 1.5
        line1.drawCirclesEnabled = false
        line1.drawValuesEnabled = false
        line1.fillAlpha = 0.26
        line1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        line1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        line1.drawCircleHoleEnabled = false
        
        let data = LineChartData()
        data.addDataSet(line1)
    
        chtChart.drawGridBackgroundEnabled = false
        chtChart.xAxis.drawGridLinesEnabled = false
        chtChart.leftAxis.drawGridLinesEnabled = false
        chtChart.data = data
        chtChart.chartDescription?.text = "descriptionNNnn"
        
        for set in chtChart.data!.dataSets as! [LineChartDataSet] {
            set.drawFilledEnabled = !set.drawFilledEnabled
        }
    }
   
    func getHistoricalPriceFromApi()
    {
        if(myIndex == 0) {
        let url = URL(string: "https://api.coindesk.com/v1/bpi/historical/close.json?index=[EUR]") // bitcoin historical data
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                do {
                    
                    let jsonDecoder = JSONDecoder()
                    
                    let responseModel = try jsonDecoder.decode(HistoricalData.self, from: data!)
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    
                    let sortedArray = responseModel.bpi.map { ($0, $1) }
                        .sorted() { formatter.date(from: $0.0)!.compare(formatter.date(from: $1.0)!) == .orderedAscending }
                    
                    for index in sortedArray {
                        print(index.1)
                        self.doubles.append(index.1)
                    }
                    
                }
                    
                catch let err {
                    print("Err", err)
                }
                
            }
            task.resume()
        }
    }
    
}
