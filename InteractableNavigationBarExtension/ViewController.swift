//
//  ViewController.swift
//  ExtendingNavigationBar
//
//  Created by Sashko Potapov on 15.11.2022.
//

import UIKit

private let CellReuseIdentifier = "candyCellReuseIdentifier"
private let ProgressBarViewHeight: CGFloat = 36

public final class ViewController: UIViewController {
    
    private let sweets: [Sweets] = [
        .init(name: "Candy", emoji: "🍬"),
        .init(name: "Lollypop", emoji: "🍭"),
        .init(name: "Chocolate", emoji: "🍫"),
        .init(name: "Donut", emoji: "🍩"),
        .init(name: "Cake", emoji: "🎂"),
    ]
    
    private var timer: Timer?
    private lazy var progressBarView: ProgressBarView = .init()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<String, Sweets> = {
        let ds = UITableViewDiffableDataSource<String, Sweets>(
            tableView: tableView,
            cellProvider: { [weak self] (tableView: UITableView, indexPath: IndexPath, sweets: Sweets) in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CellReuseIdentifier,
                    for: indexPath
                )
                
                var config = UIListContentConfiguration.sidebarCell()
                config.image = sweets.emoji.image()
                config.text = sweets.name
                cell.contentConfiguration = config
                return cell
            }
        )
        return ds
    }()
    
    private lazy var makeTeaButton: UIButton = {
        var c = UIButton.Configuration.plain()
        c.image = UIImage(systemName: "cup.and.saucer")
        let b = UIButton(configuration: c)
        return b
    }()
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpProgressBar()
    }
    
    private func setUpLayout() {
        title = "Sweets"
        
        navigationController?.navigationBar.backgroundColor = .white
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: CellReuseIdentifier
        )
        
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        var snapshot = NSDiffableDataSourceSnapshot<String, Sweets>()
        snapshot.appendSections(["Initial"])
        snapshot.appendItems(sweets, toSection: "Initial")
        
        dataSource.apply(snapshot)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: makeTeaButton)
    }
    
    private func setUpProgressBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.addSubview(progressBarView)
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressBarView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            progressBarView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            progressBarView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressBarView.heightAnchor.constraint(equalToConstant: ProgressBarViewHeight),
        ])
        
        progressBarView.isHidden = true
        
        progressBarView.setCancelAction({ [weak self] in
            self?.timer?.invalidate()
            self?.progressBarView.isHidden = true
            UIView.animate(
                withDuration: 0.25,
                animations: { self?.additionalSafeAreaInsets = .zero }
            )
        })

        makeTeaButton.addAction(
            UIAction(handler: { [weak self] _ in
                UIView.animate(withDuration: 0.25, animations: {
                    self?.additionalSafeAreaInsets.top = ProgressBarViewHeight
                }, completion: {
                    if $0 { self?.progressBarView.isHidden = false }
                })
                self?.setUpTimer()
            }),
            for: .touchUpInside
        )
    }
    
    private func setUpTimer() {
        DispatchQueue.global(qos: .background).async(execute: {
            var progress = 0.0
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] timer in
                progress += 0.025
                DispatchQueue.main.async(execute: {
                    self?.progressBarView.configure(title: "Preparing delicious tea...", subtitle: "", progress: progress)
                    if progress >= 1.0 {
                        timer.invalidate()
                        UIView.animate(withDuration: 0.25, animations: {
                            self?.progressBarView.isHidden = true
                            self?.additionalSafeAreaInsets = .zero
                        })
                    }
                })
            })
            
            self.timer?.fire()
            RunLoop.current.run()
        })
    }
}

extension ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = DetailViewController(sweets: item)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        DispatchQueue
            .main
            .asyncAfter(
                deadline: .now() + 0.5,
                execute: { tableView.deselectRow(at: indexPath, animated: true) }
            )
    }
}
