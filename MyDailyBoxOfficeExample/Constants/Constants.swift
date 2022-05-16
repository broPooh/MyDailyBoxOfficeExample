//
//  Constants.swift
//  MyDailyBoxOfficeExample
//
//  Created by bro on 2022/05/09.
//

import Foundation

struct Constants {
    
    struct API {
        static let BOXOFFICE_BASE_URL = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
        static let BOXOFFICE_API_KEY = "9b601cf9bc4f18a775d8239e346dbad6"
        
        static func boxofficeUrl(targetDt: String) -> String {
            return BOXOFFICE_BASE_URL + "key=\(BOXOFFICE_API_KEY)&targetDt=\(targetDt)"
        }
    }
    
    struct ViewController {
        static let DailyBoxOfficeViewController = "DailyBoxOfficeViewController"
    }
    
    struct TabelViewCell {
        static let DailyBoxOfficeTableViewCell = "DailyBoxOfficeTableViewCell"
    }
}
