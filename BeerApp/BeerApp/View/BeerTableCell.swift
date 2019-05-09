//
//  BeerTableCell.swift
//  BeerApp
//
//  Created by mac on 5/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class BeerTableCell: UITableViewCell {

    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerMainLabel: UILabel!
    @IBOutlet weak var beerSubLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        beerImage.image = nil
    }
    
    static let identifier = "BeerCell"
    
    func configure(with beer: Beer) {

        beerMainLabel.text = beer.name
        beerSubLabel.text = beer.id
        
        let urlString = beer.imageUrl
 
        DLService.downloadImage(url: urlString) { [unowned self] img in
            
            let image = img == nil ? UIImage(named: "beer") : img
            
            DispatchQueue.main.async {
                self.beerImage.image = image!
            }
        }
        
    } //end func
    

}
