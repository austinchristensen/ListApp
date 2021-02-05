//
//  ItemDetailViewController.swift
//  ListApp
//
//  Created by Austin Christensen on 2/5/21.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var detailItem: ListItem?
    var detailItems: [String] = []
    var reloadListClosure: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        guard let itemsFromDetailItem = detailItem?.detailItems else { return }
        detailItems = itemsFromDetailItem
        tableView.reloadData()
    }
}

extension ItemDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ItemDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let item = detailItems[indexPath.row]

        cell.textLabel?.text = item

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            detailItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            detailItem?.detailItems = detailItems
            detailItem?.saveItem()
            reloadListClosure?()
        }
    }
}
