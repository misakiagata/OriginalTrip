//
//  AlertController.swift
//  JunctionProject
//
//  Created by 塗木冴 on 2019/02/17.
//  Copyright © 2019 GeekSalon. All rights reserved.
//

import UIKit

final class AlertController {
    static let shared = AlertController()
    private init() { }

    func show(title: String = "エラー", message: String, fromViewController: UIViewController, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in
            completion?()
        }))
        fromViewController.present(alertController, animated: true, completion: nil)
    }
}
