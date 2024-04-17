//
//  Loader.swift
//  Download_Images
//
//  Created by VAIBHAV JOSHI on 13/04/24.
//

import Foundation
import UIKit

class Loader {
    static let shared = Loader()

    private var loaderView: UIView?

    private init() {}
    
    func show() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootView = windowScene.windows.first?.rootViewController?.view else {
            return
        }

        guard loaderView == nil else {
            return // Loader is already visible
        }

        loaderView = UIView(frame: rootView.bounds)
        loaderView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loaderView?.isUserInteractionEnabled = true // Disable user interaction on the loader view

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = loaderView!.center
        activityIndicator.startAnimating()

        loaderView?.addSubview(activityIndicator)
        rootView.addSubview(loaderView!)
    }
    
    func show(on view: UIView) {
        guard loaderView == nil else {
            return // Loader is already visible
        }

        loaderView = UIView(frame: view.bounds)
        loaderView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loaderView?.isUserInteractionEnabled = true // Disable user interaction on the loader view

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = loaderView!.center
        activityIndicator.startAnimating()

        loaderView?.addSubview(activityIndicator)
        view.addSubview(loaderView!)
    }

    func hide() {
        loaderView?.removeFromSuperview()
        loaderView = nil
    }
}
