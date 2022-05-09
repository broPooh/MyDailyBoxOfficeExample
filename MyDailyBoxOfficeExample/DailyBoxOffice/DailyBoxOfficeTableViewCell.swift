//
//  DailyBoxOfficeTableViewCell.swift
//  MyDailyBoxOfficeExample
//
//  Created by bro on 2022/05/09.
//

import UIKit

class DailyBoxOfficeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func bindData(movie: Movie) {
        rankLabel.text = movie.rank
        titleLabel.text = movie.movieNm
        dateLabel.text = movie.openDt
    }
    
}
