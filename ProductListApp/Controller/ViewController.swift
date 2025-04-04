//
//  ViewController.swift
//  ProductListApp
//
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    


    var products: [Product] = []
    var imagesCache: [Int: UIImage] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchProducts()
    }
    @IBAction func cartButtonTapped(_ sender: UIButton) {
        if let cartVC = storyboard?.instantiateViewController(identifier: "CartViewController") as? CartViewController {
            navigationController?.pushViewController(cartVC, animated: true)
        }
            
    }
    

    func fetchProducts() {
        let urlString = "https://fakestoreapi.com/products"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                self.products = products
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Failed to decode products:", error)
            }
        }.resume()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController {
            detailsVC.itemName = product.title
            detailsVC.itemDescription = product.description
            detailsVC.itemPrice = "$\(product.price)"
            detailsVC.imageUrl = product.image  // Pass the image URL instead of the image
            
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }

        let product = products[indexPath.item]
        cell.titleLabel.text = product.title
        cell.descriptionLabel.text = product.description
        cell.priceLabel.text = "₹\(product.price)"
        cell.layer.cornerRadius = 10
        
        cell.layer.borderColor = UIColor.lightGray.cgColor

        // Use URLSession data task for image loading
        if let cachedImage = imagesCache[product.id] {
            cell.imageView.image = cachedImage
        } else if let imageURL = URL(string: product.image) {
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
                guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else { return }
                self.imagesCache[product.id] = image
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }.resume()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 10
        return CGSize(width: width, height: 250)
    }
}
