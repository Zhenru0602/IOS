//
//  SearchViewController.swift
//  GoogleBookSearch
//
//  Created by Admin on 5/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Foundation

class SearchViewController: UIViewController {
    let viewModel = ViewModel()
    
    @IBOutlet weak var bookSearchBar: UISearchBar!
    
    @IBOutlet weak var bookTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
}

extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.cellConfig(bookname: viewModel.books[indexPath.row].bookName, bookAuthor: viewModel.books[indexPath.row].bookAuthor, bookPublisher: viewModel.books[indexPath.row].bookPublisher, bookImageUrl: viewModel.books[indexPath.row].bookImageUrl)
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectedBook = viewModel.books[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.viewModel = viewModel
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard var text =  searchBar.text else {
            return
        }
        text = String(text.filter { !" \n\t\r".contains($0) })
        if !text.isEmpty{
            //Model View call
            viewModel.getBooks(text: text)
        } else{
            print("Empty String!")
        }
        searchBar.endEditing(true)
    }
}

extension SearchViewController: ViewModelDelegate{
    func updateView() {
        print("View is updating!")
        DispatchQueue.main.async {
            self.bookTableView.reloadData()
        }
        if viewModel.books.count <= 0{
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "No Result", message: "No Result to Show!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            print("Empty Count!")
        }
    }
    
    func updateCore(){
    }
}
