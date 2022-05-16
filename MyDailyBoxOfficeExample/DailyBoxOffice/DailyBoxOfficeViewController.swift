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
import RealmSwift

class DailyBoxOfficeViewController: UIViewController {

    @IBOutlet weak var searchTextField: HoshiTextField!
    @IBOutlet weak var dailyBoxOfficeTableView: UITableView!
    
//    var dailyBoxOfficeList : [Movie] = [] {
//        didSet {
//            dailyBoxOfficeTableView.reloadData()
//        }
//    }
    
    let localRealm = try? Realm()
    
    var dailyBoxOfficeRealmList: List<BoxOffice> = List<BoxOffice>() {
        didSet {
            dailyBoxOfficeTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dailyBoxOfficeTableViewConfig()
        currentDayConfig()
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
        fetchDailyBoxOffice(targetDt: searchTextField.text!)
    }
    
    func fetchDailyBoxOffice(targetDt: String) {
        
        let url = URL(string: Constants.API.boxofficeUrl(targetDt: targetDt))
        
        AF.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let dailyBoxOfficeList = json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue
                
//                let boxOfficeData: [Movie] = dailyBoxOfficeList.map {
//                    Movie(rank: $0["rank"].stringValue,
//                          movieNm: $0["movieNm"].stringValue,
//                          openDt: $0["openDt"].stringValue)
//                }
                
                self.dailyBoxOfficeRealmList.removeAll()
                
                let boxOfficeList = List<BoxOffice>()
                dailyBoxOfficeList.forEach {
                    boxOfficeList.append(BoxOffice(rank: $0["rank"].stringValue,
                                                         movieNm: $0["movieNm"].stringValue,
                                                         openDt: $0["openDt"].stringValue))
                }
                
            
                let boxOfficeResult = BoxOfficeResult(boxOfficeDate: targetDt, dailyBoxOfficeList: boxOfficeList)
                self.createRealmData(boxOffcieResult: boxOfficeResult)
                self.dailyBoxOfficeRealmList.append(objectsIn: boxOfficeList)
                //self.dailyBoxOfficeList.removeAll()
                //self.dailyBoxOfficeList.append(contentsOf: boxOfficeData)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createRealmData(boxOffcieResult: BoxOfficeResult) {
        try! localRealm?.write {
            localRealm?.add(boxOffcieResult)
        }
    }
    
    func currentDayConfig() {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        let dateString = formatter.string(from: yesterday)
        

        guard let boxOfficeResult = localRealm?.objects(BoxOfficeResult.self).filter("boxOfficeDate == \'\(dateString)\'").first else {
            fetchDailyBoxOffice(targetDt: dateString)
            return
        }
        
        readRealmData(boxOfficeResult: boxOfficeResult)
        
    }
    
    func readRealmData(boxOfficeResult: BoxOfficeResult) {
        dailyBoxOfficeRealmList.append(objectsIn: boxOfficeResult.dailyBoxOfficeList)
    }
    
}


extension DailyBoxOfficeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyBoxOfficeRealmList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TabelViewCell.DailyBoxOfficeTableViewCell, for: indexPath) as! DailyBoxOfficeTableViewCell
        
        //cell.bindData(movie: dailyBoxOfficeList[indexPath.row])
        cell.bindBoxOfficeData(boxOffice: dailyBoxOfficeRealmList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
