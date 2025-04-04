//
//  CartViewController.swift
//  ProductListApp
//

//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
       tableView.dataSource = self
       tableView.delegate = self
        
    }
    
    @IBAction func checkOutButtonTapeed(_ sender: Any) {
        if CartManager.shared.items.isEmpty {
            let alert = UIAlertController(title: "Add items", message: "To proceed to checkout", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        if let checkOutVC = storyboard?.instantiateViewController(identifier: "CheckOutViewController") as? CheckOutViewController {
            navigationController?.pushViewController(checkOutVC, animated: true)
        }
    }
    
    
}
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.shared.items.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTableViewCell
        let cartItem = CartManager.shared.items[indexPath.row]
        
        cell.productImage.image = cartItem.image
        cell.productTitle.text = cartItem.title
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                CartManager.shared.removeItem(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    
}
