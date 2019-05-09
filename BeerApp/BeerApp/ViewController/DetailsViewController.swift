//
//  DetailsViewController.swift
//  BeerApp
//
//  Created by Admin on 5/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var beerNameLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var beerImageView: UIImageView!
    
    var beerName: String!
    var id: String!
    var beerDescription: String!
    var beerImage: UIImage!
    
    override func viewDidLoad() {
        setLabels()
        super.viewDidLoad()
    }
    
    func config(beerName: String, id: String, beerDescription: String, beerImage: UIImage){
        self.beerName = beerName
        self.id = id
        self.beerDescription = beerDescription
        self.beerImage = beerImage
    }
    
    func setLabels(){
        beerNameLabel.text = beerName
        idLabel.text = id
        descriptionTextView.text = beerDescription
        beerImageView.image = beerImage
    }
    

}
