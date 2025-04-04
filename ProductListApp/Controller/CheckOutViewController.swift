//
//  CheckOutViewController.swift
//  ProductListApp

//

import UIKit

class CheckOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showOrderPlacedPopup()
    }
    
    func showOrderPlacedPopup() {
        let alert = UIAlertController(title: "Success", message: "Your order has been placed!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    

    
}
