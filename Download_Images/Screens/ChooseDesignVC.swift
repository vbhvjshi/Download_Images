//
//  ChooseDesignVC.swift
//  Download_Images
//
//  Created by VAIBHAV JOSHI on 16/04/24.
//

import UIKit

class ChooseDesignVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func horizontalButtonAction(_ sender: UIButton) {
        showImages(viewType: 0)
    }
    
    @IBAction func verticalButtonAction(_ sender: UIButton) {
        showImages(viewType: 1)
    }
    
    @IBAction func verticalGridButtonAction(_ sender: UIButton) {
        showImages(viewType: 2)
    }
    
    func showImages(viewType: Int) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhotoListViewController") as? PhotoListViewController else { return }
        vc.viewType = viewType
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
