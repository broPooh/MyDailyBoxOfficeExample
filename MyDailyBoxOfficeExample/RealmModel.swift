//
//  RealmModel.swift
//  MyDailyBoxOfficeExample
//
//  Created by bro on 2022/05/16.
//

import Foundation
import RealmSwift

class BoxOffice: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var rank: String
    @Persisted var movieNm: String
    @Persisted var openDt: String
    
    convenience init(rank: String, movieNm: String, openDt: String) {
        self.init()
        
        self.rank = rank
        self.movieNm = movieNm
        self.openDt = openDt
    }
}

class BoxOfficeResult: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var boxOfficeDate: String
    @Persisted var dailyBoxOfficeList: List<BoxOffice>

    convenience init(boxOfficeDate: String, dailyBoxOfficeList: List<BoxOffice>) {
        self.init()
        
        self.boxOfficeDate = boxOfficeDate
        self.dailyBoxOfficeList = dailyBoxOfficeList
    }
}
