//
//  UnearthGameEngine.m
//  Unearth
//
//  Created by mazerlodge on 7/1/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "UnearthGameEngine.h"

@implementation UnearthGameEngine

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
			
		case GameStateDelverPhase:
			rval = @"DelverPhase";
			break;
			
		case GameStateExcavationPhase:
			rval = @"ExcavationPhase";
			break;

		case GameStateQuit:
			rval = @"Quit";
			break;
			
	}
	
	return rval;
}

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


- (bool) populateGameFromDictionary: (NSDictionary *) dict {
    
    bool bRval = true;
    
    // TODO: Add more dictionary parsing
    //      (e.g. grab delver cards, ruins deck, end of age card, stone bag, active wonders)
	
	cli = [dict objectForKey:@"CommandLineInterface"];
	re = [dict objectForKey:@"RandomEngine"];
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
	
	RuinCard *rval = [[RuinCard alloc] initWithColor:RuinCardColorGray
										  claimValue:-1
										  stoneValue:0
										  cardIdentifier:-1];
	
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

- (RuinCard *) getRuinByID: (NSUInteger) objectID {

	RuinCard *rval = nil;
	
	for (RuinCard *aRuin in ruinsOnTable) {
		if ([aRuin getRuinID] == objectID) {
			rval = aRuin;
			break;
		}
		
	}
	
	return rval;

}

- (Wonder *) getWonderByID: (NSUInteger) objectID {
	
	Wonder *rval = nil;
	
	for (Wonder *aWonder in namedWondersOnTable) {
		if ([aWonder getWonderID] == objectID) {
			rval = aWonder;
			break;
		}
		
	}
	
	return rval;
	
}

- (void) addStoneToBag: (Stone *) stone {
	
	// TODO: Add code here after changing Stone Bag class to use mutable array

}

- (NSUInteger) removeRuinFromTableByID: (NSUInteger) ruinID {
	
	NSUInteger rval = [ruinsOnTable count];

	for (RuinCard *aCard in ruinsOnTable) {
		if ([aCard getRuinID] == ruinID) {
			[ruinsOnTable removeObject:aCard];
			break;
		}
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
	ruinsOnTable = [[NSMutableArray alloc] init];
	for (int x=0; x<maxNumCards; x++)
		[ruinsOnTable addObject:[ruinsDeck getNextCard]];

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
    
    NSString *msg = [[NSString alloc] initWithFormat:@"UGE state = %@", [UnearthGameEngine GameStateToString:gameState]];
    [cli debugMsg:msg level:1];
    
    msg = [[NSString alloc] initWithFormat:@"Game has %ld players.\n", [players count]];
    [cli put:msg];
	
	// do initial setup (e.g. 2 delver cards to each player, one ruin card to each player, etc)
	[self doInitialGameSetup];
	
	while (gameState != GameStateQuit) {
		UnearthPlayer *currentPlayer = [self getCurrentPlayer];
		NSString *msg = [[NSString alloc] initWithFormat:@"Current Player is now %@.\n", [currentPlayer playerName]];
		[cli put:msg];
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
	[self setGameState:GameStateDelverPhase];

	// Placeholder Delver phase code.
	NSArray *delverCardsSelected = [[NSArray alloc] init];
	NSString *seeDC = [cli getStr:@"Would you like to look at your delver cards (y/n)? "];
	if ([seeDC compare:@"y"] == NSOrderedSame) {
		int selectedCardID = -1;
		while (selectedCardID != 0) {
			[cli put:@"Choose a card to play (or 0 for none)" withNewline:true];
			[cli put:[player showDelverCards]];
			selectedCardID = [cli getInt:@"Select card ID (0 for done): "];
			// Pull delver cards from player's hand into game engine member var, delverCards in play.
			DelverCard *dc = [player playDelverCard:selectedCardID];
			delverCardsSelected = [delverCardsSelected arrayByAddingObject:dc];
			
		} // while selectedCardID != 0
		delverCardsInPlay = delverCardsSelected;
	}

	// Do excavation phase
	[self setGameState:GameStateExcavationPhase];
	
	// Show wonders and ruin cards currently on the table
	[cli put:[self showWondersOnTable]];
	[cli put:[self showRuinsOnTable]];
	
	// Do player action loop
	struct PlayerAction currentAction = [player makePlayerActionNotSet];
	bool bTurnDone = false;
	while (!bTurnDone){
		NSString *commandMsg = [cli getStr:@"Enter command (or 'help') "];
		currentAction = [player parsePlayerActionFromString:commandMsg];
		[self doAction:currentAction player:player];
		
		if ((currentAction.verb == PlayerActionVerbDone)
			|| (currentAction.verb == PlayerActionVerbQuit))
			bTurnDone = true;
		
	}

}

- (void) doAIPlayerTurn: (UnearthPlayer *) player {

	// Do delver phase
	[self setGameState:GameStateDelverPhase];

	
	// TODO: AI Considers playing delver card(s).
	[cli put:@"UGE.doAIPlayerTurn(), AI Delver Phase not yet implemented.\n"];

	// Do excavation phase
	[self setGameState:GameStateExcavationPhase];

	// TODO: AI Considers wonders and ruin cards currently on the table
	
	// Do player action loop
	struct PlayerAction currentAction = [player makePlayerActionNotSet];
	bool bTurnDone = false;
	while (!bTurnDone){
		[cli put:@"UGE.doAIPlayerTurn(), AI Excavation Phase not yet implemented.\n"];

		// TODO: AI compute player action verb, target, and location.
		currentAction.verb = PlayerActionVerbDone;
		
		[self doAction:currentAction
				player:player];
		
		if ((currentAction.verb == PlayerActionVerbDone)
			|| (currentAction.verb == PlayerActionVerbQuit))
			bTurnDone = true;
		
	}
	
	
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
		rval = [rval stringByAppendingFormat:@"%@\n", [w toStringBriefOutput:true]];
	
	rval = [rval stringByAppendingString:@"\n"];
	
	return rval;
	
}

- (NSString *) showWonderDetailsOnTable: (NSUInteger) wonderID {

	NSString *rval = @"Wonder Details:\n";
	
	Wonder *w;
	bool bWonderFound = false;
	
	// Search table for wonder
	for (Wonder *cw in namedWondersOnTable) {
		NSUInteger cwID = cw.getWonderID;
		if (cwID == wonderID) {
			w = cw;
			bWonderFound = true;
			NSString *wonderLongDescription = [w toString];
			rval = [rval stringByAppendingFormat:@" %@\n", wonderLongDescription];
		}
	}
	
	if (!bWonderFound)
		rval = [NSString stringWithFormat:@"Wonder with ID=%ld not found on table.\n", wonderID];
	
	return rval;
}


- (NSString *) showWonderDetailsinPlayerHand: (UnearthPlayer *) player forWonderID: (NSUInteger) wonderID {

	NSString *rval = @"Wonder Details:\n";
	
	Wonder *w = [player getWonderByID:wonderID];
	rval = [rval stringByAppendingFormat:@" %@", [w toString]];

	if (w == nil)
		rval = [NSString stringWithFormat:@"Wonder with ID=%ld not found in player's hand.\n", wonderID];
	
	return rval;
}


- (NSString *) showRuinsOnTable {
	
	NSString *rval = @"Ruins on Table:\n";
	
	for (RuinCard *r in ruinsOnTable)
		rval = [rval stringByAppendingFormat:@"%@\n", [r toString]];
	
	return rval;
	
}

- (NSString *) showDelverCardsInPlay {
	
	NSString *rval = @"Delver Cards in Play:\n";
	
	for (DelverCard *c in delverCardsInPlay)
		rval = [rval stringByAppendingFormat:@"%@\n", [c toString]];
	
	return rval;
	
}


- (void) setGameState: (GameState) newState {
    
	NSString *gameStateText = [UnearthGameEngine GameStateToString:newState];
	NSString *msg = [[NSString alloc] initWithFormat:@"GameState set to %@\n",
													 gameStateText];

	[cli put:msg];

    gameState = newState;
    
}

- (void) doAction: (struct PlayerAction) action player: (UnearthPlayer *) player {
	
	NSString *confirmQuit;
	
	switch(action.verb) {
		case PlayerActionVerbNotSet:
			// treat as help.
			[cli put:[player showPlayerActionHelp]];
			break;

		case PlayerActionVerbHelp:
			[cli put:[player showPlayerActionHelp]];
			break;

		case PlayerActionVerbQuit:
			// Set game state to Quit.
			confirmQuit = [cli getStr:@"Are you sure you want to quit (Y/n)?"];
			if ([confirmQuit caseInsensitiveCompare:@"Y"] == NSOrderedSame)
				gameState = GameStateQuit;
			break;

		case PlayerActionVerbDone:
			// TODO: Add any clean up with player action done (e.g. replace ruins taken in this turn)
			break;

		case PlayerActionVerbShow:
			[self doActionShow:action player:player];
			break;

		case PlayerActionVerbRoll:
			[self doActionRoll:action player:player];
			break;

		case PlayerActionVerbExamine:
			[self doActionExamine:action player:player];
			break;
		
	}
}


- (void) doActionRoll: (struct PlayerAction) action player: (UnearthPlayer *) player {

	bool bShowUnderConstruction = true;
	
	// For rolls, the action structure can be updated; target always a ruin, location always on the table
	action.target = PlayerActionTargetRuin;
	action.targetLocation = PlayerActionTargetLocationBoard;
	
	NSString *msg = [[NSString alloc] initWithFormat:@"In UGE.doActionRoll:player() with "
													  "verb=%@ subject=%ld target=%@ location=%@ objectID=%ld\n",
					 [UnearthPlayer PlayerActionVerbToString:action.verb],
					 action.subject,
					 [UnearthPlayer PlayerActionTargetToString:action.target],
					 [UnearthPlayer PlayerActionTargetLocationToString:action.targetLocation],
					 action.objectID];
	[cli debugMsg:msg level:5];

	// TODO: UGE.doActionRoll:player() Not yet (fully) implemented.
	bShowUnderConstruction = true;
	
	// Take a die from the player of the size specified, roll it, and put it on the target ruin specified.
	// Convert the die size number (e.g. 6) to a die size, then get one of that size from the player's dice.
	NSString *dieSizeString = [[NSString alloc] initWithFormat:@"d%ld", action.subject];
	DelverDieSize dieSize = [DelverDie DelverDieStringToSize:dieSizeString];
	if (dieSize == DelverDieSizeNotSet) {
		[cli put:@"Die of size specified is not valid." withNewline:true];
		return;
	}
	
	// Get the die of the size specified from the player and roll it
	DelverDie *theDie = [player getDieOfSize:dieSize];
	if (theDie == nil) {
		NSString *msg = [[NSString alloc] initWithFormat:@"Die of size specified (%ld) not found in players dice.",
						 action.subject];
		[cli put:msg withNewline:true];
		return;
	}

	[theDie roll];
	msg = [[NSString alloc] initWithFormat:@"Die roll = %d  (%@).",
		   [theDie getDieValue], [theDie toString] ];
	[cli put:msg withNewline:true];

	// Player gets a stone from the ruin when rolling a 1, 2, or 3, or from the bag if none on the ruin
	RuinCard *theCard = [self getRuinByID: action.objectID];
	if ([theDie getDieValue] <= 3) {
		Stone *selectedStone;
		if ([theCard getStoneCount] > 0) {
			// Show the card to the player and ask which stone to they want
			[cli put:[theCard toString] withNewline:true];
			do {
				int selectedStoneID = [cli getInt:@"On roll of 1, 2, or 3 take a stone. Select stone ID: "];
				selectedStone = [theCard getStoneByID:selectedStoneID];
			} while (selectedStone == nil);
			
		} else {
			// Get a stone from the bag when there are none on the card.
			msg = [[NSString alloc] initWithFormat:@"Player gets a stone when rolling a 1, 2, or 3. "
													"Card has no stones so taking one from the bag."];
			[cli put:msg withNewline:true];
			selectedStone =  [stoneBag getNextStone];
			
		}
		
		// Put the stone on the player's hexmap
		NSUInteger stoneCount = [player addStone: selectedStone];
		msg = [[NSString alloc] initWithFormat:@"Player now has %ld stones.",
						 stoneCount];

		[cli put:msg withNewline:true];
		
	} // dieVal < 3

	// TODO: Evaluate if delver cards in play manipulate die, allow reroll or altering target.
	
	// Get the ruin card specified and put the die on the ruin
	NSUInteger cardNewDieTotal = 0;
	if (theCard == nil) {
		NSString *msg = [[NSString alloc] initWithFormat:@"Ruin Card with ID specified (%ld) not found on table.",
						 action.objectID];
		[cli put:msg withNewline:true];
		
		// return the die to the player
		[player addDie: theDie];
		return;
	}
	else {
		cardNewDieTotal = [theCard addDieToCard:theDie];

	}
	
	// Check the ruin to see if it has been claimed, if so give it to the appropriate player
	if (cardNewDieTotal >= theCard.claimValue) {
		// Card has been claimed
		NSString *msg = [[NSString alloc] initWithFormat:@"Ruin Card with ID (%ld) has been claimed by the player.",
						 action.objectID];
		[cli put:msg withNewline:true];

		// Ruin claimed, return dice to owning players.
		[self returnDiceFromCard:theCard];
		
		// Ruin claimed, return any remaining stones to the bag
		[self returnStonesFromCard:theCard];
		
		// Put the card in the player's hand
		NSUInteger cardCount = [player addRuinCard:theCard];
		msg = [[NSString alloc] initWithFormat:@"Player now has (%lu) cards.",
			   (unsigned long)cardCount];
		[cli put:msg withNewline:true];
		
		// The card must be removed from the board
		[self removeRuinFromTableByID:[theCard getRuinID]];
		
		// TODO: When card claimed, get the next ruin from the deck, prep it (add stones), and place it on the table.
		
		[self showRuinsOnTable];

	}

	if(bShowUnderConstruction) {
		msg = [[NSString alloc] initWithFormat:@"UGE.doActionRoll:player(): Recieved Target=%@ with Location=%@, not yet (fully) implemented",
			   [UnearthPlayer PlayerActionTargetToString:action.target],
			   [UnearthPlayer PlayerActionTargetLocationToString:action.targetLocation]];

	}

}


- (void) doActionExamine: (struct PlayerAction) action player: (UnearthPlayer *) player {

	bool bShowNotYetImplementedMsg = false;
	
	NSString *msg = [[NSString alloc] initWithFormat:@"In UGE.doActionExamine:player() with "
													  "verb=%@ target=%@ location=%@ objectID=%ld\n",
					 [UnearthPlayer PlayerActionVerbToString:action.verb],
					 [UnearthPlayer PlayerActionTargetToString:action.target],
					 [UnearthPlayer PlayerActionTargetLocationToString:action.targetLocation],
					 action.objectID];
	[cli debugMsg:msg level:5];
	
	// If action target location was not specified, assume hand for delver cards and dice
	if (((action.target == PlayerActionTargetDelver) || (action.target == PlayerActionTargetDice))
		&& (action.targetLocation == PlayerActionTargetLocationNotSet)) {
		[cli put:@"You didn't specify, so examining from Hand (options are hand or board)" withNewline:true];
		action.targetLocation = PlayerActionTargetLocationHand;
	}

	// If action target location was not specified, assume board for wonders and ruins
	if (((action.target == PlayerActionTargetWonder) || (action.target == PlayerActionTargetRuin))
		&& (action.targetLocation == PlayerActionTargetLocationNotSet)) {
		[cli put:@"You didn't specify, so examining from Board (options are hand or board)" withNewline:true];
		action.targetLocation = PlayerActionTargetLocationBoard;
	}

	
	switch (action.target) {
		
		case PlayerActionTargetWonder:
			switch (action.targetLocation) {
				case PlayerActionTargetLocationHand:
					[cli put:[[player getWonderByID:action.objectID] toString] withNewline:true];
					break;
					
				case PlayerActionTargetLocationBoard:
					[cli put:[[self getWonderByID:action.objectID] toString] withNewline:true];
					break;
					
				default:
					bShowNotYetImplementedMsg = true;
					break;

			}
			break;
			
		case PlayerActionTargetRuin:
			switch (action.targetLocation) {
				case PlayerActionTargetLocationHand:
					[cli put:[[player getRuinByID:action.objectID] toString] withNewline:true];
					break;
					
				case PlayerActionTargetLocationBoard:
					[cli put:[[self getRuinByID:action.objectID] toString] withNewline:true];
					break;
					
				default:
					bShowNotYetImplementedMsg = true;
					break;

			}
			break;

		default:
			bShowNotYetImplementedMsg = true;
			break;

	} // switch action.target
		

	if(bShowNotYetImplementedMsg) {
		msg = [[NSString alloc] initWithFormat:@"UGE.doActionExamine:player(): Recieved Target=%@ with Location=%@, not yet implemented",
			   [UnearthPlayer PlayerActionTargetToString:action.target],
			   [UnearthPlayer PlayerActionTargetLocationToString:action.targetLocation]];

	}

}

- (void) doActionShow: (struct PlayerAction) action player: (UnearthPlayer *) player {
	// Valid show targets are delver, dice (in hand), map, ruin (hand or board), wonder (hand or board)

	bool bShowNotYetImplementedMsg = false;
	
 	NSString *msg = [[NSString alloc] initWithFormat:@"In UGE.doActionShow with verb=%@ target=%@ location=%@ objectID=%ld\n",
					 [UnearthPlayer PlayerActionVerbToString:action.verb],
					 [UnearthPlayer PlayerActionTargetToString:action.target],
					 [UnearthPlayer PlayerActionTargetLocationToString:action.targetLocation],
					 action.objectID];
	[cli debugMsg:msg level:5];
		
	// If Show action target location was not specified, assume hand for delver cards and dice
	if (((action.target == PlayerActionTargetDelver) || (action.target == PlayerActionTargetDice))
		&& (action.targetLocation == PlayerActionTargetLocationNotSet)) {
		[cli put:@"You didn't specify, so showing from Hand (options are hand or board)" withNewline:true];
		action.targetLocation = PlayerActionTargetLocationHand;
	}

	// If Show action target location was not specified, assume board for wonders and ruins
	if (((action.target == PlayerActionTargetWonder) || (action.target == PlayerActionTargetRuin))
		&& (action.targetLocation == PlayerActionTargetLocationNotSet)) {
		[cli put:@"You didn't specify, so showing from Board (options are hand or board)" withNewline:true];
		action.targetLocation = PlayerActionTargetLocationBoard;
	}
	
	/*
	 Future Enhancement: PlayerActionTarget... enum not yet implemented:
	 PlayerActionTargetHelp   = 1
		Never gets hit b/c UP.parsePlayerActionVerbFromString always returns first verb occurrence,
		  e.g. show delver help always returns "help" as the action instead of "show".
	 
	 */
	switch (action.target) {
		case PlayerActionTargetDelver:
			switch(action.targetLocation) {
				case PlayerActionTargetLocationHand:
					[cli put:[player showDelverCards]];
					break;
			
				case PlayerActionTargetLocationBoard:
					[cli put:[self showDelverCardsInPlay]];
					break;

				default:
					bShowNotYetImplementedMsg = true;
					break;

			}
			break;
		
		case PlayerActionTargetDice:
			switch(action.targetLocation) {
				case PlayerActionTargetLocationHand:
					[cli put:[player showDice]];
					break;
			
				case PlayerActionTargetLocationBoard:
					bShowNotYetImplementedMsg = true;
					break;
					
				default:
					bShowNotYetImplementedMsg = true;
					break;
					
			}
			break;

		case PlayerActionTargetMap:
			// Note: only valid target location for map is Hand.
			[player showMap];
			break;
			
		case PlayerActionTargetRuin:
			switch (action.targetLocation) {
				case PlayerActionTargetLocationHand:
					if (action.objectID == 999)
						[cli put:[player showRuinCards]];
					else
						[cli put:[[player getRuinByID:action.objectID] toString] withNewline:true];
					break;
					
				case PlayerActionTargetLocationBoard:
					if (action.objectID == 999)
						[cli put:[self showRuinsOnTable]];
					else
						[cli put:[[self getRuinByID:action.objectID] toString] withNewline:true];
					break;
					
				default:
					bShowNotYetImplementedMsg = true;
					break;

			}
			break;
			
		case PlayerActionTargetWonder:
			switch (action.targetLocation) {
				case PlayerActionTargetLocationHand:
					if (action.objectID == 999)
						[player showMapWonders];
					else
						// TODO: Show wonder details for ID specified
						[cli put:[self showWonderDetailsinPlayerHand:player forWonderID: action.objectID]];
					break;
					
				case PlayerActionTargetLocationBoard:
					if (action.objectID == 999)
						// No specific card was specified
						[cli put:[self showWondersOnTable]];
					else
						// TODO: Show wonder details for ID specified
						[cli put:[self showWonderDetailsOnTable: action.objectID]];
						
					break;
					
				default:
					bShowNotYetImplementedMsg = true;
					break;

			}
			break;
			
		case PlayerActionTargetBoard:
			// Show wonders and ruin cards currently on the table
			[cli put:[self showWondersOnTable]];
			[cli put:[self showRuinsOnTable]];
			break;

		default:
			bShowNotYetImplementedMsg = true;

	} // switch action.target
	
	if(bShowNotYetImplementedMsg) {
		msg = [[NSString alloc] initWithFormat:@"UGE.doActionShow:player(): Recieved Target=%@ with Location=%@, not yet implemented",
			   [UnearthPlayer PlayerActionTargetToString:action.target],
			   [UnearthPlayer PlayerActionTargetLocationToString:action.targetLocation]];

	}

}

- (GameState) gameState {
	return gameState;
	
}

- (void) returnDiceFromCard: (RuinCard *) card {
	
	DelverDie *die = [card removeDieFromCard];
	DelverDieColor color = [die getDieColor];
	
	while (die != nil) {
		for (UnearthPlayer *player in players)
			if ([player getDelverDieColor] == color) {
				[player addDie:die];
				break;
			}
		die = [card removeDieFromCard];
		color = [die getDieColor];
		
	}

}

- (void) returnStonesFromCard: (RuinCard *) card {

	// TODO: Implement after StoneBag converted to use mutable array.
	
}

@end
