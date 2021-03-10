//
//  ViewController.swift
//  ListApp
//
//  Created by Austin Christensen on 1/14/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var editAndSaveButton: UIBarButtonItem!
    
    var items: [ListItem] = []
    var selectedItem: ListItem?
    var itemDetailVC: ItemDetailViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Items"
        
        tableView.delegate = self
        tableView.dataSource = self

        loadData()
    }
    
    func loadData() {
        items = DataManager.loadAll(type: ListItem.self)?.sorted(by: {
            $0.index < $1.index
        }) ?? []
        tableView.reloadData()
    }
    
    func updateItems(newItem: ListItem?) {
        if let updatedItem = newItem {
            items.append(updatedItem)
        }
        for item in items {
            var updatedItem = item
            guard let updatedIndex = items.firstIndex(where: {$0.itemIdentifier == item.itemIdentifier} ) else { return }
            updatedItem.index = updatedIndex
            updatedItem.saveItem()
        }
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
    
    @IBAction func didTapEdit() {
        if tableView.isEditing {
            tableView.isEditing = false
            editAndSaveButton.title = "Edit"
        } else {
            tableView.isEditing = true
            editAndSaveButton.title = "Save"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ItemDetailViewController {
            self.itemDetailVC = destinationViewController

            itemDetailVC?.reloadListClosure = { [weak self] in
                self?.loadData()
            }
        }
        
        if segue.identifier == "detailSegue" {
            if let destinationViewController = segue.destination as? ItemDetailViewController {
                destinationViewController.detailItem = selectedItem
            }
        }
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        selectedItem = item

        performSegue(withIdentifier: "detailSegue", sender: cell)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.isCompleted ? "Completed" : "Not Complete"
        cell.detailTextLabel?.textColor = item.isCompleted ? .green : .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items[indexPath.row].deleteItem()
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.items[sourceIndexPath.row]
        items.remove(at: sourceIndexPath.row)
        items.insert(movedObject, at: destinationIndexPath.row)
        updateItems(newItem: nil)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
