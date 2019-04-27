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
#import "HexDirection.h"

@interface HexMap : NSObject {

	int occupiedCells;
	int emptyCells;
	int minRow;
	int maxRow;
	int minCol;
	int maxCol;

	CommandLineInterface *cli;
	NSArray *hexCells;
    
}

+ (NSString *) HexDirectionToString: (HexDirection) direction;

- (id) init;
- (id) initWithCLI: (CommandLineInterface *) commandLineInterface;

- (HexCell *) getOriginHexCell;
- (HexCell *) getHexCellAtRow: (int) row Column: (int) column;
- (HexCell *) getHexCellHoldingTileBaseID: (int) baseID;
- (HexCell *) getHexCellAtPosition: (HexCellPosition *) position;

- (NSArray *) getAvailableHexCells;

- (bool) isPositionValid: (HexCellPosition *) position;

- (bool) addStone: (Stone *) s atHexCell: (HexCell *) c;
- (bool) addWonder: (Wonder *) w atHexCell: (HexCell *) c;

- (bool) addStone: (Stone *) s touchingHexCell: (HexCell *) c onSide: (HexDirection) direction;
- (bool) addWonder: (Wonder *) w touchingHexCell: (HexCell *) c onSide: (HexDirection) direction;

- (void) drawMap;

/*
 Method list from [Object Library.txt]
 > HexMap
 - hexCells            // grid of hex cells used to hold acquired hex tiles (stones and wonders).

 */

@end
