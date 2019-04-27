//
//  HexMap.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "HexMap.h"

@implementation HexMap

- (id) init {
	
	cli = [[CommandLineInterface alloc] init];
    HexCell *aCell = [[HexCell alloc] initWithRow:50 Column:50];
    hexCells = [[NSArray alloc] initWithObjects:aCell, nil];

    return self;
    
}


- (id) initWithCLI: (CommandLineInterface *) commandLineInterface {
	
	cli = commandLineInterface;
	HexCell *aCell = [[HexCell alloc] initWithRow:50 Column:50];
	hexCells = [[NSArray alloc] initWithObjects:aCell, nil];
	
	return self;
	
}

+ (NSString *) HexDirectionToString: (HexDirection) direction {
	
	NSString *rval;
	
	switch(direction) {
		case HexDirectionNE:
			rval = @"NE";
			break;
			
		case HexDirectionE:
			rval = @"E";
			break;
			
		case HexDirectionW:
			rval = @"W";
			break;
			
		case HexDirectionNW:
			rval = @"NW";
			break;
			
		case HexDirectionSE:
			rval = @"SE";
			break;
			
		case HexDirectionSW:
			rval = @"SW";
			break;
			
		default:
			rval = @"Unknown";
			break;
			
	}
	
	return rval;
	
}

- (HexCell *) getOriginHexCell {
	// Return the origin hex cell, it was loaded at index 0 during init.
	return [hexCells objectAtIndex:0];
	
}

- (HexCell *) getHexCellAtRow: (int) row Column: (int) column {
	// Return the cell with the specified position, create it if it doesn't exist.
	HexCell *rval;

	for (HexCell *aCell in hexCells) {
		if ([aCell isAtRow:row Column:column]) {
			rval = aCell;
			break;
		}
	}
	
	// if the cell wasn't found above, create it and add it to the hexCells array.
	if (rval == nil) {
		rval = [[HexCell alloc] initWithRow:row Column:column];
		hexCells = [hexCells arrayByAddingObject:rval];

	}
	
	return rval;
	
}


- (HexCell *) getHexCellAtPosition: (HexCellPosition *) position {
	// Return the cell with the specified position, create it if it doesn't exist.
	HexCell *rval;
	
	int row = [position getRow];
	int column = [position getColumn];
	
	for (HexCell *aCell in hexCells) {
		if ([aCell isAtRow:row Column:column]) {
			rval = aCell;
			break;
		}
	}
	
	// if the cell wasn't found above, create it and add it to the hexCells array.
	if (rval == nil) {
		rval = [[HexCell alloc] initWithRow:row Column:column];
		hexCells = [hexCells arrayByAddingObject:rval];
		
	}
	
	return rval;
	
}


- (HexCell *) getHexCellHoldingTileBaseID: (int) baseID {
	
	HexCell *rval;
	
	for (HexCell *aCell in hexCells)
		if ([aCell isOccupied]) {
			HexTile *aTile = [aCell getTile];
			if ([aTile getBaseID] == baseID)
				// if the cell contains the target tile ID, return the cell (not the tile)
				rval = aCell;
		}
	
	return rval;
}

- (NSArray *) getAvailableHexCells {
	// Return an array of the currently reachable hex cells.
	NSArray *rval = [[NSArray alloc] init];
	
	if ([hexCells count] == 1) {
		// Only the origin cell is available
		rval = hexCells;
	}
	else {
		// Evaluate only occupied cells, returning neighbors where a stone could be placed.
		for (HexCell *aCell in hexCells) {
			if ([aCell isOccupied])
				rval = [rval arrayByAddingObjectsFromArray:[self getNeighborCells:aCell
																   onlyUnoccupied:true]];
			
		}
	}
	
	return rval; 
	
} 

