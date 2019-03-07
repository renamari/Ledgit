//
//  TripsViewController.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/15/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import AMPopTip

class TripsViewController: UIViewController {
    @IBOutlet weak var tripsTableView: UITableView!
    private let presenter = TripsPresenter(manager: TripsManager())
    private var defaultTripIndexPath: IndexPath?
    private var editingIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        setupTableView()
        setupPresenter()
        setupGestureRecognizers()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .white
    }

    func setupPresenter() {
        presenter.delegate = self
        presenter.retrieveTrips()
    }

    func setupTableView() {
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        tripsTableView.rowHeight = UITableView.automaticDimension
        tripsTableView.estimatedRowHeight = 200
        tripsTableView.sectionHeaderHeight = 10
    }

    func setupGestureRecognizers() {
        let edgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipedEdge(gesture:)))
        edgeRecognizer.edges = .left
        view.addGestureRecognizer(edgeRecognizer)
    }

    @objc func swipedEdge(gesture: UIGestureRecognizer) {
        guard let gesture = gesture as? UIScreenEdgePanGestureRecognizer else { return }
        guard gesture.edges == .left else { return }

        settingsButtonPressed(gesture)
    }

    @IBAction func addTripButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.action, sender: nil)
    }

    @IBAction func settingsButtonPressed(_ sender: Any) {
        let navigationController = SettingsNavigationController.instantiate(from: .settings)

        present(navigationController, animated: true, completion: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.action {
            guard let navigationController = segue.destination as? UINavigationController else { return }
            guard let destinationViewController = navigationController.topViewController as? TripActionViewController else { return }
            destinationViewController.delegate = self
            destinationViewController.presenter = presenter

            if let trip = sender as? LedgitTrip {
                destinationViewController.method = .edit
                destinationViewController.trip = trip
            } else {
                destinationViewController.method = .add
            }

        } else if segue.identifier == Constants.SegueIdentifiers.detail {
            guard let destinationViewController = segue.destination as? TripDetailViewController else { return }
            guard let trip = sender as? LedgitTrip else { return }
            destinationViewController.title = trip.name
            destinationViewController.currentTrip = trip
        }
    }
}

extension TripsViewController: TripActionDelegate {
    func added(trip dict: NSDictionary) {
        presenter.createNew(trip: dict)
    }

    func edited(_ trip: LedgitTrip) {
        guard let index = presenter.trips.index(where: { $0.key == trip.key }) else { return }
        presenter.edited(trip)

        presenter.trips.remove(at: index)
        presenter.trips.insert(trip, at: index)

        guard let path = editingIndexPath else { return }
        tripsTableView.reloadRows(at: [path], with: .fade)
        editingIndexPath = nil
    }
}

extension TripsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.trips.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.trip, for: indexPath) as! TripTableViewCell //swiftlint:disable:this force_cast
        let trip = presenter.trips[indexPath.section]
        cell.configure(with: trip, at: indexPath)

        if trip.key == UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.defaultTrip) as? String && editingIndexPath == nil {
            self.tableView(tripsTableView, didSelectRowAt: indexPath)
        }

        // We are going to display a pop tip if the trip is a sample one
        if trip.key == Constants.ProjectID.sample && !UserDefaults.standard.bool(forKey: Constants.UserDefaultKeys.hasShownSampleTripTip) {
            UserDefaults.standard.set(true, forKey: Constants.UserDefaultKeys.hasShownSampleTripTip)
            let popTip = PopTip()
            popTip.style(PopStyle.default)
            popTip.shouldDismissOnTap = true
            popTip.show(text: "Check out this sample trip. Swipe left to remove.",
                        direction: .down, maxWidth: 300,
                        in: view, from: cell.frame, duration: 5)
        }

        return cell
    }
}

extension TripsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrip = presenter.trips[indexPath.section]

        performSegue(withIdentifier: Constants.SegueIdentifiers.detail, sender: selectedTrip)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let selectedSection = indexPath.section
        let trip = presenter.trips[selectedSection]

        let edit = UITableViewRowAction(style: .normal, title: "Edit") {  _, _ in
            self.editingIndexPath = indexPath
            self.performSegue(withIdentifier: Constants.SegueIdentifiers.action, sender: trip)
        }

        edit.backgroundColor = LedgitColor.coreYellow

        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { _, _ in

            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this trip?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in

                if selectedSection == 0 && (UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.sampleTrip) as? Bool) == true {
                    UserDefaults.standard.set(false, forKey: Constants.UserDefaultKeys.sampleTrip)
                }

                tableView.beginUpdates()
                self.presenter.removeTrip(at: selectedSection)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()

            }

            alert.addAction(cancelAction)
            alert.addAction(deleteAction)

            self.present(alert, animated: true, completion: nil)
        }

        if selectedSection == 0 && (UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.sampleTrip) as? Bool) == true {
            return [delete]
        } else {
            return [delete, edit]
        }
    }
}

extension TripsViewController: TripsPresenterDelegate {
    func retrievedSampleTrip() {
        tripsTableView.beginUpdates()
        tripsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
        tripsTableView.endUpdates()
    }

    func retrievedTrip() {
        tripsTableView.beginUpdates()
        tripsTableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .right)
        tripsTableView.endUpdates()

        var index: Double = 0
        tripsTableView.visibleCells.forEach { cell in
            cell.transform = CGAffineTransform(translationX: 0, y: tripsTableView.bounds.size.height)

            UIView.animate(withDuration: 1.5, delay: 0.05 * index, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)

            index += 1
        }
    }

    func addedTrip() {
        tripsTableView.reloadData()
    }
}
