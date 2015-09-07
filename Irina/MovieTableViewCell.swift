//
//  MovieTableViewCell.swift
//  Irina
//
//  Created by Axel Cardinaels on 6/09/15.
//  Copyright (c) 2015 Axel Cardinaels. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var moviePoster: UIImageView!

    @IBOutlet var movieType: UILabel!

    @IBOutlet var movieRate: UILabel!
    @IBOutlet var cellView: UIView!
}
