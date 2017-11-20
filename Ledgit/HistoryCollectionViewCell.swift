//
//  HistoryCollectionViewCell.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/18/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import SwiftDate

class HistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var dayTableView: UITableView!
    
    var dateEntries: [DateSection] = []
    var cityEntries: [CitySection] = []
    let headerHeight: CGFloat = 25
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTableViews()
        setupSegmentedControl()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
         contentView.layer.cornerRadius = 10
         contentView.layer.borderWidth = 1
         contentView.layer.borderColor = UIColor.clear.cgColor
         contentView.layer.masksToBounds = true
         
         layer.cornerRadius = 10
         layer.shadowColor = UIColor.black.cgColor
         layer.shadowOffset = CGSize(width:0,height: 2)
         layer.shadowRadius = 4
         layer.shadowOpacity = 0.10
         layer.masksToBounds = false
         layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
    }
    
    func setupTableViews(){
        cityTableView.delegate = self
        dayTableView.delegate = self
        
        cityTableView.dataSource = self
        dayTableView.dataSource = self
    }
    
    func setupSegmentedControl(){
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.borderColor = UIColor.ledgitBlue.cgColor
        segmentedControl.titles = ["Date", "City"]
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }
    
    @objc func segmentedControlChanged(control: BetterSegmentedControl){
        switch control.index {
        case 0:
            cityTableView.flipTransition(with: dayTableView)
        default:
            dayTableView.flipTransition(with: cityTableView, isReverse: true)
        }
    }
    
    func updateTableViews(with data:[LedgitEntry]){
        guard !data.isEmpty else{
            return
        }
        
        dateEntries = []
        cityEntries = []
    
        for item in data{
            if let index = dateEntries.index(where: {$0.date.isInSameDayOf(date: item.date)}){
                dateEntries[index].entries.append(item)
            }else{
                
                let newSection = DateSection(date: item.date, entries: [item])
                dateEntries.append(newSection)
            }
            
            if let index = cityEntries.index(where: {$0.location == item.location}){
                cityEntries[index].amount += item.cost
            }else{
                let newSection = CitySection(location: item.location, amount: item.cost)
                cityEntries.append(newSection)
            }
        }
    
        cityTableView.reloadData()
        dayTableView.reloadData()
    }
}

extension HistoryCollectionViewCell: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case dayTableView:
            return dateEntries.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case dayTableView:
            return headerHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
        case dayTableView:
            
            guard !dateEntries.isEmpty else{
                return nil
            }
            
            let view = UIView()
            view.backgroundColor = .ledgitNavigationBarGray
        
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: dayTableView.frame.width, height: headerHeight))
            label.text = dateEntries[section].date.toString(style: .medium)
            label.font = .futuraMedium10
            label.textColor = .ledgitNavigationTextGray
            
            view.addSubview(label)
            
            return view
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case dayTableView:
            return dateEntries[section].entries.count
        default:
            return cityEntries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case dayTableView:
            let cell = dayTableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.date, for: indexPath) as! DateTableViewCell
            let item = dateEntries[indexPath.section].entries[indexPath.row]
            
            cell.updateLabels(amount: item.cost, description: item.description, category: item.category)
            
            return cell
        default:
            let cell = cityTableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.city, for: indexPath) as! CityTableViewCell
            let item = cityEntries[indexPath.row]
            cell.updateLabels(city: item.location, amount: item.amount)
            
            return cell
        }
    }
}
