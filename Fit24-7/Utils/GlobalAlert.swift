//
//  GlobalAlert.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 19/02/25.
//

import SwiftUI

// MARK: Present an alert from anywhere in your app
@MainActor
func presentAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Ok", style: .default)
    alert.addAction(ok)
    rootController?.present(alert, animated: true)
}

@MainActor
var rootController: UIViewController? {
    var root = UIApplication.shared.windows.first?.rootViewController
    if let presenter = root?.presentedViewController {
        root = presenter
    }
    return root
}
