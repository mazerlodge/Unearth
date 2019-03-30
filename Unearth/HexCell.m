//
//  HexCell.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "HexCell.h"

@implementation HexCell


- (id) initWithRow: (int) r Column: (int) c {
    
    rowY = r;
    columnX = c;
	pos = [[HexCellPosition alloc] initWithRow:r Column:c];
	
    return self;
    
}

- (int) getRowPosition {
	return rowY;
	
}
- (int) getColumnPosition {
	return columnX;
	
}

- (HexCellPosition *) getPosition {
	
	return pos;
	
}


- (void) setTile: (HexTile *) tile {
	
	hexTile = tile;
	
}

- (HexTile *) getTile {
	
	return hexTile;
}

- (bool) isWonder {
	// Return true if this cell contains a wonder tile.

	bool bRval = false;
	
	if ([hexTile getTileType] == HexTileTypeWonder)
		bRval = true;
	
	return bRval;
	
}

- (bool) isOccupied {
	// Return true if the cell contains a tile
	bool bRval = false;
	
	if (hexTile != nil)
		bRval = true;
	
	return bRval;
	
}

- (bool) isAtRow: (int) targetRow Column: (int) targetColumn {
	// Return true if this cell is at the specified position.
	bool bRval = false;
	
	if ((rowY == targetRow)
		&& (columnX == targetColumn))
		bRval = true;
	
	return bRval;
	
}

- (NSString *) toString {
	// Supports diagnostic and debug printing
	
	// If occupied, output stone identifying information
	NSString *occupiedMessage = @"unoccupied";
	if ([self isOccupied]) {
		occupiedMessage = [hexTile toString];
		
	}
	NSString *rval = [[NSString alloc] initWithFormat:@"HexCell at (%d, %d) occupied by (%@)",
					  									columnX,
														rowY,
														occupiedMessage];
	
	return rval;
	
}


@end
