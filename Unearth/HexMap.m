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

- (NSArray *) getAvailableHexCells {
	// Return an array of the currently reachable hex cells.
	NSArray *rval = [[NSArray alloc] init];
	
	if ([hexCells count] == 1) {
		// Only the origin cell is available
		rval = hexCells;
	}
	else {
		// Evaluate occupied cells, returning neighbors where a stone could be placed.
		
		// Ed: implies a method on hexcell of 'getMyNeighbors', but s/b in the map instead.
		//     complicating factor; if a loop has been made, the middle is available but only for wonders.
		//	   also,
		// TODO: Add dedupe getAvailableHexCells() results (two occupied cells often share a neighbor).
		NSLog(@"HexMap.getAvailableHexCells(): CONSTRUCTION ZONE! Dedupe results not yet implemented.");
		
		for (HexCell *aCell in hexCells) {
			if ([aCell isOccupied])
				rval = [rval arrayByAddingObjectsFromArray:[self getNeighborCells:aCell
																   onlyUnoccupied:true]];
			
		}
	}
	
	return rval; 
	
} 

- (NSArray *) getNeighborCells: (HexCell *) hexCell onlyUnoccupied: (bool) bOnlyUnoccupied {
	// Return an array of the cells next to the specified cell
	
	NSArray *rval = [[NSArray alloc] init];
	
	// Based on "x-in, y-down" (row and column, respectively)
	const int NEIGHBOR_X_OFFSETS[] = {-1, 1, -2, 2, -1, 1};
	const int NEIGHBOR_Y_OFFSETS[] = {-1, -1, 0, 0, 1, 1};
	const int NEIGHBOR_SIZE = 6;

	int originX = [hexCell getRowPosition];
	int originY = [hexCell getColumnPosition];
	
	for (int i=0; i<NEIGHBOR_SIZE; i++) {
		int nRow = originX + NEIGHBOR_X_OFFSETS[i];
		int nCol = originY + NEIGHBOR_Y_OFFSETS[i];
		
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

- (bool) addStone: (Stone *) stone atHexCell: (HexCell *) cell {
	bool bRval = false;
	
	// TODO: Flesh out Hex Map addStone method.
	NSString *msg = [NSString stringWithFormat:@"In addStone_atHexCell with Stone %d\n",
					 							[stone getStoneID]];
	[cli put:msg];
	
	[cell setTile:stone];
	
	// Add new neighboring cells when adding a stone (only unoccupied b/c occupied would already exist).
	// Note: A bit obtuse, but getHexCellAtRow creates the cell if it didn't exist
	NSArray *neighborCells = [self getNeighborCells:cell onlyUnoccupied:true];
	for (HexCell *nCell in neighborCells)
		[self getHexCellAtRow:[nCell getRowPosition] Column:[nCell getColumnPosition]];
	
	return bRval;
	
}

- (bool) addStone: (Stone *) s touchingHexCell: (HexCell *) c onSide: (HexDirection) direction {
    bool bRval = false;
    
	// TODO: Flesh out Hex Map addStone w/ 'touching' param method.
	NSString *msg = [NSString stringWithFormat:@"In addStone touchingHexCell with Stone %d\n", [s getStoneID]];
	[cli put:msg];
    
    return bRval;
    
}

- (bool) addWonder: (Wonder *) w atHexCell: (HexCell *) c {
	bool bRval = false;
	
	// TODO: Flesh out Hex Map addWonder method.
	NSString *msg = [NSString stringWithFormat:@"In addWonder atHexCell with Stone %d\n", [w getBaseID]];
	[cli put:msg];

	return bRval;
	
}

- (bool) addWonder: (Wonder *) w touchingHexCell: (HexCell *) c onSide: (HexDirection) direction {
    bool bRval = false;

	// TODO: Flesh out Hex Map addWonder w/ 'touching' param method.
	NSString *msg = [NSString stringWithFormat:@"In addWonder with Wonder %d\n", [w getBaseID]];
	[cli put:msg];

    return bRval;
    
}

@end
