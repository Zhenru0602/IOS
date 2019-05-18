//
//  BookmarkViewController.swift
//  GoogleBookSearch
//
//  Created by Admin on 5/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import CoreData

class BookmarkViewController: UIViewController {
    var viewModel = ViewModel()

    @IBOutlet weak var bookmarkTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.initCoreBooks()
    }
    

}

extension BookmarkViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.coreBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath) as! BookmarkTableViewCell
        cell.cellConfig(bookname: viewModel.coreBooks[indexPath.row].bookName, bookAuthor: viewModel.coreBooks[indexPath.row].bookAuthor, bookPublisher: viewModel.coreBooks[indexPath.row].bookPublisher, bookImageUrl: viewModel.coreBooks[indexPath.row].bookImageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                let id = viewModel.coreBooks[indexPath.row].bookId
                viewModel.coreBooks.remove(at: indexPath.row)
                viewModel.removeFromBookmark(id: id)
            default:
                break
        }
    }
    
    
}

extension BookmarkViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        viewModel.selectedBook = viewModel.coreBooks[indexPath.row]
        detailVC.viewModel = viewModel
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension BookmarkViewController: ViewModelDelegate{
    func updateView() {
    }
    
    func updateCore() {
        DispatchQueue.main.async {
            self.bookmarkTableView.reloadData()
        }
    }
}
