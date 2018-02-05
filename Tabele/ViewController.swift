//
//  ViewController.swift
//  Tabele
//
//  Created by Matic on 21/01/2018.
//  Copyright © 2018 Matic. All rights reserved.

import UIKit
import Foundation
import DGElasticPullToRefresh

struct cryptoJsonStruct: Codable
{
    let btc: toEurStruct
    let eth: toEurStruct
    let bcn: toEurStruct
    let dash: toEurStruct
    let doge: toEurStruct
    let xmr: toEurStruct
    let xrp: toEurStruct
    
    enum CodingKeys: String, CodingKey
    {
        case btc = "BTC"
        case eth = "ETH"
        case bcn = "BCN"
        case dash = "DASH"
        case doge = "DOGE"
        case xmr = "XMR"
        case xrp = "XRP"
    }
}

struct toEurStruct: Codable
{
    let eur: Double
    
    enum CodingKeys: String, CodingKey
    {
        case eur = "EUR"
    }
}

var fullNames = ["Bitcoin", "Ethereum", "Bytecoin", "Dashcoin", "Dogecoin", "Monero", "Ripple"]
var myIndex = 0

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // edit rows button action
    @IBAction func editRowsBtn(_ sender: Any)
    {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    
    //required arrays to work with data - MUST be the same as the name of the images in Assets.xcassets folder to work properly.
    var currency = ["BTC", "ETH", "BCN", "DASH", "DOGE", "XMR", "XRP"]
    var currencyFullName = ["Bitcoin", "Ethereum", "Bytecoin", "Dashcoin", "Dogecoin", "Monero", "Ripple"]
    var currencyStringArray = [String]()    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //increase the tableView height to get a little more space in a cell to work with.
        tableView.rowHeight = 85
        tableView.estimatedRowHeight = 85
        tableView.backgroundColor = UIColor.black
        fetchData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // returns the number of rows (INT) in UITableView by counting the number of elements in currencyStringArray.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currencyStringArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // "as!" extends the cell with the class "CryptoTableViewCell.swift" so we can set other properties in the cell, like label text and UIImage in this case.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CryptoTableViewCell
        let cryptoName = currency[indexPath.row]
        cell.cryptoImageView?.image = UIImage(named: cryptoName)
        cell.shortNameLabel.text = currency[indexPath.row]
        cell.fullNameLabel.text = currencyFullName[indexPath.row]
        cell.priceLabel.text = currencyStringArray[indexPath.row]
        print(currencyStringArray.count)
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    // func that allows us to change - edit the order of rows in UITableView
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let item1 = currency[sourceIndexPath.row]
        let item2 = currencyFullName[sourceIndexPath.row]
        let item3 = currencyStringArray[sourceIndexPath.row]
        currencyStringArray.remove(at: sourceIndexPath.row)
        currencyStringArray.insert(item3, at: destinationIndexPath.row)
        currencyFullName.remove(at: sourceIndexPath.row)
        currencyFullName.insert(item2, at: destinationIndexPath.row)
        currency.remove(at: sourceIndexPath.row)
        currency.insert(item1, at: destinationIndexPath.row)
    }
    
    // func that handles the click on a specific cell.
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        myIndex = indexPath.row
        performSegue(withIdentifier: "toDetailView", sender: self)
        
    }
    
    override func loadView()
    {
        super.loadView()
        
        //refresh animation - DGElasticPullToRefresh
        //CREDITS FOR ANIMATION: https://github.com/gontovnik/DGElasticPullToRefresh
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            //.removeAll() method to empty the data from currencyStringArray before fetching a new one, to avoid IndexOutOfRange error when scrolling the UITableView.
            self?.currencyStringArray.removeAll()
            self?.fetchData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self?.tableView.dg_stopLoading()
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    deinit
    {
        tableView.dg_removePullToRefresh()
    }
    
    // core function of the app - fetches the JSON data from URL
    func fetchData()
    {
        // define the data url
        let url = URL(string: "https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH,BCN,DASH,DOGE,XMR,XRP&tsyms=EUR")
        
        // create new data task with previously defined url
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                
                let jsonDecoder = JSONDecoder()
                // decodes JSON response into the cryptoJsonStruct
                let responseModel = try jsonDecoder.decode(cryptoJsonStruct.self, from: data!)
                // converts json response data (currency value - DOUBLE data type) to strings
                let btcString = String(responseModel.btc.eur)
                let ethString = String(responseModel.eth.eur)
                let bcnString = String(responseModel.bcn.eur)
                let dashString = String(responseModel.dash.eur)
                let dogeString = String(responseModel.doge.eur)
                let xmrString = String(responseModel.xmr.eur)
                let xrpString = String(responseModel.xrp.eur)
                
                // append each and every currency to a string array so later can be presented in Labels, etc.
                self.currencyStringArray.append(btcString)
                self.currencyStringArray.append(ethString)
                self.currencyStringArray.append(bcnString)
                self.currencyStringArray.append(dashString)
                self.currencyStringArray.append(dogeString)
                self.currencyStringArray.append(xmrString)
                self.currencyStringArray.append(xrpString)
            }
                
            catch let err {
                print("Err", err)
            }
      
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
}
