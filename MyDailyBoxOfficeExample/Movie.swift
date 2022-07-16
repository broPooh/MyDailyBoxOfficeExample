//
//  Movie.swift.swift
//  DailyBoxOffice
//
//  Created by JD_MacMini on 2021/10/26.
//

import Foundation

struct Movie: Hashable {
    var rank: String
    var movieNm: String
    var openDt: String
    
    let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
