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

- (void) doInitialGameSetup {
	// do initial setup (e.g. 2 delver cards to each player, one ruin card to each player, etc)
	
	for (UnearthPlayer *aPlayer in players) {
		[aPlayer addDelverCard:[self getDelverCardFromDeck]];
		[aPlayer addDelverCard:[self getDelverCardFromDeck]];

		// TODO: Also add a ruin card face down
	}
	
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
