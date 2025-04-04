//
//  ProductDetailsViewController.swift
//  ProductListApp//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    
    var itemImage: UIImage?
    var itemName: String?
    var itemDescription: String?
    var itemPrice: String?
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemLabel.text = itemName
        descriptLabel.text = itemDescription
        priceLabel.text = itemPrice
        addToCart.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        
        loadImage()
    }
    
    @IBAction func addToCartButtonTapped(_ sender: UIButton) {
        guard let image = productImage.image,
              let title = itemName else {
            return
        }
        
        let cartItem = CartItem(image: image, title: title)
        CartManager.shared.addItem(cartItem)
        if let cartVC = storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
                navigationController?.pushViewController(cartVC, animated: true)
            }
            
        print("Item added to cart")
    }
    
    
    
    
    
    
    private func loadImage() {
        guard let imageUrlString = imageUrl, let url = URL(string: imageUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.productImage.image = image
            }
        }.resume()
    }
}
