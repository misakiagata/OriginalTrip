//
//  CustomPresentationController.swift
//  JunctionProject
//
//  Created by 塗木冴 on 2019/02/17.
//  Copyright © 2019 GeekSalon. All rights reserved.
//

import UIKit

class CustomPresentationController: UIPresentationController {

    // 呼び出し元の View Controller の上に重ねるオーバーレイ View
    var overlayView: UIView!

    // 表示トランジション開始前に呼ばれる
    override func presentationTransitionWillBegin() {
        let containerView = self.containerView!
        self.overlayView = UIView(frame: containerView.bounds)
        self.overlayView.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(CustomPresentationController.overlayDidTouch(_:)))]
        self.overlayView.backgroundColor = UIColor.black
        self.overlayView.alpha = 0.0
        containerView.insertSubview(self.overlayView, at: 0)

        // トランジションを実行
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: {
            [unowned self] context in
            self.overlayView.alpha = 0.5
            }, completion: nil)
    }

    // 非表示トランジション開始前に呼ばれる
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: {
            [unowned self] context in
            self.overlayView.alpha = 0.0
            }, completion: nil)
    }

    // 非表示トランジション開始後に呼ばれる
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.overlayView.removeFromSuperview()
        }
    }

    // 子のコンテナのサイズを返す
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height)
    }

    // 呼び出し先の View Controller の Frame を返す
    func frameOfPresentedViewInContainerView() -> CGRect {
        var presentedViewFrame = CGRect.zero
        let containerBounds = containerView!.bounds
        presentedViewFrame.size =
            self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerBounds.size)
        presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width
        presentedViewFrame.origin.y = containerBounds.size.height - presentedViewFrame.size.height
        return presentedViewFrame
    }

    // レイアウト開始前に呼ばれる
    override func containerViewWillLayoutSubviews() {
        overlayView.frame = containerView!.bounds
        self.presentedView!.frame = self.frameOfPresentedViewInContainerView()
    }

    // レイアウト開始後に呼ばれる
    override func containerViewDidLayoutSubviews() {}

    // オーバーレイの View をタッチしたときに呼ばれる
    @objc func overlayDidTouch(_ sender: AnyObject) {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }

}
