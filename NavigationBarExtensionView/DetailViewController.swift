//
//  DetailViewController.swift
//  ExtendingNavigationBar
//
//  Created by Sashko Potapov on 15.11.2022.
//

import Foundation
import UIKit

public final class DetailViewController: UIViewController {
    private let sweets: Sweets

    private lazy var label: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 50)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    init(sweets: Sweets) {
        self.sweets = sweets
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        title = sweets.name
        label.text = sweets.emoji
    }
}
