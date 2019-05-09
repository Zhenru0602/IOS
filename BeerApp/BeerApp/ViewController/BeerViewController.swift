//
//  ViewController.swift
//  BeerApp
//
//  Created by mac on 5/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class BeerViewController: UIViewController {
    
    @IBOutlet weak var beerTableView: UITableView!
    
    var beers = [Beer]() {
        didSet {
            self.beerTableView.reloadData()
        }
    }
    
    var beerImage: UIImage!
    var beerName: String!
    var beerDescription: String!
    var id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getBeers()
    }
    
    func getBeers() {
        
        let endpoint = "http://api.brewerydb.com/v2/beers/?key=7fbb9e2f23fc6f2c2d8adbdc6b0c7620"
        
        guard let url = URL(string: endpoint) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [unowned self] (dat, _, err) in
            if let error = err {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
            if let data = dat {
                
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                        let beerArray = jsonObject["data"] as? [[String:Any]] else {
                        print("Bad JSON formatting")
                        return
                    }
                    
                    var ourBeers = [Beer]()
                    
                    for beerDict in beerArray {
                        
                        if let beer = try Beer(json: beerDict) {
                            ourBeers.append(beer)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.beers = ourBeers
                        print("Beer Count: \(self.beers.count)")
                    }
                    
                    
                } catch {
                    
                    print("Couldn't Serialize Object: \(error.localizedDescription)")
                }
            }
        }.resume()
    } //end func


}

extension BeerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BeerTableCell.identifier, for: indexPath) as! BeerTableCell
        
        let beer = beers[indexPath.row]
        cell.configure(with: beer)
        
        
        return cell
    }
    
    
    
}

extension BeerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        self.beerName = beers[indexPath.row].name
        self.id = beers[indexPath.row].id
        self.beerDescription = beers[indexPath.row].description
        let beerUrl = beers[indexPath.row].imageUrl
        DLService.downloadImage(url: beerUrl) { img in
            self.beerImage = (img == nil ? UIImage(named: "beer") : img)!
        }
        DispatchQueue.main.async {
            detailVC.config(beerName: self.beerName, id: self.id, beerDescription: self.beerDescription, beerImage: self.beerImage)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func getImage(urlString: String){
        
    }
    
}
