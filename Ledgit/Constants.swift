//
//  Constants.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

struct Constants {
    struct chartText {
        static let empty = "Wow, such empty 😿"
    }
    
    struct projectID {
        static let sample = "ledgit1234567890"
    }
    
    struct userDefaultKeys {
        static let sampleTrip = "needsSampleTrip"
        static let uid = "uid"
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
    
    struct clientErrorMessages {
        
        static let freeSubscriptions = [
            "title": "Hooray For You!",
            "message": "We're still testing this feature, so for now everything is free. Enjoy 😉"
        ]
        
        static let emptyUserPasswordTextFields = [
            "title": "Could Not Sign In",
            "message":"Email/password fields are empty."
        ]
        
        static let emptyTextFields = [
            "title": "Oops",
            "message":"Make sure sure to fill out all text fields to continue"
        ]
        
        static let invalidUserPasswordTextFields = [
            "title": "Could Not Create Account",
            "message": "The email or password is invalid. Please try again."
        ]
        
        static let iPhoneTryUpload = [
            "title": "Can't Add Custom Image",
            "message": "Sorry, changing image is not available on this phone."
        ]
        
        static let noNetworkConnection = [
            "title": "Error",
            "message": "Your phone isn't connected to the internet, make sure you have a working connection and try again later."
        ]
        
        static let confirmDeleteTrip = [
            "title": "Warning",
            "message": "Are you sure you want to delete this trip?"
        ]
        
        static let noCameraAvailable = [
            "title": "Warning",
            "message": "You don't have a camera."
        ]
        
        static let authenticationError = [
            "title": "Error",
            "message": "Something went wrong with Facebook authentication. Please try again."
        ]
        
        static let resetInstructionsSent = [
            "title": "Hooray",
            "message": "We sent you an email to reset your password."
        ]
        
        static let cannotAddEntriesToSample = [
            "title": "Not So Fast",
            "message": "You can't add entries to this sample trip. Go back and create one if you haven't done so already."
        ]
        
        static let errorGettingTrip = [
            "title": "Please Excuse Us",
            "message": "We had some trouble getting your trip details. Try again later."
        ]
        
        static let errorGettingEntry = [
            "title": "Please Excuse Us",
            "message": "We had some trouble getting your entry details. Try again later."
        ]
    }
    
    struct authErrorMessages {
        static let coreDataFault = [
            "title": "Error",
            "message": "Could not create your initial account. Sorry about that!"
        ]
        
        static let cancelled = [
            "title": "Hmmm...",
            "message": "It looks like you cancelled, try again or select another method."
        ]
        
        static let general = [
            "title": "Could Not Sign In",
            "message": "Error getting your information. Please try again later."
        ]
        
        static let userDisabled = [
            "title": "Could Not Sign In",
            "message": "Error getting your information. Please try again later."
        ]
        
        static let operationNotAllowed = [
            "title": "Could Not Sign In",
            "message": "Error getting your information. Please try again later."
        ]
        
        static let emailAlreadyInUse = [
            "title": "Hold on a sec...",
            "message": "Email is already being used. Please try using a different one."
        ]
        
        static let invalidEmail = [
            "title": "Could Not Sign In",
            "message": "Invalid email, try again."
        ]
        
        static let wrongPassword = [
            "title": "Could Not Sign In",
            "message": "Invalid password, try again."
        ]
        
        static let userNotFound = [
            "title": "Could Not Sign In",
            "message": "User with these credentials not found. Sign up and make a new account."
        ]
        static let weakPassword = [
            "title": "Could Not Create Account",
            "message": "That is a weak password. Try using uppercase/lowercase/special characters."
        ]
        
        static let invalidCredential = [
            "title": "Could Not Sign In With Facebook",
            "message": "Error getting your information. Please try again later."
        ]
    }
    
}