- (NSArray *) getNeighborCells: (HexCell *) hexCell onlyUnoccupied: (bool) bOnlyUnoccupied {
	// Return an array of the cells around to the specified cell
	
	NSArray *rval = [[NSArray alloc] init];
	
	// Based on "x-in, y-down" (columnX and rowY, respectively)
	const int NEIGHBOR_X_OFFSETS[] = {-1,  1, -2, 2, -1, 1};
	const int NEIGHBOR_Y_OFFSETS[] = {-1, -1,  0, 0,  1, 1};
	const int NEIGHBOR_SIZE = 6;

	int originX = [hexCell getColumnPosition];
	int originY = [hexCell getRowPosition];
	
	for (int i=0; i<NEIGHBOR_SIZE; i++) {
		int nCol = originX + NEIGHBOR_X_OFFSETS[i];
		int nRow = originY + NEIGHBOR_Y_OFFSETS[i];
		
		HexCell *nCell = [self getHexCellAtRow:nRow Column:nCol];
		if (bOnlyUnoccupied) {
			// only return the cell if it isn't already occupied
			if (![nCell isOccupied])
				rval = [rval arrayByAddingObject:nCell];
		}
		else {
			rval = [rval arrayByAddingObject:nCell];

		}
	}
	
	return rval;
	
}

- (bool) isCellInMap: (HexCell *) cell {

	bool bRval = false;
	
	for (HexCell *aCell in hexCells) {
		if ([[aCell getPosition] positionEquals: [cell getPosition]]) {
			bRval = true;
			break;
		}
	}
	
	return bRval;
	
}

- (bool) isPositionValid: (HexCellPosition *) position {
	// Cell columns are odd in odd rows, even in even rows.
	// Return false if this rule isn't followed for the specified position.
	bool bRval = false;

	int xCol = [position getColumn];
	int yRow = [position getRow];
	
	if (xCol % 2 == yRow % 2)
		bRval = true;
	
	return bRval;
	
}


- (bool) addNeighborsToCell: (HexCell *) cell {
	
	bool bRval = true;
	
	NSArray *neighborCells = [self getNeighborCells:cell onlyUnoccupied:true];
	
	for (HexCell *nCell in neighborCells) {
		// Note: A bit obtuse, but getHexCellAtRow_Column creates the cell if it didn't exist
		// Only create the cell if it isn't already in the map.
		if (![self isCellInMap:nCell])
			[self getHexCellAtRow:[nCell getRowPosition] Column:[nCell getColumnPosition]];
	}
	
	return bRval;
	
}

- (bool) addStone: (Stone *) stone atHexCell: (HexCell *) cell {
	bool bRval = false;
	
	NSString *msg = [NSString stringWithFormat:@"In map.addStone_atHexCell with Stone=(%@) at HexCell=(%@)\n",
					 							[stone toString],
					 							[cell toString]];
	[cli debugMsg:msg level:4];
	
	[cell setTile:stone];
	
	// Add new neighboring cells when adding a stone (only unoccupied b/c occupied would already exist).
	[self addNeighborsToCell:cell];
	
	return bRval;
	
}

- (bool) addStone: (Stone *) s touchingHexCell: (HexCell *) c onSide: (HexDirection) direction {
	// Add the specified stone in the cell touching the specified cell on the side specified.
	
	bool bRval = false;
    
	NSString *methodName = @"map.addStone_touchingHexCell_onSide";
	NSString *msg = [NSString stringWithFormat:@"%@ at cell (%@) with Stone %d and direction=(%@)\n",
					 methodName,
					 [c toString],
					 [s getStoneID],
					 [HexMap HexDirectionToString:direction]];
	[cli debugMsg:msg level:4];

	HexCellPosition *basePosition = [c getPosition];
	HexCellPosition *targetPosition = [HexCellPosition getPosAtDirection:direction
															fromPosition:basePosition];
	
	HexCell *targetCell = [self getHexCellAtPosition:targetPosition];
	[targetCell setTile:s];
	
	// Expand map by adding neighbors to the new cell
	[self addNeighborsToCell:targetCell];
	
    return bRval;
    
}

- (bool) addWonder: (Wonder *) w atHexCell: (HexCell *) c {
	bool bRval = false;
	
	NSString *msg = [NSString stringWithFormat:@"In addWonder atHexCell with Stone %d\n", [w getBaseID]];
	[cli put:msg];
	
	// TODO: Flesh out Hex Map addWonder method.
	NSLog(@"map.addWonder_atHexCell() WARNING: Not yet implemented.");

	// Note: don't need to call addNeighborsToCell, wonders can only be added when already surrounded by occupied neighbors

	return bRval;
	
}

