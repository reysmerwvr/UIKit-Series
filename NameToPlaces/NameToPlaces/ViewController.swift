//
//  ViewController.swift
//  NameToPlaces
//
//  Created by Reysmer Valle on 6/24/21.
//

import UIKit

class ViewController: UICollectionViewController {
    var places = [Place]()
    var imagesCount = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let defaults = UserDefaults.standard
        imagesCount = defaults.object(forKey: "imagesCount") as? [String: Int] ?? [String: Int]()
        if let savedPlaces = defaults.object(forKey: "places") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                places = try jsonDecoder.decode([Place].self, from: savedPlaces)
            } catch {
                print("Failed to load places.")
            }
        }
        if places.count <= 0 {
            performSelector(inBackground: #selector(fetchImages), with: nil)
        }
        print(imagesCount)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Place", for: indexPath) as? PlaceCell else {
            fatalError("Unable to dequeue PlaceCell.")
        }
        
        let place = places[indexPath.item]
        cell.name?.text = place.name
        
        cell.imageView.image = UIImage(named: place.image)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let place = places[indexPath.item]
            vc.selectedImage = place.image
            if let imageCount = imagesCount[place.image] {
                imagesCount[place.image] = imageCount + 1
            } else {
                imagesCount[place.image] = 1
            }
            let defaults = UserDefaults.standard
            defaults.set(imagesCount, forKey: "imagesCount")
            if let index = places.firstIndex(where: { $0.image == vc.selectedImage }) {
                vc.imagePosition = "Picture \(index + 1) of \(places.count)"
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func fetchImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        print(items)
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load
                let place = Place(name: item, image: item)
                places.append(place)
                save()
            }
        }
        places.sort()
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(places) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "places")
        } else {
            print("Failed to save places.")
        }
    }
    
}

