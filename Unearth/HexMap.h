//
//  HexMap.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HexCell.h"
#import "Stone.h"
#import "Wonder.h"
#import "CommandLineInterface.h"

typedef enum HexDirection : NSUInteger {
    HexDirectionN = 0,
    HexDirectionNE = 1,
    HexDirectionE = 2,
    HexDirectionSE = 3,
    HexDirectionS = 4,
    HexDirectionSW = 5,
    HexDirectionW = 6,
    HexDirectionNW = 7
} HexDirection;

@interface HexMap : NSObject {

	CommandLineInterface *cli;

	NSArray *hexCells;
    
}

- (id) init;

- (HexCell *) getOriginHexCell;
- (HexCell *) getHexCellAtRow: (int) row Column: (int) column;

- (NSArray *) getAvailableHexCells;

- (bool) addStone: (Stone *) s atHexCell: (HexCell *) c;
- (bool) addWonder: (Wonder *) w atHexCell: (HexCell *) c;

- (bool) addStone: (Stone *) s touchingHexCell: (HexCell *) c onSide: (HexDirection) direction;
- (bool) addWonder: (Wonder *) w touchingHexCell: (HexCell *) c onSide: (HexDirection) direction;

/*
 Method list from [Object Library.txt]
 > HexMap
 - hexCells            // grid of hex cells used to hold acquired hex tiles (stones and wonders).

 */

@end
