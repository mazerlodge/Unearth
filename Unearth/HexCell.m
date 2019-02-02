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
    
    row = r;
    column = c;
    
    return self;
    
}

- (int) getRowPosition {
	return row;
	
}
- (int) getColumnPosition {
	return column;
	
}

- (void) setTile: (HexTile *) tile {
	
	hexTile = tile;
	
}

- (bool) isWonder {
	// Return true if this cell contains a wonder tile.

	bool bRval = false;
	
	if ([hexTile getTileType] == TileTypeWonder)
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
	
	if ((row == targetRow)
		&& (column == targetColumn))
		bRval = true;
	
	return bRval;
	
}

- (NSString *) toString {
	// Supports diagnostic and debug printing
	NSString *rval = [[NSString alloc] initWithFormat:@"HexCell at (%d, %d) occupied (%d)\n",
					  									row, column, [self isOccupied]];
	
	return rval;
	
}


@end