- (bool) addWonder: (Wonder *) w touchingHexCell: (HexCell *) c onSide: (HexDirection) direction {
    bool bRval = false;

	NSString *msg = [NSString stringWithFormat:@"In addWonder with Wonder %d\n", [w getBaseID]];
	[cli put:msg];
	
	// TODO: Flesh out Hex Map addWonder w/ 'touching' param method.
	NSLog(@"map.addWonder_touchingHexCell_onSide() WARNING: Not yet implemented.");

	// Note: don't need to call addNeighborsToCell, wonders can only be added when already surrounded by occupied neighbors

    return bRval;
    
}

- (void) updateStats {
	
	occupiedCells = 0;
	emptyCells = 0;
	minRow = 999;
	maxRow = -1;
	minCol = 999;
	maxCol = -1;
	
	for (HexCell *aCell in hexCells) {
		if ([aCell isOccupied])
			occupiedCells++;
		else
			emptyCells++;
		
		minRow = ([aCell getRowPosition] < minRow) ? [aCell getRowPosition] : minRow;
		maxRow = ([aCell getRowPosition] > maxRow) ? [aCell getRowPosition] : maxRow;
		minCol = ([aCell getColumnPosition] < minCol) ? [aCell getColumnPosition] : minCol;
		maxCol = ([aCell getColumnPosition] > maxCol) ? [aCell getColumnPosition] : maxCol;
		
	}
}

- (NSString *) generateStatsMessage {
	// Quick stats message generation
	[self updateStats];
	
	NSString *msg = [NSString stringWithFormat:@"In drawMap with %ld cells in the map (%d used, %d empty).\n",
					 [hexCells count],
					 occupiedCells,
					 emptyCells];

	msg = [msg stringByAppendingFormat:@"min/max used columnsX & rowsY are Xm=%d, Xmax=%d, Ym=%d, Ymax=%d.\n",
					 minCol,
					 maxCol,
					 minRow,
					 maxRow];

	return msg;
	
}

- (void) drawMap {
	
	// TODO: Implement drawMap by composing text lines to send to CLI.
	[cli debugMsg:@"QIn HexMap.drawMap()" level:5];
	[cli put:[self generateStatsMessage]];

	// Display cells as text
	for (HexCell *aCell in hexCells)
		[cli debugMsg:[aCell toString] level:4];
	
	// output the cell's positions in order by position.
	for (int y=minRow; y<=maxRow; y++) {
		NSString *currentRow = @"";
		for (int x=minCol; x<=maxCol; x++) {
			
			// Only proceed if the position is valid
			HexCellPosition *cellPos = [[HexCellPosition alloc] initWithRow:y Column:x];
			if ([self isPositionValid:cellPos]) {
				// just because a position is b/n min & max doesn't mean it exists in array
				// but getting it will add it.
				HexCell *currentCell = [self getHexCellAtRow:y Column:x];
				
				// add this cell to the current row
				currentRow = [currentRow stringByAppendingFormat:@" %@ ",
							  [[currentCell getPosition] toString]];
			
			} // if cellPos valid
			
		} // x
		
		[cli put:currentRow withNewline:true];
	} // y

	[self drawACell:hexCells[0]];

}

- (void) drawACell: (HexCell *) cell {
	
	/*
	 The borders of the cell to draw are dependent on the following rules:
	 Always print NW, NE, and W
	 Last row prints SW, SE
	 First column prints SW
	 Last Column but not Last Row prints SE
	 
	*/
	
	
	NSString *r1 = @"  / \\  ";
	NSString *r2 = @" /   \\ ";
	NSString *r3 = [[NSString alloc] initWithFormat:@"| %d  |", [cell getColumnPosition]];
	NSString *r4 = [[NSString alloc] initWithFormat:@"| %d  |", [cell getRowPosition]];
	NSString *r5 = @" \\   / ";
	NSString *r6 = @"  \\ /  ";
	
	NSArray *rArray = [[NSArray alloc] initWithObjects:r1, r2, r3, r4, r5, r6, nil];
	for (NSString *r in rArray)
		[cli put:r withNewline:true];
	
}


@end
