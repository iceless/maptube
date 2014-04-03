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
#define Place @"Place"
#define Longitude @"Longitude"
#define Latitude @"Latitude"
#define VenueID @"VenueID"
#define VenueAddress @"VenueAddress"
#define Distance @"Distance"
#define CollectUser @"CollectUser"
#define CollectMap @"CollectMap"
#define Author @"Author"

#define MapId @"bluefeather.hkh8138o"
#define MapBoxPictureAPI @"http://api.tiles.mapbox.com/v3/"
//http://api.tiles.mapbox.com/v3/{mapid}/{markers}/{lon},{lat},{z}/{width}x{height}.{format}
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

#endif
