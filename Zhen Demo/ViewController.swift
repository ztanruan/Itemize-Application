//
//  ViewController.swift
//  Zhen Demo
//
//  Created by Jin Tan Ruan on 23/05/20.
//  Copyright © 2020 Jin Tan Ruan . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var strID = ""
    var arrData = [[String: Any]]()
    @IBOutlet weak var btnCreate: UIControl!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.strID = "Scooters"
        self.btnCreate.layer.cornerRadius = 12
        //self.view.backgroundColor = UIColor.groupTableViewBackground
        
        self.manageSection()
    }

    
    
    @IBAction func btnTabbar_Action(_ sender: UIControl) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC")
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}

//MARK: - UICollectionView Delegate Datasource Method
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func manageSection() {
        
        self.arrData.removeAll()
        self.arrData.append(["title": "Cars", "sub_title": "1,456 items", "image": #imageLiteral(resourceName: "car")])
        self.arrData.append(["title": "Helicopters", "sub_title": "658 items", "image": #imageLiteral(resourceName: "car")])
        self.arrData.append(["title": "Boats", "sub_title": "217 items", "image": #imageLiteral(resourceName: "car")])
        self.arrData.append(["title": "Scooters", "sub_title": "24 items", "image": #imageLiteral(resourceName: "car")])
        self.arrData.append(["title": "Trucks", "sub_title": "7,245 items", "image": #imageLiteral(resourceName: "car")])
        self.arrData.append(["title": "Planes", "sub_title": "3,901 items", "image": #imageLiteral(resourceName: "car")])
        self.collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: collectionItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionItemCell", for: indexPath) as! collectionItemCell
        
        let dic = self.arrData[indexPath.row]
        
        let strTitlee = dic["title"] as? String ?? ""
        cell.lbl_Title.text = dic["title"] as? String ?? ""
        cell.lbl_subTitle.text = dic["sub_title"] as? String ?? ""
        cell.img_Center.image =  dic["image"] as? UIImage ?? #imageLiteral(resourceName: "car")
        
        if self.strID == strTitlee {
            cell.view_Base.layer.borderWidth = 2
            cell.view_Base.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.5019607843, blue: 0.6274509804, alpha: 1)
        }
        else {
            cell.view_Base.layer.borderWidth = 0
            cell.view_Base.layer.borderColor = UIColor.clear.cgColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = (UIScreen.main.bounds.width - 36)/2
        return CGSize.init(width: screenWidth, height: screenWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dic = self.arrData[indexPath.row]
        self.strID = dic["title"] as? String ?? ""
        self.collectionView.reloadData()
    }
    
}


//MARK: - UICollectionView Cell
class collectionItemCell: UICollectionViewCell {
    
    @IBOutlet weak var view_Base: UIView!
    @IBOutlet weak var view_inner: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
    @IBOutlet weak var img_Center: UIImageView!
    @IBOutlet weak var constraint_lblHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view_Base.layer.cornerRadius = 12
        self.view_inner.layer.cornerRadius = 12
    }
}

