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

- (bool) isRelativeRowEven: (HexCellPosition *) position {
	// if the specified cell position's row is even relative to the min row in the map, return true
	bool bRval = false;
	
	// Update stats to make sure min and max are current.
	[self updateStats];
	
	int relativeRow = minRow - 1 - [position getRow];
	if (relativeRow % 2 == 0)
		bRval = true;
	
	return bRval;
	
}

- (bool) isInLastRow: (HexCellPosition *) position {
	// if the specified cell position's row is in the last row relative to the max row in the map, return true
	bool bRval = false;
	
	// Update stats to make sure min and max are current.
	[self updateStats];
	
	if ([position getRow] == maxRow)
		bRval = true;
	
	return bRval;
	
}

- (bool) isInFirstColumn: (HexCellPosition *) position {
	// if the specified cell position's column is in the first column relative to the min col in the map, return true
	bool bRval = false;
	
	// Update stats to make sure min and max are current.
	[self updateStats];
	
	if ([position getColumn] == minCol)
		bRval = true;
	
	return bRval;
	
}

- (bool) isInLastColumn: (HexCellPosition *) position {
	// if the specified cell position's column is in the last column relative to the max col in the map, return true
	bool bRval = false;
	
	// Update stats to make sure min and max are current.
	[self updateStats];
	
	if ([position getColumn] == maxCol)
		bRval = true;
	
	return bRval;
	
}

- (bool) isInFirstCellInRow: (HexCellPosition *) position {
	// if the specified cell position's column is in the first column in its row, return true
	bool bRval = false;
	
	int currentCellColumn = [position getColumn];
	int currentCellRow = [position getRow];
	int minColumnInRow = 999;
	
	// check each cell to see if it is in this row and is get minColumn for this row.
	for (HexCell *aCell in hexCells) {
		if (([aCell getRowPosition] == currentCellRow)
			&& ([aCell getColumnPosition] < minColumnInRow))
			minColumnInRow = [aCell getColumnPosition];
		
	}
	
	if (currentCellColumn == minColumnInRow)
		bRval = true;
	
	return bRval;
	
}


- (bool) isInLastCellInRow: (HexCellPosition *) position {
	// if the specified cell position's column is in the last column in its row, return true
	bool bRval = false;

	int currentCellColumn = [position getColumn];
	int currentCellRow = [position getRow];
	int maxColumnInRow = -1;
	
	// check each cell to see if it is in this row and is get maxColumn for this row.
	for (HexCell *aCell in hexCells) {
		if (([aCell getRowPosition] == currentCellRow)
			&& ([aCell getColumnPosition] > maxColumnInRow))
			maxColumnInRow = [aCell getColumnPosition];
		
	}
	
	if (currentCellColumn == maxColumnInRow)
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
	
	NSLog(@"map.addWonder_atHexCell() WARNING: Not yet implemented.");
	NSString *msg = [NSString stringWithFormat:@"In map.addWonder_atHexCell with Wonder=(%@) at HexCell=(%@)\n",
					 [w toString],
					 [c toString]];
	[cli debugMsg:msg level:4];
	
	// TODO: Valiate the 'loop' meets the criteria for the wonder being placed.

	[c setTile:w];

	return bRval;
	
}

- (bool) addWonder: (Wonder *) w touchingHexCell: (HexCell *) c onSide: (HexDirection) direction {
    bool bRval = false;

	// Note: don't need to call addNeighborsToCell, wonders can only be added when already surrounded by occupied neighbors
	NSString *methodName = @"map.addWonder_touchingHexCell_onSide";
	NSString *msg = [NSString stringWithFormat:@"%@ at cell (%@) with Wonder %d and direction=(%@)\n",
					 methodName,
					 [c toString],
					 [w getBaseID],
					 [HexMap HexDirectionToString:direction]];
	[cli debugMsg:msg level:4];
	
	HexCellPosition *basePosition = [c getPosition];
	HexCellPosition *targetPosition = [HexCellPosition getPosAtDirection:direction
															fromPosition:basePosition];
	HexCell *targetCell = [self getHexCellAtPosition:targetPosition];
	
	// TODO: Valiate the 'loop' meets the criteria for the wonder being placed.
	
	[targetCell setTile:w];

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

	msg = [msg stringByAppendingFormat:@"min/max used columnsX & rowsY are Xm=%d, Xmax=%d, Ym=%d, Ymax=%d.",
					 minCol,
					 maxCol,
					 minRow,
					 maxRow];

	return msg;
	
}

