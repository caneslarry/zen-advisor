//
//  config.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 11/23/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

struct configs {
    
    static var mainUrl:String = "http://www.zen-advisor.com/zenadmin/index.php/rest"
    //static var mainUrl:String = "http://192.168.43.52:7777/citiesdirectory/index.php/rest"
    
    static var imageUrl:String = "http://www.zen-advisor.com/zenadmin/uploads/"
    //static var imageUrl:String = "http://192.168.43.52:7777/citiesdirectory/uploads/"

    static let getCities                = "/cities/get"
    static let getCitiesByGeo                = "/cities/getByGeo/userLat/%f/userLong/%f"
    static let getCityByID              = "/cities/get/id/%d"
    static let itemsBySubCategory       = "/items/get/city_id/%d/sub_cat_id/%d/item/all/count/%d/from/%d"
    static let allItemsBySubCategory    = "/items/get/city_id/%d/sub_cat_id/%d/item/all/"
    static let itemById                 = "/items/get/id/%d/city_id/%d"
    static let searchByGeo              = "/items/search_by_geo/miles/%f/userLat/%f/userLong/%f/city_id/%d/sub_cat_id/%d"
    static let userLogin                = "/appusers/login"
    static let getFavouriteItems        = "/items/user_favourites/user_id/%d/count/%d/from/%d"
    static let addItemInquiry           = "/items/inquiry/id/%d"
    static let addItemReview            = "/items/review/id/%d"
    static let addAppUser               = "/appusers/add"
    static let resetPassword            = "/appusers/reset"
    static let updateAppUser            = "/appusers/update/id/%d"
    static let profilePhotoUpload       = "/images/upload"
    static let addItemLike              = "/items/like/id/%d"
    static let isLikedItem              = "/items/is_like/id/%d"
    static let isFavouritedItem         = "/items/is_favourite/id/%d"
    static let addItemFavourite         = "/items/favourite/id/%d"
    static let addItemTouch             = "/items/touch/id/%d"
    static let getNewsFeedByCityId      = "/cities/feeds/city_id/%d"
    static let searchByKeyword          = "/items/search/city_id/%d"
    static let registerPushNoti         = "/gcm/register"
    
    static var pageSize:Int = 7
    static var barColorCode = "#469d31"
    
    // Connection timeout Interval seconds
    static var timeoutInterval = 5
    
    // iAds flag
    static var showAdvs = true // true or false
}

struct language {
    static var LoginTitle              = "Login"
    static var blankInputLogin         = "Please provide your login credential."
    static var emailValidation         = "Please check your email format."
    static var loginNotSuccessMessage  = "Sorry, please try again to login in."
    static var profileUpdate           = "Profile Update"
    static var doNotMatch              = "New Passwrod and Confirm Password do not match."
    static var reviewTitle             = "Review"
    static var reviewEmpty             = "Please type your review"
    static var inquiryTitle            = "Inquiry"
    static var inquiryEmpty            = "Please provide necesssary input"
    static var typeInquiryMessage      = "Please type inquiry here..."
    static var typeReviewMessage       = "Please type review here..."
    static var inquirySentSuccess      = "Inquiry has been sent succesfully"
    static var somethingWrong          = "API response something wrong. Please try agian."
    static var currentLocation         = "Current Location"
    static var geocoderProblem         = "Oops! Problem to get your location information."
    static var searchTitle             = "Search"
    static var itemNotFount            = "Sorry, ZenSpots are not found. Please search again."
    static var allowLocationService    = "Please allow location service."
    static var homePageTitle           = "Zen-Advisor"
    static var searchPageTitle         = "Find Zen by Keyword"
    static var profilePageTitle        = "Profile"
    static var registerTitle           = "Register"
    static var userInputEmpty          = "Please provide necessary user information."
    static var registerSuccess         = "Your account registeration is successful."
    static var resetTitle              = "Forgot Password"
    static var resetSuccess            = "Next instruction has been sent to your registerred email."
    static var userEmailEmpty          = "Please provide your registered email."
    static var tryAgainToConnect       = "Oops! Server could not response. Please try again."
    static var networkError            = "Oops! Can't connect to internet"
    static var imageIsNull             = "Oops! selected image is blank."
    static var itemMapTitle            = "Map View"
    static var noLatLng                = "There is no latitude and longitude for this item. Please provide it."
    static var shareMessage            = "This ZenSpot is Amazing!"
    static var fbLogin                 = "Please login to a Facebook account to share."
    static var twLogin                 = "Please login to a Twitter account to share."
    static var btnOK                   = "OK"
    static var accountLogin            = "Account Login"
    static var categories              = "Categories : "
    static var subCategories           = " | Sub Categories : "
    static var selectedCityPageTitle   = "ZenSpots in "
    static var itemsPageTitle          = "Find your ZenSpot"
    static var itemDetailPageTitle     = "ZenSpot Detail"
    static var shareOn                 = "Share"
    static var tweetOn                 = "Tweet"
    static var viewOnMap               = "View"
    static var inquiryPageTitle        = "Contact ZenSpot"
    static var reviewListPageTitle     = "Reviews List"
    static var submit                  = "Submit"
    static var reviewEntryPageTitle    = "Submit Review"
    static var feedListPageTitle       = "News Feed From City"
    static var feedDetailPageTitle     = "News Feed Detail"
    static var mapExplorePageTitle     = "Explore On Map"
    static var itemMapPageTitle        = "Item Location"
    static var sliderPageTitle         = "Item Images"
    static var favouritePageTitle      = "My Favorite ZenSpots"
    static var homeMenu                = "Home"
    static var searchMenu              = "Search By Keyword"
    static var ProfileMenu             = "Profile"
    static var favouriteMenu           = "My Favorite ZenSpots"
    static var logoutMenu              = "Logout"
    static var forgotTitle             = "Request Forgot Password"
    static var loginRequireTitle       = "Login Required"
    static var loginRequireMesssage    = "You need to login first to do this action."
    static var noCities                = "There is no available city in the system. Please add from Backend."
    static var profilePhotoUploaded    = "Profile photo successfully updated."
    static var mileRange               = "Miles Range : "
    static var miles                   = " miles"
    static var shareURL                = "https://zen-advisor.com/listings/"
}

struct notiKey {
    static var deviceIDKey = "DEVICE_ID"
    static var deviceTokenKey = "TOKEN"
    static var isRegister = "IS_REGISTER"
    static var notiMessageKey = "NOTI_MSG"
    static var devicePlatform = "IOS"
}

struct customFont{
    static var boldFontName                 = "Monda-Bold"
    static var boldFontSize                 = 18
    static var normalFontName               = "Monda-Regular"
    static var normalFontSize               = 18
    static var tableHeaderFontSize          = 15
    static var pickerFontSize               = 14
}

