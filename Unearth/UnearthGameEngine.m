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
    
    gameState = GameStatePopulated;
    
    return self;
    
}

- (id) initWithGameDataDictionary: (NSDictionary *) dict {
    
    cli = [[CommandLineInterface alloc] init];
    gameState = GameStateNotPopulated;
    
    if ([self populateGameFromDictionary:dict])
        gameState = GameStatePopulated;
    else
        gameState = GameStatePopulationFailed;
    
    return self;

}

+ (NSString *) GameStateToString: (GameState) gameState {
	
	NSString *rval = @"NOT_SET";
	
	switch(gameState) {
		case GameStateRunning:
			rval = @"Running";
			break;
			
		case GameStatePopulationFailed:
			rval = @"PopulationFailed";
			break;

		case GameStateNotPopulated:
			rval = @"NotPopulated";
			break;

		case GameStatePopulated:
			rval = @"Populated";
			break;

		case GameStateError:
			rval = @"Error";
			break;

		case GameStateQuit:
			rval = @"Quit";
			break;
			
	}
	
	return rval;
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
	lesserWondersDeck = [dict objectForKey:@"LesserWondersDeck"];
	greaterWondersDeck = [dict objectForKey:@"GreaterWondersDeck"];
	namedWondersDeck = [dict objectForKey:@"NamedWondersDeck"];

	currentDelverDeckIdx = 0;
	currentRuinsDeckIdx = 0;
	currentLesserWonderIdx = 0;
	currentGreaterWonderIdx = 0;
	currentNamedWonderIdx = 0;

    // TODO: Add some validation of the above, for now assume it worked

    if (bRval)
		gameState = GameStatePopulated;
    else
		gameState = GameStatePopulationFailed;
    
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

- (Wonder *) getWonderFromDeck: (WonderType) wonderType {
	
	Wonder *rval;
	
	switch(wonderType) {
		case WonderTypeLesser:
			rval = [lesserWondersDeck objectAtIndex:currentLesserWonderIdx];
			currentLesserWonderIdx++;
			break;

		case WonderTypeGreater:
			rval = [greaterWondersDeck objectAtIndex:currentGreaterWonderIdx];
			currentGreaterWonderIdx++;
			break;

		case WonderTypeNamed:
			rval = [namedWondersDeck objectAtIndex:currentNamedWonderIdx];
			currentNamedWonderIdx++;
			break;

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
	
	// Put (number of players + 2) named wonder cards on the table
	namedWondersOnTable = [[NSArray alloc] init];
	for (int x=0; x<[players count]+2; x++)
		namedWondersOnTable = [namedWondersOnTable arrayByAddingObject:[self getWonderFromDeck:WonderTypeNamed]];
	
	// Determine who goes first, each player roles a d6, high value goes first
	int highPlayerIdx = -1;
	int highRoll = -1;
	for (int x=0; x<[players count]; x++) {
		UnearthPlayer *currentPlayer = [players objectAtIndex:x];
		int currentRoll = [currentPlayer roleDie:DelverDieSize6];
		if (currentRoll > highRoll) {
			highPlayerIdx = x;
			highRoll = currentRoll;
			
		}
	}

	currentPlayerIdx = highPlayerIdx;
	UnearthPlayer *firstPlayer = [players objectAtIndex:currentPlayerIdx];
	NSString *msg = [[NSString alloc] initWithFormat:@"Player %@ goes first.\n", [firstPlayer playerName]];
	[cli put:msg];
		
}

- (int) go {
    
    [cli put:@"Inside of UnearthGameEngine.\n"];
    
    NSString *msg = [[NSString alloc] initWithFormat:@"UGE state = %@", [UnearthGameEngine GameStateToString:gameState]];
    [cli debugMsg:msg level:100];
    
    msg = [[NSString alloc] initWithFormat:@"Game has %ld players.\n", [players count]];
    [cli put:msg];
	
	// do initial setup (e.g. 2 delver cards to each player, one ruin card to each player, etc)
	[self doInitialGameSetup];
	
	while (gameState != GameStateQuit) {
		UnearthPlayer *currentPlayer = [self getCurrentPlayer];
		[self doPlayerTurn:currentPlayer];
		[self advanceToNextPlayer];
	}
    
    return 0;
    
}

- (void) doPlayerTurn: (UnearthPlayer *) player {

	if ([player getPlayerType] == UnearthPlayerHuman)
		[self doHumanPlayerTurn: player];
	else
		[self doAIPlayerTurn:player];
	
}

- (void) doHumanPlayerTurn: (UnearthPlayer *) player {
	
	// Player's turn has two phases, delver and excavation
	[cli put:@"Player Delver Phase.\n"];
	
	NSArray *delverCardsSelected = [[NSArray alloc] init];
	NSString *playDC = [cli getStr:@"Would you like to play a delver card (y/n)?"];
	if ([playDC compare:@"y"] == NSOrderedSame) {
		int selectedCardID = -1;
		while (selectedCardID != 0) {
			[cli put:@"Choose a card to play (or 0 for none)"];
			[cli put:[player showDelverCards]];
			selectedCardID = [cli getInt:@"Select card (0 for none)"];
			// Pull delver cards from player's hand into game engine member var, delverCards in play.
			DelverCard *dc = [player playDelverCard:selectedCardID];
			delverCardsSelected = [delverCardsSelected arrayByAddingObject:dc];
			
		} // while selectedCardID != 0
		delverCardsInPlay = delverCardsSelected;
	}
	
	[cli put:@"Player Excavation Phase.\n"];
	// Show wonders and ruin cards currently on the table
	[cli put:[self showWondersOnTable]];
	[cli put:[self showRuinsOnTable]];
	
	// Do player action loop
	PlayerAction currentAction = PlayerActionNotSet;
	PlayerActionTarget currentActionTarget = PlayerActionTargetNotSet;
	PlayerActionTargetLocation currentActionTargetLocation = PlayerActionTargetLocationNotSet;
	bool bTurnDone = false;
	while (!bTurnDone){
		NSString *commandMsg = [cli getStr:@"Enter command (or 'help')"];
		currentAction = [player parsePlayerActionFromString:commandMsg];
		currentActionTarget = [player parsePlayerActionTargetFromString:commandMsg];
		currentActionTargetLocation = [player parsePlayerActionTargetLocationFromString:commandMsg];
		[self doAction:currentAction target:currentActionTarget location:currentActionTargetLocation player:player];
		
		if ((currentAction == PlayerActionDone)
			|| (currentAction == PlayerActionQuit))
			bTurnDone = true;
		
	}

}

- (void) doAIPlayerTurn: (UnearthPlayer *) player {
	
	[cli put:@"UGE.doAIPlayerTurn() not yet implemented.\n"];
	
}

- (UnearthPlayer *) getCurrentPlayer {
	return [players objectAtIndex:currentPlayerIdx];
	
}

- (void) advanceToNextPlayer {
	
	if (currentPlayerIdx < [players count]-1)
		currentPlayerIdx++;
	else
		currentPlayerIdx = 0;
	
}

- (NSString *) showWondersOnTable {
	
	NSString *rval = @"Wonders on Table:\n";
	
	for (Wonder *w in namedWondersOnTable)
		rval = [rval stringByAppendingFormat:@"%@\n", [w toString]];
	
	return rval;
	
}

- (NSString *) showRuinsOnTable {
	
	NSString *rval = @"Ruins on Table:\n";
	
	for (RuinCard *r in ruinsOnTable)
		rval = [rval stringByAppendingFormat:@"%@\n", [r toString]];
	
	return rval;
	
}

- (void) setGameState: (GameState) newState {
    
    gameState = newState;
    
}

- (void) doAction: (PlayerAction) action
		   target: (PlayerActionTarget) target
		 location: (PlayerActionTargetLocation) loc
		   player: (UnearthPlayer *) player {
	
	switch(action) {
		case PlayerActionNotSet:
			// treat as help.
			[cli put:[player showPlayerActionHelp]];
			break;

		case PlayerActionHelp:
			[cli put:[player showPlayerActionHelp]];
			break;

		case PlayerActionQuit:
			// Set game state to Quit.
			// TODO: Add confirmation before setting game state to quit.
			gameState = GameStateQuit;
			break;

		case PlayerActionDone:
			// TODO: Add any clean up with player action done (e.g. replace ruins taken in this turn)
			break;

		case PlayerActionShow:
			// TODO: Add method to show target specified.
			break;

		case PlayerActionRoll:
			// TODO: Add method to handle rolling of dice.
			break;

			
		
	}
}

- (GameState) gameState {
	return gameState;
	
}

@end
