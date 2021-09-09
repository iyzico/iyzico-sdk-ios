//
//  HomeVC.swift
//  iyzi-co-testApp
//
//  Created by Tolga İskender on 7.12.2020.
//

import UIKit
import iyzi_co_test_framework

class HomeVC: UIViewController {
 
    let textView = IyzicoButton(buttonType: .primaryLvl1(state: .normal),title: "test")
    override func viewDidLoad() {
        super.viewDidLoad()
       
        textView.frame = CGRect(x: 50, y: 150, width: self.view.bounds.width-32, height: 64)
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 4
        textView.center = view.center
       
       // print(textView.isChecked)
        //button2.makePassive()
       
        
        self.view.addSubview(textView)
    }

    @IBAction func dd(_ sender: Any) {
        let vc = IyzicoIntroVC(brandName: "Lidyana.com", price: 113.40)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}
