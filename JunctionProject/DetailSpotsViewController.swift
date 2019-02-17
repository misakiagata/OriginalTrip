//
//  DetailSpotsViewController.swift
//  JunctionProject
//
//  Created by 縣美早 on 2019/02/17.
//  Copyright © 2019年 GeekSalon. All rights reserved.
//

import UIKit

class DetailSpotsViewController: UIViewController {
    
    @IBOutlet var detailImageView: UIImageView!
    var number = 0
    let imageArray = ["junction.png","junction2.png","junction3.png", "junction4.png","junction5.png"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func setImage() {

        if number <= 4 {
            detailImageView.image = UIImage(named: imageArray[number])
            number += 1
        } else {
           reset()
        }
        
    }
    func reset() {
         number = 0
    }
}
