//
//  HexDirection.h
//  Unearth
//
//  Created by Paul Sorenson on 2/16/19.
//  Copyright © 2019 mazerlodge. All rights reserved.
//

// NOTE: Method to convert this enum to a string is in HexMap.
//		 + (NSString *) HexDirectionToString: (HexDirection) direction

#ifndef HexDirection_h
#define HexDirection_h


typedef enum HexDirection : NSUInteger {
	HexDirectionNotSet = 0,
	HexDirectionNE = 1,
	HexDirectionE = 2,
	HexDirectionSE = 3,
	HexDirectionSW = 4,
	HexDirectionW = 5,
	HexDirectionNW = 6
} HexDirection;


#endif /* HexDirection_h */
