//
//  DailyBoxOfficeViewController.swift
//  MyDailyBoxOfficeExample
//
//  Created by bro on 2022/05/09.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON

class DailyBoxOfficeViewController: UIViewController {

    @IBOutlet weak var searchTextField: HoshiTextField!
    @IBOutlet weak var dailyBoxOfficeTableView: UITableView!
    
    var dailyBoxOfficeList : [Movie] = [] {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dailyBoxOfficeTableViewConfig()
    }
    
    func dailyBoxOfficeTableViewConfig() {
        let nibName = UINib(nibName: Constants.TabelViewCell.DailyBoxOfficeTableViewCell, bundle: nil)
        dailyBoxOfficeTableView.register(nibName, forCellReuseIdentifier: Constants.TabelViewCell.DailyBoxOfficeTableViewCell)
        
        dailyBoxOfficeTableView.delegate = self
        dailyBoxOfficeTableView.dataSource = self
        
        dailyBoxOfficeTableView.backgroundColor = .clear
        dailyBoxOfficeTableView.separatorStyle = .none
    }
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        
    }
    
    func fetchDailyBoxOffice() {
        
    }
    
}


extension DailyBoxOfficeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TabelViewCell.DailyBoxOfficeTableViewCell, for: indexPath) as! DailyBoxOfficeTableViewCell
        
        //cell.bindData(movie: dailyBoxOfficeList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
