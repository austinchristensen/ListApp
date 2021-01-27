//
//  ViewController.swift
//  ListApp
//
//  Created by Austin Christensen on 1/14/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var items: [ListItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Items"
        
        tableView.delegate = self
        tableView.dataSource = self

        loadData()
    }
    
    func loadData() {
        items = DataManager.loadAll(ListItem.self).sorted(by: {
            $0.createdAt < $1.createdAt
        })
        tableView.reloadData()
    }
    
    func updateItems(newItem: ListItem) {
        newItem.saveItem()
        items.append(newItem)
        loadData()
    }
    
    @IBAction func didTapAdd() {
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! NewEntryViewController
        vc.title = "New Item"
        vc.update = { [weak self] item in
            DispatchQueue.main.async {
                self?.updateItems(newItem: item)
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }


}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items[indexPath.row].deleteItem()
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
