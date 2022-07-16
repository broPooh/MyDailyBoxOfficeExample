//
//  TestViewController.swift
//  MyDailyBoxOfficeExample
//
//  Created by bro on 2022/07/16.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON
import RealmSwift

class TestViewController: UIViewController {
    
    enum Section: CaseIterable {
        case title
    }
    
    @IBOutlet weak var testSearchTextField: HoshiTextField!
    @IBOutlet weak var testdailyBoxOfficeTableView: UITableView!
    
    
    var dataSource: UITableViewDiffableDataSource<Section, Movie>! = nil
    
    
    @IBAction func testSearchButtonClicked(_ sender: UIButton) {
        fetchDailyBoxOffice(targetDt: testSearchTextField.text!)
        //testdailyBoxOfficeTableView.reloadData()
        //testdailyBoxOfficeTableView.reloadSections(IndexSet(0...0), with: .automatic)
    }
    
    var dailyBoxOfficeList : [Movie] = [] {
        didSet {
            print("ss")
            //testdailyBoxOfficeTableView.reloadData()
        }
    }
    
    let localRealm = try? Realm()
    
    var dailyBoxOfficeRealmList: List<BoxOffice> = List<BoxOffice>() {
        didSet {
            //testdailyBoxOfficeTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dailyBoxOfficeTableViewConfig()
        currentDayConfig()
    }
    
    func dailyBoxOfficeTableViewConfig() {
        let nibName = UINib(nibName: Constants.TabelViewCell.DailyBoxOfficeTableViewCell, bundle: nil)
        testdailyBoxOfficeTableView.register(nibName, forCellReuseIdentifier: Constants.TabelViewCell.DailyBoxOfficeTableViewCell)
        
        dataSource = UITableViewDiffableDataSource<Section, Movie>(tableView: self.testdailyBoxOfficeTableView) {
            (tableView: UITableView, indexPath: IndexPath, movie: Movie) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TabelViewCell.DailyBoxOfficeTableViewCell, for: indexPath) as! DailyBoxOfficeTableViewCell
            cell.rankLabel.text = movie.rank
            cell.titleLabel.text = movie.movieNm
            return cell
        }
        testdailyBoxOfficeTableView.dataSource = self.dataSource
        
//        dailyBoxOfficeTableView.delegate = self
//        dailyBoxOfficeTableView.dataSource = self
        
        testdailyBoxOfficeTableView.backgroundColor = .clear
        testdailyBoxOfficeTableView.separatorStyle = .none
        
        testdailyBoxOfficeTableView.rowHeight = 100
        //dailyBoxOfficeTableView.estimatedRowHeight = 50
        
        //print("테이블뷰 셋팅 셀포 로우엣 \(testdailyBoxOfficeTableView.rowHeight)")
        //print("테이블뷰 셋팅 예측 \(testdailyBoxOfficeTableView.estimatedRowHeight)")
    }
    
    func fetchDailyBoxOffice(targetDt: String) {
        let url = URL(string: Constants.API.boxofficeUrl(targetDt: targetDt))
        
        AF.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let dailyBoxOfficeList = json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue
                
                let boxOfficeData: [Movie] = dailyBoxOfficeList.map {
                    Movie(rank: $0["rank"].stringValue,
                          movieNm: $0["movieNm"].stringValue,
                          openDt: $0["openDt"].stringValue)
                }
                
                DispatchQueue.main.async {
                    print(boxOfficeData)
                    var snapShot = NSDiffableDataSourceSnapshot<Section, Movie>()
                    snapShot.appendSections([.title])
                    snapShot.appendItems(boxOfficeData)
                    self.dataSource.apply(snapShot, animatingDifferences: true)
                }
                
            

                
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