- (void) drawMap {
	
	[cli debugMsg:@"In HexMap.drawMap()" level:5];
	
	[self updateStats];
	// before rendering cells, touch every cell, min to max, to make sure they are in the array
	for (int y=minRow; y<=maxRow; y++) {
		for (int x=minCol; x<=maxCol; x++) {
			HexCellPosition *cellPos = [[HexCellPosition alloc] initWithRow:y Column:x];
			if ([self isPositionValid:cellPos]) {
				// don't need to keep it, just asking for it will generate it if it didn't exist.
				[self getHexCellAtRow:y Column:x];
			}
		}
	}

	[cli debugMsg:[self generateStatsMessage] level:5];

	// Debug display cells as text
	for (HexCell *aCell in hexCells)
		[cli debugMsg:[aCell toString] level:4];
	
	
	// output the cell's positions in order by position.
	[self updateStats];
	for (int y=minRow; y<=maxRow; y++) {
		NSString *currentRow = @"";
		r1 = @"";
		r2 = @"";
		r3 = @"";
		r4 = @"";
		r5 = @"";
		r6 = @"";

		for (int x=minCol; x<=maxCol; x++) {
			
			// Only proceed if the position is valid
			HexCellPosition *cellPos = [[HexCellPosition alloc] initWithRow:y Column:x];
			if ([self isPositionValid:cellPos]) {
				// just because a position is b/n min & max doesn't mean it exists in array
				// but getting it will add it.
				HexCell *currentCell = [self getHexCellAtRow:y Column:x];
				[self drawACell:currentCell];
				
				// add this cell to the current row
				currentRow = [currentRow stringByAppendingFormat:@" %@ ",
							  [[currentCell getPosition] toString]];
			
			} // if cellPos valid
			
		} // x
		
		NSArray *rArray = [[NSArray alloc] initWithObjects:r1, r2, r3, r4, nil];
		
		// if in last row output row 5 and 6 (bottoms, SW and SE segments).
		if (y == maxRow) {
			rArray = [rArray arrayByAddingObject:r5];
			rArray = [rArray arrayByAddingObject:r6];

		}
		
		for (NSString *r in rArray)
			[cli put:r withNewline:true];

		// Diag output, remove when above tests out ok.
		//[cli put:currentRow withNewline:true];
		
	} // y

	[self drawACell:hexCells[0]];
	
}

