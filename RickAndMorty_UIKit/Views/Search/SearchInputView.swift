//
//  SearchInputView.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import UIKit

protocol SearchInputViewDelegate: AnyObject {
    
    func searchInputView(_ input: SearchInputView, didSelectOption option: SearchInputViewViewModel.DynamicOption)
    func searchInputView(_ input: SearchInputView, didChangeSearchtext text: String)
    func searchInputViewDidTapSearchkeyboardButton(_ input: SearchInputView)
}

/// View for top of search screen with searchBar
final class SearchInputView: UIView {
    
    weak var delegate: SearchInputViewDelegate?
    private let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    private var viewModel: SearchInputViewViewModel? {
        didSet {
            guard let viewModel, viewModel.hasDynamicOptions else { return }
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }
    private var stackView: UIStackView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(searchBar)
        addConstants()
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstants() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func createOptionStackView() -> UIStackView {
    
        let stackView = UIStackView()
        self.stackView = stackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 8
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        stackView.backgroundColor = .systemBackground
        return stackView
    }
    
    private func createOptionSelectionViews(options: [SearchInputViewViewModel.DynamicOption]) {
        
        let stackView = createOptionStackView()
        for (offset, option) in options.enumerated() {
            let button = createButton(with: option, tag: offset)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        
        guard let options = viewModel?.options else { return }
        let tag = sender.tag
        let selected = options[tag]
        delegate?.searchInputView(self, didSelectOption: selected)
    }
    
    private func createButton(with option: SearchInputViewViewModel.DynamicOption, tag: Int) -> UIButton {
        
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: option.rawValue,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                    .foregroundColor: UIColor.secondaryLabel
                ]
            ),
            for: .normal
        )
        button.setAttributedTitle(
            NSAttributedString(
                string: option.rawValue,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                    .foregroundColor: UIColor.label
                ]
            ),
            for: .highlighted
        )
        button.backgroundColor = .secondarySystemFill
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.tag = tag
        button.layer.cornerRadius = 8
        
        return button
    }
    
    public func configure(with viewModel: SearchInputViewViewModel) {
        
        searchBar.placeholder = viewModel.searchPlaceHolderText
        
        self.viewModel = viewModel
    }
    
    public func presentKeyboard() {
        
        searchBar.becomeFirstResponder()
    }
    
    public func update(option: SearchInputViewViewModel.DynamicOption, value: String) {
        
        guard let buttons = stackView?.arrangedSubviews as? [UIButton], let index = viewModel?.options.firstIndex(of: option) else {
            return
        }
        let button: UIButton = buttons[index]
        button.setAttributedTitle(
            NSAttributedString(
                string: value.uppercased(),
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                    .foregroundColor: UIColor.systemBackground,
                ]
            ),
            for: .normal
        )
        button.backgroundColor = UIColor.secondaryLabel
    }
}

extension SearchInputView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        delegate?.searchInputView(self, didChangeSearchtext: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        delegate?.searchInputViewDidTapSearchkeyboardButton(self)
    }
}
