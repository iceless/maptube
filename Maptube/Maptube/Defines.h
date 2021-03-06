//
//  Defines.h
//  Maptube
//
//  Created by John on 14-3-12.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#ifndef Maptube_Defines_h
#define Maptube_Defines_h

#pragma mark - Macro


#pragma mark - Constant
#define Map @"Map"
#define User @"User"
#define UserId @"UserId"
#define Description @"Description"
#define Secret @"Secret"
#define Category @"Category"
#define PlaceArray @"PlaceArray"
#define Title @"Title"
#define PlaceTitle @"title"
#define Place @"Place"
#define Longitude @"longitude"
#define Latitude @"latitude"
#define VenueID @"venueID"
#define VenueAddress @"venueAddress"
#define Distance @"distance"
#define CollectUser @"CollectUser"
#define CollectUserCount @"collectUserCount"
#define CollectMap @"CollectMap"
#define Author @"Author"
#define PlacePhotos @"placePhotos"
#define City @"city"

//#define MapId @"bluefeather.hkh8138o"


#define MapId @"wubingmapgis.i59ohpa8"
#define MapBoxAPI @"http://api.tiles.mapbox.com/v3/"

//http://api.tiles.mapbox.com/v3/{mapid}/{markers}/{lon},{lat},{z}/{width}x{height}.{format}
//http://api.tiles.mapbox.com/v3/{mapid}/geocode/{lon},{lat}.json
//The optional {markers} parameter can include one or more markers in a comma-separated list. See the Markers section for options

//markers: {name}-{label}+{color}({lon},{lat})
//color	 An 3 or 6 digit RGB hex color.
//name	 Marker shape and size.
//pin-s, pin-m, pin-l
#pragma mark - Notification
#define ModifyProfileNotification @"EditProfileNotification"
#define ModifyBoardNotification @"ModifyBoardNotification"
#define CloseChooseBoardNotification @"CloseChooseBoardNotification"
#define PopUpEditPlacePhotoNotification @"PopUpEditPlacePhotoNotification"
#define RefreshTableViewNotification @"RefreshTableViewNotification"

#endif