- (void) drawACell: (HexCell *) cell {
	
	/*
	 The borders of the cell to draw are dependent on the following rules:
	 Always print NW, NE, and W
	 	If the relative row is even and working first relative column, add space before printing NW, NE, and W
	 Last row prints SW, SE
	 First column prints SW
	 Last Column prints E
	 Last Column but not Last Row prints SE

	 */
	
	bool bInEvenRelativeRow = [self isRelativeRowEven:[cell getPosition]];
	bool bInLastRow = [self isInLastRow:[cell getPosition]];
	bool bInFirstColumn = [self isInFirstColumn:[cell getPosition]];
	bool bInLastColumn = [self isInLastColumn:[cell getPosition]];
	bool bInLastCellInRow = [self isInLastCellInRow:[cell getPosition]];
	bool bInFirstCellInRow = [self isInFirstCellInRow:[cell getPosition]];
	
	// The nw1 segment (upper part of NW border) always starts with at least two spaces.
	// THe nw2 segment (lower part of NW border) always has one space before the border.
	NSString *nw1 = @"  ";
	NSString *nw2 = @" /";
	if (bInFirstColumn) {
		// nw1 segment has only 2 spaces before border line in first column
		nw1 = [nw1 stringByAppendingString:@"/"];
	}
	else {
		// in non-first columns the nw1 segment has three spaces before border
		nw1 = [nw1 stringByAppendingString:@" /"];
	}
	
	// The ne1 segment (upper part of NE border) always has one space before it.
	// The ne2 segment (lower part of NE border) always has three spaces before it.
	NSString *ne1 = @" \\";
	NSString *ne2 = @"   \\";

	// The w1 & w2 segments (upper and lower parts of W border, respectively)
	//   have no leading spaces unless they are in an even relative row.
	NSString *w1 = @"|";
	NSString *w2 = @"|";
	
	// The e1 & e2 segments are only added for last column or last in row segments
	NSString *e1 = @"";
	NSString *e2 = @"";
	if (bInLastColumn || bInLastCellInRow) {
		e1 = @"|";
		e2 = @"|";
	}
	
	// The sw1 seg always has 1 space
	NSString *sw1 = @" \\";
	
	// The sw2 has 2 spaces in leftmost column, 3 in all others.
	NSString *sw2 = @"  ";
	if (bInFirstCellInRow)
		sw2 = [sw2 stringByAppendingString:@"\\"];
	else
		sw2 = [sw2 stringByAppendingString:@" \\"];
	
	// The se1 (upper) and se2 (lower) segments have 3 and 1 leading spaces, respectively.
	NSString *se1 = @"   /";
	NSString *se2 = @" /";
	
	// Even Relative Row Spaces = errs3, errs2, or errs1
	NSString *errs3 = @"   ";
	NSString *errs2 = @"  ";
	
	// The contents of the cell
	NSString *occupiedMarker = @"   ";
	NSString *stoneID = @"  ";
	if ([cell isOccupied]) {
		if([[cell getTile] getTileType] == HexTileTypeStone) {
			Stone *s = (Stone *)[cell getTile];
			occupiedMarker = [s getStoneColorAsShortString];
			stoneID = [[NSString alloc] initWithFormat:@"%2d", [s getStoneID]];
		}
		else {
			Wonder *w = (Wonder *)[cell getTile];
			occupiedMarker = [w getWonderTypeAsShortString];
			stoneID = [[NSString alloc] initWithFormat:@"%2d", [w getWonderID]];

		}
		
	}
	NSString *body1 = [[NSString alloc] initWithFormat:@" %@ ", occupiedMarker];
	NSString *body2 = [[NSString alloc] initWithFormat:@"  %@ ", stoneID];
	
	if (bInEvenRelativeRow) {
		// add SW to top two rows if in first column of the row (when only printing tops)
		if (bInFirstCellInRow) {
			r1 = [r1 stringByAppendingFormat:@"%@", sw1];
			r2 = [r2 stringByAppendingFormat:@"%@", sw2];
			r3 = [r3 stringByAppendingFormat:@"%@", errs3];
			r4 = [r4 stringByAppendingFormat:@"%@", errs3];
		}
		
		if (bInLastRow) {
			r5 = [r5 stringByAppendingFormat:@"%@", errs3];
			r6 = [r6 stringByAppendingFormat:@"%@", errs2];

		}

	} // bInEvenRelativeRow

	
	// r1 & r2 are always the NW and NE segments
	r1 = [r1 stringByAppendingFormat:@"%@%@", nw1, ne1];
	r2 = [r2 stringByAppendingFormat:@"%@%@", nw2, ne2];
	r3 = [r3 stringByAppendingFormat:@"%@%@%@", w1, body1, e1];
	r4 = [r4 stringByAppendingFormat:@"%@%@%@", w2, body2, e2];
	
	// if in even row and last cell in row, tack on a SW segment set.
	if (bInEvenRelativeRow && bInLastCellInRow) {
		// add se segment
		r1 = [r1 stringByAppendingFormat:@"%@", se1];
		r2 = [r2 stringByAppendingFormat:@"%@", se2];
	}
	
	if (bInLastRow) {
		r5 = [r5 stringByAppendingFormat:@"%@%@", sw1, se1];
		r6 = [r6 stringByAppendingFormat:@"%@%@", sw2, se2];
		
	}
	
}


@end
