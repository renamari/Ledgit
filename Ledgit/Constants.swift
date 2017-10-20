//
//  Constants.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit

struct Constants {
    struct ProjectID {
        static let sample = "-KrcJuMyMi0EtFAlpAlf"
    }
    
    struct UserDefaultKeys{
        static let sampleProject = "needsSampleProject"
        static let uid = "uid"
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
    }
    
    struct NavigationIdentifiers{
        static let main = "MainNavigationController"
        static let trips = "TripsNavigationController"
        static let settings = "SettingsNavigationController"
    }

    struct SegueIdentifiers {
        static let authenticate = "toAuthenticateViewController"
        static let trips = "toTripsViewController"
        static let settings = "toSettingsViewController"
        static let add = "toAddTripViewController"
        static let detail = "toTripDetailViewController"
        static let category = "toCategoriesViewController"
        static let subscription = "toSubscriptionViewController"
        static let account = "toAccountViewController"
        static let about = "toAboutViewController"
        static let categoryAction = "toCategoryActionViewController"
        static let addEntry = "toAddEntryViewController"
    }
    
    struct TutorialTitles {
        static let first = "Create New Trips"
        static let second = "Add Expenses Quickly"
        static let third = "Analyze Your Budget"
    }
    
    struct TutorialDescriptions {
        static let first = "Get a unique ID and attach it to an item, and link it in the app"
        static let second = "When you lose an item, mark it as lost through the app"
        static let third = "When you find an item, report the ID to notify the owner"
    }
    
    struct AuthenticateText {
        static let signin = "Sign in to see your trips."
        static let signup = "Sign up to get started."
        static let signinDescription = "or sign in using"
        static let signupDescription = "or sign up using"
    }
    
    struct Scales {
        static let cellWidth: CGFloat = 0.90
        static let cellHeight: CGFloat = 0.98
    }
    
    struct CornerRadius {
        static let button: CGFloat  = 10
    }
    
    struct FirebaseReference{
        static let trips = "trips"
        static let entries = "entries"
        static let users = "users"
    }
    
    struct ClientErrorMessages {
        static let emptyUserPasswordTextFields = ["title": "Could Not Sign In","message":"Email/password fields are empty."]
        static let emptyTextFields = ["title": "Oops","message":"Make sure sure to fill out all text fields to continue"]
        static let invalidUserPasswordTextFields = ["title": "Could Not Create Account", "message": "The email or password is invalid. Please try again."]
        static let iPhoneTryUpload = ["title": "Can't Add Custom Image", "message": "Sorry, changing image is not available on this phone."]
        static let noNetworkConnection = ["title": "Error", "message": "Your phone isn't connected to the internet, make sure you have a working connection and try again later."]
        static let confirmDeleteTrip = ["title": "Warning", "message": "Are you sure you want to delete this trip?"]
        static let noCameraAvailable = ["title": "Warning", "message": "You don't have a camera."]
        static let authenticationError = ["title":"Error", "message":"Something went wrong with Facebook authentication. Please try again."]
        static let resetInstructionsSent = ["title":"Hooray", "message":"We sent you an email to reset your password."]
        static let cannotAddEntriesToSample = ["title":"Not So Fast","message":"You can't add entries to this sample project. Go back and create one if you haven't done so already."]
    }
    
    struct AuthErrorMessages {
        static let cancelled = ["title": "Hmmm...", "message": "It looks like you cancelled, try again or select another method."]
        static let general = ["title": "Could Not Sign In", "message": "Error getting your information. Please try again later."]
        static let userDisabled = ["title": "Could Not Sign In", "message": "Error getting your information. Please try again later."]
        static let operationNotAllowed = ["title": "Could Not Sign In", "message": "Error getting your information. Please try again later."]
        static let emailAlreadyInUse = ["title": "Hold on a sec...", "message": "Email is already being used. Please try using a different one."]
        static let invalidEmail = ["title": "Could Not Sign In", "message": "Invalid email, try again."]
        static let wrongPassword = ["title": "Could Not Sign In", "message": "Invalid password, try again."]
        static let userNotFound = ["title": "Could Not Sign In", "message": "User with these credentials not found. Sign up and make a new account."]
        static let weakPassword = ["title": "Could Not Create Account", "message": "That is a weak password. Try using uppercase/lowercase/special characters."]
        static let invalidCredential = ["title": "Could Not Sign In With Facebook", "message": "Error getting your information. Please try again later."]
    }
    
}
