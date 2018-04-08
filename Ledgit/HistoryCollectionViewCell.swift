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

protocol DayTableCellDelegate: class {
    func selected(entry: LedgitEntry, at cell: UITableViewCell)
}

class HistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var dayTableView: UITableView!
    weak var delegate: DayTableCellDelegate?
    
    var dateEntries: [DateSection] = []
    var cityEntries: [CitySection] = []
    let headerHeight: CGFloat = 30
    
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
        cityTableView.dataSource = self
        
        dayTableView.delegate = self
        dayTableView.dataSource = self
    }
    
    func setupSegmentedControl(){
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.borderColor = LedgitColor.coreBlue.cgColor
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
    
    func setup(with entries:[LedgitEntry]) {
        guard !entries.isEmpty else { return }
        
        dateEntries = []
        cityEntries = []
    
        for item in entries {
            if let index = dateEntries.index(where: { $0.date.isInSameDayOf(date: item.date) }) {
                dateEntries[index].entries.append(item)
            } else {
                
                let newSection = DateSection(date: item.date, entries: [item], collapsed: false)
                dateEntries.append(newSection)
            }
            
            if let index = cityEntries.index(where: {$0.location == item.location}) {
                cityEntries[index].amount += item.convertedCost
                
            } else {
                let newSection = CitySection(location: item.location, amount: item.convertedCost)
                cityEntries.append(newSection)
            }
        }
        
        dateEntries = dateEntries.sorted { $0.date > $1.date }
    
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
            guard !dateEntries.isEmpty else { return nil }
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleDateHeaderView ?? CollapsibleDateHeaderView(reuseIdentifier: "header")
            header.section = section
            header.setCollapsed(dateEntries[section].collapsed)
            header.titleLabel.text(dateEntries[section].date.toString(style: .medium))
            header.delegate = self

            return header
            
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case dayTableView:
            return dateEntries[section].collapsed ? 0 : dateEntries[section].entries.count
        default:
            return cityEntries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case dayTableView:
            let cell = dayTableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.date, for: indexPath) as! DateTableViewCell
            let entry = dateEntries[indexPath.section].entries[indexPath.row]
            cell.setup(with: entry)
           
            return cell
        default:
            let cell = cityTableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.city, for: indexPath) as! CityTableViewCell
            let section = cityEntries[indexPath.row]
            cell.setup(with: section)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView == dayTableView else { return }
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let entry = dateEntries[indexPath.section].entries[indexPath.row]
        delegate?.selected(entry: entry, at: cell)
    }
}

extension HistoryCollectionViewCell: CollapsibleDateHeaderViewDelegate {
    func toggleSection(_ header: CollapsibleDateHeaderView, section: Int) {
        let collapsed = !dateEntries[section].collapsed
        let sectionToReload = IndexSet(integer: section)
        
        dateEntries[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        dayTableView.reloadSections(sectionToReload, with: .automatic)
    }
}
