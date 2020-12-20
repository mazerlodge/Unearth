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
	HexDirectionNE = 1,
	HexDirectionE = 2,
	HexDirectionSE = 3,
	HexDirectionSW = 4,
	HexDirectionW = 5,
	HexDirectionNW = 6
} HexDirection;

typedef enum OctDirection : NSUInteger {
	OctDirectionN = 0,
	OctDirectionNE = 1,
	OctDirectionE = 2,
	OctDirectionSE = 3,
	OctDirectionS = 4,
	OctDirectionSW = 5,
	OctDirectionW = 6,
} OctDirection;


#endif /* HexDirection_h */
