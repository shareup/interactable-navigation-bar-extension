import UIKit

public final class ProgressBarView: UIView {
    private let cancelActionIdentifier: UIKit.UIAction.Identifier = .init("CancelTouchUpInside")
    private lazy var progressView: UIProgressView = makeProgressView()
    private lazy var titleLabel: UILabel = makeTitleLabel()
    private lazy var subtitleLabel: UILabel = makeSubtitleLabel()
    private lazy var verticalStackView: UIStackView = makeVerticalStackView()
    private lazy var cancelButton: UIButton = makeCancelButton()

    private lazy var horizontalStackView: UIStackView = makeHorizontalStackView()
    private lazy var mainVerticalStackView: UIStackView = makeMainVerticalStackView()

    override public var isHidden: Bool {
        didSet {
            if isHidden { progressView.setProgress(0.0, animated: false) }
        }
    }

    init() {
        super.init(frame: .zero)

        addSubview(mainVerticalStackView)

        NSLayoutConstraint.activate([
            mainVerticalStackView.topAnchor.constraint(equalTo: topAnchor),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCancelAction(_ action: (() -> Void)?) {
        cancelButton.removeAction(identifiedBy: cancelActionIdentifier, for: .touchUpInside)
        guard let action else {
            cancelButton.alpha = 0.0
            return
        }

        cancelButton.alpha = 1.0
        let buttonAction = UIKit.UIAction(
            identifier: cancelActionIdentifier,
            handler: { _ in action() }
        )
        cancelButton.addAction(buttonAction, for: .touchUpInside)
    }

    func configure(title: String, subtitle: String, progress: Double) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        progressView.setProgress(Float(progress), animated: true)
    }
}

private extension ProgressBarView {
    func makeProgressView() -> UIProgressView {
        UIProgressView(progressViewStyle: .bar)
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }

    func makeSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .secondaryLabel
        return label
    }

    func makeProgressTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }

    func makeCancelButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(
            .init(systemName: "xmark")?
                .withRenderingMode(.alwaysTemplate)
                .withConfiguration(UIImage.SymbolConfiguration(scale: .small)),
            for: .normal
        )
        return button
    }

    func makeHorizontalStackView() -> UIStackView {
        let stackView =
            UIStackView(arrangedSubviews: [UIView.spacer, verticalStackView, cancelButton])
        stackView.axis = .horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.distribution = .equalSpacing
        return stackView
    }

    func makeVerticalStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.spacing = 0
        stackView.axis = .vertical
        return stackView
    }

    func makeMainVerticalStackView() -> UIStackView {
        let stackView =
            UIStackView(arrangedSubviews: [
                progressView,
                horizontalStackView,
                makeSeparatorView(),
            ])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    func makeSeparatorView() -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.backgroundColor = .separator
        return view
    }
}
