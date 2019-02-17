//
//  ConfirmViewController.swift
//  JunctionProject
//
//  Created by 塗木冴 on 2019/02/17.
//  Copyright © 2019 GeekSalon. All rights reserved.
//

import UIKit
import Cloudinary

class ConfirmViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!

    var selectedImage = UIImage()
    var cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudinaryUrl: "cloudinary://811678753816195:Y7GnzUIkCmWIIF0sTJ1kaf86_eo@dctjfnqhu/")!)
    fileprivate var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    fileprivate lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.goBackPageByPan(_:)))
        recognizer.delegate = self
        return recognizer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.view.addGestureRecognizer(panGestureRecognizer)

        let config = CLDConfiguration(cloudName: "dctjfnqhu", apiKey: "811678753816195", apiSecret: "Y7GnzUIkCmWIIF0sTJ1kaf86_eo")
        cloudinary = CLDCloudinary(configuration: config)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tapYesButton(_ sender: Any) {
        // CloudinaryのAPIを叩く
        uploadToCloudinary()
//        AlertController.shared
//            .show(title: "SUCCESS", message: "Tag作成に成功しました。", fromViewController: self, completion: {
//                self.dismiss(animated: true, completion: nil)
//            })
    }
    
    @IBAction func tapNoButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    private func configureUI() {
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true

        selectedImageView.image = selectedImage
        selectedImageView.layer.cornerRadius = 10
        selectedImageView.layer.masksToBounds = true
    }

    func uploadToCloudinary(){
        guard let uploadimageData = selectedImage.pngData() else {
            return
        }
        let request = cloudinary.createUploader().upload(data: uploadimageData, uploadPreset: "s0ht6m2b")
        request.response({ (result, error) in
            if let result = result {
                let tags = result.tags
                let firstTag = tags![0].uppercased() ?? "TREE"
                let secondTag = tags![1].uppercased() ?? "SEA"
                let thirdTag = tags![2].uppercased() ?? "WATER"
                AlertController.shared
                    .show(title: "SUCCESS", message: "A trip with #\(firstTag) #\(secondTag) #\(thirdTag) tags was created.", fromViewController: self, completion: {
                        self.dismiss(animated: true, completion: nil)
                    })
            }
        })
    }

    @objc private func goBackPageByPan(_ sender: UIPanGestureRecognizer) {

        let touchPoint = sender.location(in: self.view?.window)
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
            if touchPoint.y - initialTouchPoint.y > statusBarHeight {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}

// MARK: - Gesture recognizer delegate
extension ConfirmViewController: UIGestureRecognizerDelegate {}


