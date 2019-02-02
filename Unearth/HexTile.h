//
//  HexTile.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum HexTileType : NSUInteger {
    TileTypeStone = 0,
    TileTypeWonder = 1
} HexTileType;

@interface HexTile : NSObject {
	
	int baseID; 
    HexTileType tileType;
    
}

- (int) getBaseID;
- (HexTileType) getTileType;

/*
 Method list from [Object Library.txt]
 > HexTile
 - tileType             // One of Stone or Wonder

 */

@end
