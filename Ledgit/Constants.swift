//
//  Constants.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

enum Constants {
    static var fixerKey = "fda225b8e7deaacea241f2a705dc5681"

    struct ChartText {
        static let empty = "No trip expenses logged yet."
        static let noWeeklyActivity = """
                                Looks like you have no expenses this week.
                                Get out there and explore.
                                """
    }

    struct ProjectID {
        static let sample = "ledgit1234567890"
    }

    struct UserDefaultKeys {
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

    struct CellIdentifiers {
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

    struct NavigationIdentifiers {
        static let main = "MainNavigationController"
        static let trips = "TripsNavigationController"
        static let settings = "SettingsNavigationController"
    }

    struct SegueIdentifiers {
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

    struct LedgitEntity {
        static let user = "User"
        static let trip = "Trip"
        static let entry = "Entry"
    }

    static let tutorialContent: [LedgitTutorial] = [
        LedgitTutorial(color: LedgitColor.coreBlue,
                       image: #imageLiteral(resourceName: "tutorial-icon-0"), title: "Create New Trips",
                       description: "Add new trips as you need them"),
        LedgitTutorial(color: LedgitColor.lightPink,
                       image: #imageLiteral(resourceName: "tutorial-icon-1"), title: "Add Expenses Quickly",
                       description: "Quickly jot down your expense information"),
        LedgitTutorial(color: LedgitColor.lightAqua,
                       image: #imageLiteral(resourceName: "tutorial-icon-2"),
                       title: "Analyze Your Budget",
                       description: "Get intelligent reports of your expenses as your trip goes on")
    ]

    static let pageColors: [UIColor] = {
        return [
            LedgitColor.coreBlue,
            LedgitColor.lightPink,
            LedgitColor.lightAqua
        ]
    }()

    struct AuthenticateText {
        static let signin = "Sign in to see your trips."
        static let signup = "Sign up to get started."
        static let signinDescription = "or sign in using"
        static let signupDescription = "or sign up using"
    }

    struct CornerRadius {
        static let button: CGFloat  = 5
        static let tripCard: CGFloat = 5
    }

    struct FirebaseReference {
        static let trips = "trips"
        static let entries = "entries"
        static let users = "users"
    }
}
