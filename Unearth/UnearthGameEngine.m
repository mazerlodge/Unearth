//
//  UnearthGameEngine.m
//  Unearth
//
//  Created by mazerlodge on 7/1/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "UnearthGameEngine.h"

@implementation UnearthGameEngine

- (id) init {
    cli = [[CommandLineInterface alloc] init];
    
    gameState = @"NOT_POPULATED";
    
    return self;
    
}

- (id) initWithGameDataDictionary: (NSDictionary *) dict {
    
    cli = [[CommandLineInterface alloc] init];
    gameState = @"NOT_POPULATED";
    
    if ([self populateGameFromDictionary:dict])
        gameState = @"POPULATED";
    else
        gameState = @"POPULATION_FAILED";
    
    return self;

}

- (bool) populateGameFromDictionary: (NSDictionary *) dict {
    
    bool bRval = true;
    
    // TODO: Add more dictionary parsing
    //      (e.g. grab delver cards, ruins deck, end of age card, stone bag, active wonders)
	
	cli = [dict objectForKey:@"CommandLineInterface"];
    players = [dict objectForKey:@"PlayerArray"];
    endOfAgeCard = [dict objectForKey:@"EndOfAgeCard"];
    stoneBag = [dict objectForKey:@"StoneBag"];
	delverDeck = [dict objectForKey:@"DelverDeck"];
	ruinsDeck = [dict objectForKey:@"RuinsDeck"];
	
	currentDelverDeckIdx = 0;
	currentRuinsDeckIdx = 0;
    
    // TODO: Add some validation of the above, for now assume it worked

    if (bRval)
        gameState = @"POPULATED";
    else
        gameState = @"POPULATION_FAILED";
    
    return bRval;
}

- (DelverCard *) getDelverCardFromDeck {
	
	DelverCard *rval = [[DelverCard alloc] initWithString:@"-1,NOT_SET,NOT_SET,-1"];
	
	if (currentDelverDeckIdx != -1) {
		rval = [delverDeck objectAtIndex:currentDelverDeckIdx];
		currentDelverDeckIdx++;

	}
	
	if (currentDelverDeckIdx >= [delverDeck count])
		currentDelverDeckIdx = -1;
	
	return rval;
	
}

- (RuinCard *) getRuinCardFromDeck {
	
	RuinCard *rval = [[RuinCard alloc] initWithColor:RuinCardColorGray claimValue:-1 stoneValue:0];
	
	if ([ruinsDeck getCount] > 0) {
		rval = [ruinsDeck getNextCard];

	}
		
	return rval;
	
}

- (void) doInitialGameSetup {
	// do initial setup (e.g. 2 delver cards to each player, one ruin card to each player, etc)
	
	for (UnearthPlayer *aPlayer in players) {
		[aPlayer addDelverCard:[self getDelverCardFromDeck]];
		[aPlayer addDelverCard:[self getDelverCardFromDeck]];

		// Give each player a ruin card face down (cards default to face down).
		// No need to check if cards are remaining in the deck as this is the start of game.
		[aPlayer addRuinCard:[self getRuinCardFromDeck]];
	}
	
	// Put top five ruin cards in the box.
	ruinsInBox = [[NSArray alloc] init];
	for (int x=0; x<5; x++)
		ruinsInBox = [ruinsInBox arrayByAddingObject:[ruinsDeck getNextCard]];
	
	// Put next five ruin cards on the table (four for two player)
	int maxNumCards = ([players count] > 2) ? 5 : 4;
	ruinsOnTable = [[NSArray alloc] init];
	for (int x=0; x<maxNumCards; x++)
		ruinsOnTable = [ruinsOnTable arrayByAddingObject:[ruinsDeck getNextCard]];

	// For the cards on the table, put appropriate stone count on each card.
	RuinCard *currentCard;
	for (int x=0; x<[ruinsOnTable count]; x++) {
		currentCard = [ruinsOnTable objectAtIndex:x];
		for (int s=0; s<[currentCard stoneValue]; s++)
			[currentCard addStoneToCard:[stoneBag getNextStone]];

	}
	NSLog(@"Just a breakpoint, nothing to see");
	
	
}

- (int) go {
    
    [cli put:@"Inside of UnearthGameEngine.\n"];
    
    NSString *msg = [[NSString alloc] initWithFormat:@"UGE state = %@", gameState];
    [cli debugMsg:msg level:100];
    
    msg = [[NSString alloc] initWithFormat:@"Game has %ld players.\n", [players count]];
    [cli put:msg];
	
	// do initial setup (e.g. 2 delver cards to each player, one ruin card to each player, etc)
	[self doInitialGameSetup];
    
    return 0;
    
}

- (void) setGameState: (NSString *) newState {
    
    gameState = newState;
    
}

- (NSString *) gameState {
	return gameState;
	
}

@end
