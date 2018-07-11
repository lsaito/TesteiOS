//
//  FormViewController.swift
//  TesteiOS
//
//  Created by lucas.eiji.saito on 22/05/18.
//  Copyright (c) 2018 Accenture. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FormDisplayLogic: class
{
  func displayCells(viewModel: [Form.FormCell.ViewModel])
}

class FormViewController: UIViewController, FormDisplayLogic
{
  var interactor: FormViewControllerOutput?
  var router: (NSObjectProtocol & FormRoutingLogic & FormDataPassing)?
    var tableView: UITableView!
    var cells: [Form.FormCell.ViewModel] = []

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = FormInteractor()
    let presenter = FormPresenter()
    let router = FormRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    //safeArea
    let mainView = UIView()
    mainView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(mainView)
    let margins = view.layoutMarginsGuide
    NSLayoutConstraint.activate([
        mainView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
        mainView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
    ])
    if #available(iOS 11, *) {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraintEqualToSystemSpacingBelow(guide.topAnchor, multiplier: 1.0),
            guide.bottomAnchor.constraintEqualToSystemSpacingBelow(mainView.bottomAnchor, multiplier: 1.0)
        ])
        
    } else {
        let standardSpacing: CGFloat = 8.0
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
            bottomLayoutGuide.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: standardSpacing)
        ])
    }
    self.view.backgroundColor = UIColor.white
    
    let labelTitle = UILabel()
    labelTitle.translatesAutoresizingMaskIntoConstraints = false
    labelTitle.font = UIFont.init(name: "DINPro-Medium", size: 17.0)
    labelTitle.textAlignment = .center
    labelTitle.text = "Contato"
    mainView.addSubview(labelTitle)
    
    self.tableView = UITableView()
    self.tableView.translatesAutoresizingMaskIntoConstraints = false
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    mainView.addSubview(self.tableView)
    
    let metrics = [
        "topMargin": 10,
        "leadingLeft": 10,
        "trailingRight": 10
    ] as [String : Float]
    let viewsDict = [
        "mainview" : mainView,
        "label" : labelTitle,
        "tableview" : self.tableView
    ] as [String : Any]
    mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableview]|", options: [], metrics: metrics, views: viewsDict))
    mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topMargin-[label]-topMargin-[tableview]|", options: [], metrics: metrics, views: viewsDict))
    mainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-leadingLeft-[label]-trailingRight-|", options: [], metrics: metrics, views: viewsDict))
    
    configTableViewCells()
    fetchCellsOnLoad()
  }
    
    func configTableViewCells() {
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        tableView.register(UINib(nibName: "CheckboxTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckboxTableViewCell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
  
  // MARK: Do something
  
  func fetchCellsOnLoad()
  {
    let request = Form.FetchCells.Request()
    interactor?.fetchCells(request: request)
  }
    
    
  func displayCells(viewModel: [Form.FormCell.ViewModel])
  {
    self.cells = viewModel
    tableView.reloadData()
  }
    
    @objc func sendForm(sender: UIButton!) {
        var isFormValid = true
//        cells.forEach({ cell in
//            if (cell.type == CellType.field && !cell.isValid) {
//                isFormValid = false
//            }
//        })
        
        if (isFormValid) {
            let formSuccessVC = FormSuccessViewController(nibName: "FormSuccessViewController", bundle: nil)
            router?.navigateToFormSuccess(source: self, destination: formSuccessVC)
        }
    }
}

// MARK: TableView Delegate
// MARK: TableView DataSource
extension FormViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellView: UITableViewCell = UITableViewCell()
        let viewModelCell = cells[indexPath.row]
        
        let metrics = [
            "topMargin": viewModelCell.topSpacing]
        
        switch viewModelCell.type {
        case .field:
            let cellTextField = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as? TextFieldTableViewCell
            cellTextField?.viewModel = viewModelCell
            cellView = cellTextField!
        case .text:
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.init(name: "DINPro-Regular", size: 17.0)
            label.textAlignment = .left
            label.text = viewModelCell.message
            label.numberOfLines = 0
            
            cellView.addSubview(label)
            
            let viewsDict = [
                "label" : label
                ] as [String : Any]
            cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: viewsDict))
            cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topMargin-[label]|", options: [], metrics: metrics, views: viewsDict))
        case .image:
            let imageView = UIImageView()
            cellView.addSubview(imageView)
        case .checkbox:
            let cellCheckbox = tableView.dequeueReusableCell(withIdentifier: "CheckboxTableViewCell", for: indexPath) as? CheckboxTableViewCell
            cellCheckbox?.viewModel = viewModelCell
            cellView = cellCheckbox!
        case .send:
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(viewModelCell.message, for: UIControlState.normal)
            button.titleLabel?.font = UIFont.init(name: "DINPro-Medium", size: 17.0)
            button.backgroundColor = UIColor(red: 202.0/255.0, green: 40.0/255.0, blue: 15.0/255.0, alpha: 1.0)
            button.layer.cornerRadius = 20
            button.addTarget(self, action: #selector(sendForm), for: .touchUpInside)
            
            cellView.addSubview(button)
            
            let metricsButton = [
                "topMargin": viewModelCell.topSpacing
            ] as [String : Float]
            let viewsDict = [
                "button" : button
                ] as [String : Any]
            cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[button]-20-|", options: [], metrics: nil, views: viewsDict))
            cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topMargin-[button(==40)]|", options: [], metrics: metricsButton, views: viewsDict))
        }
        
        return cellView
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
