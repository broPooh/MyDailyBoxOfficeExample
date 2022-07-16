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
    
    var array = ["aa", "bb", "cc", "dd", "ee"]
    var array2 = ["aa", "bb", "cc", "dd", "ee", "ff", "gg", "hh", "ii", "jj", "kk", "ll", "mm", "nn"]
    
    var dailyBoxOfficeRealmList: List<BoxOffice> = List<BoxOffice>() {
        didSet {
            dailyBoxOfficeTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //array = Array.init(repeating: "asdfagwegawegawegawgawegawagvwekfjahwekfjhasgdkfjhgawejfkhgawjkfvhgjksdvgjkagshdvkajsdhvbhjaksv", count: 200)
        array = Array.init(repeating: "asdfagwegawegawegawgawegawagvwekfjahwekfjhasg", count: 200)

        dailyBoxOfficeTableViewConfig()
        //currentDayConfig()
    }
    
    func dailyBoxOfficeTableViewConfig() {
        let nibName = UINib(nibName: Constants.TabelViewCell.DailyBoxOfficeTableViewCell, bundle: nil)
        dailyBoxOfficeTableView.register(nibName, forCellReuseIdentifier: Constants.TabelViewCell.DailyBoxOfficeTableViewCell)
        
        dailyBoxOfficeTableView.delegate = self
        dailyBoxOfficeTableView.dataSource = self
        
        dailyBoxOfficeTableView.backgroundColor = .clear
        dailyBoxOfficeTableView.separatorStyle = .none
        
        dailyBoxOfficeTableView.rowHeight = UITableView.automaticDimension
        //dailyBoxOfficeTableView.estimatedRowHeight = 50
        
        print("테이블뷰 셋팅 셀포 로우엣 \(dailyBoxOfficeTableView.rowHeight)")
        print("테이블뷰 셋팅 예측 \(dailyBoxOfficeTableView.estimatedRowHeight)")
    }
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        //fetchDailyBoxOffice(targetDt: searchTextField.text!)
        //dailyBoxOfficeTableView.reloadData()
        //dailyBoxOfficeTableView.reloadSections(IndexSet(0...0), with: .automatic)
        dailyBoxOfficeTableView.reloadRows(at: [IndexPath(row: 10, section: 0)], with: .automatic)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 2
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return dailyBoxOfficeRealmList.count
        
        return array.count
//        if section == 0 {
//            return array2.count
//        } else {
//            return array.count
//        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TabelViewCell.DailyBoxOfficeTableViewCell, for: indexPath) as! DailyBoxOfficeTableViewCell
        
        
        //cell.bindData(movie: dailyBoxOfficeList[indexPath.row])
        //cell.bindBoxOfficeData(boxOffice: dailyBoxOfficeRealmList[indexPath.row])
        print("cellForRowAt rowHeight 높이 \(indexPath), \(dailyBoxOfficeTableView.rowHeight)")
        print("cellForRowAt estimatedRowHeight 높이 \(indexPath), \(dailyBoxOfficeTableView.estimatedRowHeight)")
//        if indexPath.section == 0 {
//            //print("cellForRowAt 실제 높이 \(indexPath.row), \(dailyBoxOfficeTableView.rowHeight)")
//            //print("cellForRowAt 예측 높이 \(indexPath.row), \(dailyBoxOfficeTableView.estimatedRowHeight)")
//            cell.rankLabel.text = "\(indexPath.row)"
//            cell.titleLabel.text = array2[indexPath.row]
//        } else {
//            //print("cellForRowAt 실제 높이 \(indexPath.row), \(dailyBoxOfficeTableView.rowHeight)")
//            //print("cellForRowAt 예측 높이 \(indexPath.row), \(dailyBoxOfficeTableView.estimatedRowHeight)")
//            cell.rankLabel.text = "\(indexPath.row)"
//            cell.titleLabel.text = array[indexPath.row]
//        }
        
        cell.rankLabel.text = "\(indexPath.row)"
        cell.titleLabel.text = array[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        //print("estimatedHeightForRowAt 호출, 실제 높이 \(indexPath), \(dailyBoxOfficeTableView.rowHeight)")
        //print("estimatedHeightForRowAt 호출, 예측 높이 \(indexPath.row), \(dailyBoxOfficeTableView.estimatedRowHeight)")
        print("estimatedHeightForRowAt 호출, 예측 인덱스 패스 \(indexPath), \(dailyBoxOfficeTableView.estimatedRowHeight)")
        
        return 100
    }
}
