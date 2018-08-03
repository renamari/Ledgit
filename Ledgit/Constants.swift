//
//  Constants.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

struct Constants {
    static var fixerKey = "fda225b8e7deaacea241f2a705dc5681"
    
    struct chartText {
        static let empty = "No trip expenses logged yet."
        static let noWeeklyActivity = """
                                Looks like you have no expenses this week.
                                Get out there and explore.
                                """
    }
    
    struct projectID {
        static let sample = "ledgit1234567890"
    }
    
    struct userDefaultKeys {
        static let hasShowFirstWeeklyCellTips = "hasShowFirstWeeklyCellTips"
        static let hasShownFirstCategoryCellTips = "hasShownFirstCategoryCellTips"
        static let hasShownFirstHistoryCellTips = "hasShownFirstHistoryCellTips"
        static let hasShownFirstTripTips = "hasShownFirstTripTips"
        static let hasShownSampleTripTip = "hasShownSampleTripTip"
        static let lastRates = "lastRates"
        static let lastUpdated = "lastUpdated"
        static let sampleTrip = "needsSampleTrip"
        static let defaultTrip = "defaultTrip"
        static let uid = "uid"
        static let homeCurrency = "homeCurrency"
    }
    
    struct cellIdentifiers {
        static let trip = "TripCell"
        static let add = "AddTripCell"
        static let settings = "SettingsCell"
        static let weekly = "WeeklyCell"
        static let category = "CategoryCell"
        static let history = "HistoryCell"
        static let city = "CityCell"
        static let date = "DateCell"
        static let categoryName = "CategoryNameCell"
        static let currency = "CurrencyCell"
    }
    
    struct navigationIdentifiers{
        static let main = "MainNavigationController"
        static let trips = "TripsNavigationController"
        static let settings = "SettingsNavigationController"
    }

    struct segueIdentifiers {
        static let authenticate = "toAuthenticateViewController"
        static let trips = "toTripsViewController"
        static let settings = "toSettingsViewController"
        static let addTrip = "toAddTripViewController"
        static let action = "toTripActionViewController"
        static let detail = "toTripDetailViewController"
        static let category = "toCategoriesViewController"
        static let subscription = "toSubscriptionViewController"
        static let account = "toAccountViewController"
        static let about = "toAboutViewController"
        static let categoryAction = "toCategoryActionViewController"
        static let entryAction = "toAddEntryViewController"
        static let currencySelection = "toCurrencySelectionViewController"
        static let categorySelection = "toCategorySelectionViewController"
    }
    
    struct ledgitEntity {
        static let user = "User"
        static let trip = "Trip"
        static let entry = "Entry"
    }
    
    static let pageColors: [UIColor] = {
        return [
            LedgitColor.coreBlue,
            LedgitColor.lightPink,
            LedgitColor.lightAqua
        ]
    }()
    
    static let pageTitles: [String] = {
        return [
            "Create New Trips",
            "Add Expenses Quickly",
            "Analyze Your Budget"
        ]
    }()
    
    static let pageDescriptions: [String] = {
        return [
            "Add new trips quickly in advanced or in the moment",
            "Quickly jot down your expense information",
            "Get intelligent reports of your expenses as your trip goes on"
        ]
    }()
    
    static let pageImages: [UIImage] = {
        return [#imageLiteral(resourceName: "tutorial-icon-0"),#imageLiteral(resourceName: "tutorial-icon-1"),#imageLiteral(resourceName: "tutorial-icon-2")]
    }()

    struct authenticateText {
        static let signin = "Sign in to see your trips."
        static let signup = "Sign up to get started."
        static let signinDescription = "or sign in using"
        static let signupDescription = "or sign up using"
    }
    
    struct scales {
        static let cellWidth: CGFloat = 0.90
        static let cellHeight: CGFloat = 0.98
    }
    
    struct cornerRadius {
        static let button: CGFloat  = 5
        static let tripCard: CGFloat = 5
    }
    
    struct firebaseReference {
        static let trips = "trips"
        static let entries = "entries"
        static let users = "users"
    }
}
