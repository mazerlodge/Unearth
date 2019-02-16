//
//  HexTile.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "HexTile.h"

@implementation HexTile


+ (NSString *) HexTileTypeToString: (HexTileType) aTileType {
	
	NSString *rval;
	
	switch(aTileType) {
		case HexTileTypeWonder:
			rval = @"Wonder";
			break;
		
		case HexTileTypeStone:
			rval = @"Stone";
			break;
		
		default:
			rval = @"Unknown";
			break;
			
	}
	
	return rval;
	
}

- (int) getBaseID {
	
	return baseID;
	
}

- (HexTileType) getTileType {

	return tileType;
	
}


- (NSString *) toString {
	// Supports diagnostic and debug printing
	NSString *rval = [[NSString alloc] initWithFormat:@"HexTile type=%@ baseID=%d\n",
					  [HexTile HexTileTypeToString:tileType],
					  baseID];
	
	return rval;
	
}


@end
