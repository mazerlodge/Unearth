//
//  UnearthGameFactory.m
//  Unearth
//
//  Created by mazerlodge on 7/1/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "UnearthGameFactory.h"

@implementation UnearthGameFactory

- (id) init {
    re = [[RandomEngine alloc] init];
    return self;
    
}

- (id) initWithArgParser:(ArgParser *)argParser {
    
    // Assume not debugging until validateArgs() proves overwise.
    bInDebug = [ap isInArgs:@"-debug" withAValue:false];
	if (bInDebug)
		minDebugMsgLevel = (int) [[ap getArgValue:@"-debuglevel"] integerValue];
	else
		minDebugMsgLevel = -1;
    ap = argParser;
    re = [[RandomEngine alloc] init];
    cli = [[CommandLineInterface alloc] init];
    [self loadQConfigDictionary];
    
    return self;
    
}


- (void) showUsage {
    // Display appropriate invocation options.
    
    NSString *usageMsg = [[NSString alloc] initWithFormat:@"%@%@%@",
                          @"Usage: unearth -action {dotest | playgame | defaultstart }.\n",
                          @"\t-action dotest requires param: -test n. \n",
						  @"\tOptional Params: -debug -debuglevel (int)\n"];
    
    [cli put:usageMsg];
    
}
    
- (bool) loadQConfigDictionary {
    // Populates the QConfig dictionary object from the plist file.
    // Note: debug messages won't appear from init b/c debug is assumed false until args validated.
    bool bRval = false;
    
    NSBundle *main = [NSBundle mainBundle];
    if (main == nil)
        [self debugMsg:@"UGF.loadQCD() main bundle returned nil." level:1];
    else {
        NSString *msg = [[NSString alloc] initWithFormat:@"lQCD() main bundle acquired.\n\tPath = %s.",
                                                            [[main bundlePath] UTF8String]];
        [self debugMsg:msg level:1];
        
    }
    
    NSString *configFilePath = [main pathForResource:@"QConfig" ofType:@"plist" inDirectory:@"QData"];
    NSString *msg = [[NSString alloc] initWithFormat:@"Resource path for QConfig file acquired.\n\tPath = %@\n", configFilePath];
    [self debugMsg:msg level:1];
    
    if (configFilePath != nil) {
        // Load QConfig, it is a dictionary.  Expecting it to contain a key of 'data' with a value of 'QData'
        dictQConfig = [[NSDictionary alloc] initWithContentsOfFile:configFilePath];
        
        msg = @"QConfig keys follow:\n";
        [self debugMsg:msg level:1];
        for (NSString *aKey in [dictQConfig allKeys]) {
            msg = [[NSString alloc] initWithFormat:@"\tKey [%@] = [%@]\n",
                                                    aKey, [dictQConfig valueForKey:aKey]];
            [self debugMsg:msg level:1];
            
        }
        
        if ([dictQConfig count] > 0)
            bRval = true;
    }

    return bRval;
    
}

- (int) doTest: (NSInteger) testNumber {
    
    int rval = -1;
    
    NSString *msg = [[NSString alloc] initWithFormat:@"UGF.doTest() Running test %ld.\n", testNumber];
    [cli put:msg];
    
    switch(testNumber) {
        case 1:
            rval = [self testScanf];
            break;
            
        case 2:
            rval = [self testEnumerationReach];
            break;
            
        case 3:
            rval = [self testCLI];
            break;
            
        case 4:
            rval = [self testExpandTildeInPath];
            break;
            
        case 5:
            rval = [self testReadDelverCardDataWithFile];
            break;
            
        case 6:
            rval = [self testReadDelverCardDataWithURL];
            break;
            
        case 7:
            rval = [self testReadDelverCardDataFromLibrary];
            break;
            
        case 8:
            rval = [self testAccessingBundle];
            break;
            
        case 9:
            rval = [self testGettingAppSupportFolder];
            break;
            
        case 10:
            rval = [self testStoneBagGeneration];
            break;
            
        case 11:
            rval = [self testMakePlayerArray];
            break;
			
		case 12:
			rval = [self testPlayerMap];
			break;
            
    }
    
    return rval;
    
}

- (int) testPlayerMap {
	// Test placing a loop of stones then a lesser wonder in the middle
	
	int rval = -1;
	
	[self debugMsg:@"In test playermap." level:4];
	
	return rval;
	
}

- (int) testReadDelverCardDataWithFile {
    
    int rval = -1;
    
    // Tilde in path expansion, the pedestrian way.
    NSString *tildePath = @"~/Documents/UnearthData/_QDelverCards.plist";
    NSString *fullPath = [tildePath stringByExpandingTildeInPath];
    NSString *msg = [[NSString alloc] initWithFormat:@"UGF.tRDCD(): Got path %@.\n", fullPath];
    [cli put:msg];
    
    NSArray *delverCardData = [[NSArray alloc] initWithContentsOfFile:fullPath];
    
    if ([delverCardData count] < 1)
        [cli put:@"\t Got zero cards in data file\n"];
    
    for(NSString *aCardData in delverCardData) {
        msg = [[NSString alloc] initWithFormat:@"\tGot Card %@\n", aCardData];
        [cli put:msg];
    }
    rval = 0;
    
    return rval;
    
}


- (int) testReadDelverCardDataWithURL {
    
    int rval = -1;
    
    // Tilde in path expansion, the pedestrian way.
    NSString *tildePath = @"~/Documents/UnearthData/_DelverCards.plist";
    NSString *fullPath = [tildePath stringByExpandingTildeInPath];
    NSString *msg = [[NSString alloc] initWithFormat:@"UGF.tRDCDwURL(): Got path %s.\n", [fullPath UTF8String]];
    [cli put:msg];
    
    // Use string to populate NSURL object.
    NSURL *urlDelverCardData = [NSURL fileURLWithPath:fullPath];
    msg = [[NSString alloc] initWithFormat:@"UGF.tRDCDwURL(): Got URL absolute path %s.\n",
                                    [[urlDelverCardData absoluteString] UTF8String]];
    [cli put:msg];
    
    // Read data file into Array using NSURL object.
    NSArray *delverCardData = [[NSArray alloc] initWithContentsOfURL:urlDelverCardData];
    
    if ([delverCardData count] < 1)
    [cli put:@"\t Got zero cards in data file\n"];
    
    for(NSString *aCardData in delverCardData) {
        msg = [[NSString alloc] initWithFormat:@"\tGot Card %s\n", [aCardData UTF8String]];
        [cli put:msg];
    }
    rval = 0;
    
    return rval;
    
}

- (int) testReadDelverCardDataFromLibrary {
    
    int rval = -1;
    
    NSArray *delverCardData = [self getDataForQConfigKey:@"DataFile_DelverCards"];
    
    if ([delverCardData count] < 1)
        [cli put:@"\t Got zero cards in data file\n"];
    
    for(NSString *aCardData in delverCardData) {
        NSString *msg = [[NSString alloc] initWithFormat:@"\tGot Card %@\n", aCardData];
        [cli put:msg];
    }
    rval = 0;
    
    return rval;
    
}

- (NSArray *) getDataForQConfigKey: (NSString *) qConfigKey {
    // Given a QConfig key, get the associated data file (typically a plist)
    // relative to the executable path and return it's contents as an NSArray.

    
    // Note: Including a tilde in NSURL's fileURLWithPath method causes the full URL
    //          to include the path to the running app before the tilde.
    //          This is not documented, m/b a bug in XCode.
    

    // Get executable path...
    NSMutableString *workingPath = [[NSMutableString alloc] initWithString:[ap getArgByNumber:0]];
    
    // ... then back off the executable name...
    NSRange lastSlashtoEndRange = [workingPath rangeOfString:@"/" options:NSBackwardsSearch];
    lastSlashtoEndRange.length = [workingPath length] - lastSlashtoEndRange.location;
    [workingPath deleteCharactersInRange:lastSlashtoEndRange];
    
    // ... and append the QData folder...
    NSString *dataFolder = [[NSString alloc] initWithFormat:@"%@/QData", workingPath];
    NSURL *baseURL = [NSURL fileURLWithPath:dataFolder isDirectory:true];
    
    // ... and the data file name (from QConfig.plist)
    NSString *delverCardDataFilename = [self getValueFromQConfigForKey:qConfigKey];
    NSURL *urlRelativeDelverCardData = [NSURL URLWithString:delverCardDataFilename relativeToURL:baseURL];
    NSString *msg = [[NSString alloc] initWithFormat:@"UGF.tRDCDfL(): Got full url from base %s.",
                     [[urlRelativeDelverCardData absoluteString] UTF8String]];
    [self debugMsg:msg level:1];
    
    NSArray *data = [[NSArray alloc] initWithContentsOfURL:urlRelativeDelverCardData];
    
    return data;
    
}


- (int) testExpandTildeInPath {
    
    int rval = -1;
    
    // TEST to see tilde in path expansion, the pedestrian way.
    NSString *tildePath = @"~/Documents";
    NSString *test = [tildePath stringByExpandingTildeInPath];
    
    NSString *msg = [[NSString alloc] initWithFormat:@"UGF.testExpandTildeInPath(): %s.\n", [test UTF8String]];
    [cli put:msg];
    
    rval = 0;
    

    return rval;
    
}

- (int) testGettingAppSupportFolder {
    
    int rval = -1;
    
    // Test getting current application
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *applicationSupport = [manager URLForDirectory:NSApplicationSupportDirectory
                                                inDomain:NSUserDomainMask
                                       appropriateForURL:nil
                                                  create:false
                                                   error:&error];
    NSString *msg = [[NSString alloc] initWithFormat:@"testGASF() application Support directory acquired.\n\tPath: %@\n",
                                                        [applicationSupport absoluteString]];
    [cli put:msg];

    // Get app support folder and log file names from QConfig plist.
    NSString *appSupportFolder = [self getValueFromQConfigForKey:@"AppSupportFolder"];
    NSString *logFilename = [self getValueFromQConfigForKey:@"LogFile"];
    
    // Attempt to make a folder for writing save information.
    NSURL *folder = [applicationSupport URLByAppendingPathComponent:appSupportFolder];
    
    // Create the AppSupport subdirectory (if it doesn't exist).
    [manager createDirectoryAtURL:folder withIntermediateDirectories:true attributes:nil error:&error];

    NSURL *fileURL = [folder URLByAppendingPathComponent:logFilename];
    msg = [[NSString alloc] initWithFormat:@"NSURL file path = %@\n", [fileURL path]];
    [cli put:msg];
    
    /*
    Another way to get data for writing to file.
    NSString *configFilePath = [[NSBundle mainBundle] pathForResource:@"QConfig" ofType:@"plist" inDirectory:@"QData"];
    NSData *someNoise = [NSData dataWithContentsOfFile:configFilePath];
    */
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
    msg = [[NSString alloc] initWithFormat:@"Sending datestamp to file [%@]\n", timeStamp];
    [cli put:msg];

    // Make a file in the support folder
    BOOL bResult = [manager createFileAtPath:[fileURL path]
                                    contents:[timeStamp dataUsingEncoding:NSUTF8StringEncoding]
                                  attributes:nil];
    if (bResult == YES)
        [cli put:@"File created or already existed.\n"];
    else
        [cli put:@"File creation returned false.\n"];
    
    return rval;
    
}

- (int) testAccessingBundle {
    int rval = -1;
    
    NSBundle *main = [NSBundle mainBundle];
    if (main == nil)
        [cli put:@"tETIP() main bundle returned nil.\n"];
    else {
        NSString *msg = [[NSString alloc] initWithFormat:@"tETIP() main bundle acquired, path = %s.\n", [[main bundlePath] UTF8String]];
        [cli put:msg];
    }
        
    NSString *configFilePath = [main pathForResource:@"QConfig" ofType:@"plist" inDirectory:@"QData"];
    
    NSString *msg = [[NSString alloc] initWithFormat:@"Got resource path for QConfig file: %@\n", configFilePath];
    [cli put:msg];
    
    if (configFilePath != nil) {
        // Load QConfig, it is a dictionary.  Expecting it to contain a key of 'data' with a value of 'QData'
        NSDictionary *dictConfig = [[NSDictionary alloc] initWithContentsOfFile:configFilePath];
        msg = @"QConfig key/value pairs follow:\n";
        [cli put:msg];
        
        for (NSString *aKey in [dictConfig allKeys]) {
            msg = [[NSString alloc] initWithFormat:@"\t Got key [%s]\n", [aKey UTF8String]];
            [cli put:msg];
        }
        
        // See if the 'data' key's value can be read.
        NSString *dataValue = [dictConfig objectForKey:@"data"];
        msg = [[NSString alloc] initWithFormat:@"\t Got value for 'data' key of [%s]\n", [dataValue UTF8String]];
        [cli put:msg];
        
    }
    
    
    return rval;
    
}

- (int) testEnumerationReach {
    
    int rval = -1;
    
    // TEST to see if code can reach player type enumeration.
    UnearthPlayerType q = UnearthPlayerHuman;
    if (q == UnearthPlayerHuman) {
        [cli put:@"UGF.testEnumerationReach(): Able to read Enumerations confirmed.\n"];
        rval = 0;
    }
    
    return rval;
    
}

- (int) testScanf {
    
    int rval = 0;
    
    // How to scan for integers
    int iVal = 0;
    iVal = [cli getInt:@"Did that help (1=y, 2=n)?"];
    NSString *msg = [[NSString alloc] initWithFormat:@"You said %i\n", iVal];
    [cli put:msg];
    
    // How to scan for strings
    NSString *inMessage = [cli getStr:@"Did that help (Y/N)?"];
    msg = [[NSString alloc] initWithFormat:@"You said %@\n", inMessage];
    
    return rval;

}

- (int) testCLI {
    // Test command line interface class
    
    int rval = 0;
    
    CommandLineInterface *cli = [[CommandLineInterface alloc] init];
    
    int test42 = [cli getInt:@"Please enter the number 42 :"];
    if (test42 != 42)
        rval = -1;
    
    NSString *testFoo = [cli getStr:@"Please enter 'foo':"];
    if ([testFoo compare:@"foo"] != NSOrderedSame)
        rval = -10;
        
    float test4point2 = [cli getFloat:@"Please enter '4.2':"];
    if ((test4point2 - 4.2) > 0.001) {
        rval = -100;
        NSString *msg = [[NSString alloc] initWithFormat:@"Expected 4.2, got %f\n", test4point2];
        [cli put:msg];
    }
    
    NSString *testResult = [[NSString alloc] initWithFormat:@"test result = %d\n", rval];
    [cli put:testResult];
    
    return rval;
}

- (int) testStoneBagGeneration {
    // Determine if stone ID 0 is always last stone in the bag.
    
    int passCount = 0;
    
    NSString *msg = [[NSString alloc] initWithFormat:@"UGF.initWAP() Random Seed used = %d.", [re getSeed]];
    [self debugMsg:msg level:1];
    
    for (int x=0; x<200; x++) {
        [self populateStoneBag];
        Stone *lastStone = [stoneBag objectAtIndex:59];
        if ([lastStone getStoneID] != 0)
            passCount++;

    }
    
    NSString *testResult = [[NSString alloc] initWithFormat:@"test result = %d\n", passCount];
    [cli put:testResult];

    return 0;
    
}

- (int) testMakePlayerArray {
    
    int rval = 0;
    
    NSArray *playerArray = [self populatePlayerArray];
    
    NSString *msg = [[NSString alloc] initWithFormat:@"Made player array with %ld elements.\n", [playerArray count]];
    [cli put:msg];
    
    return rval;
    
}

- (NSArray *) populatePlayerArray {


    NSArray *playerArray = [[NSArray alloc] init];
    
    // Ask the user how many players
    int numberOfPlayers = [cli getInt:@"How many players?"];
    
    if ((numberOfPlayers < 1) || (numberOfPlayers > 4)) {
        [cli put:@"UGF.popPlayerArray() Exiting with invalid number of players specified.\n"];
        return playerArray;
    }
    
    for (int x=0; x<numberOfPlayers; x++) {
        NSString *msg = [[NSString alloc] initWithFormat:@"Collecting info for player  #%d.\n", x+1];
        [cli put:msg];
        UnearthPlayer *currentPlayer = [self makePlayer: playerArray];
        playerArray = [playerArray arrayByAddingObject:currentPlayer];
        
    }
    
    return playerArray;
}
    

- (NSString *) getValueFromQConfigForKey: (NSString *) key {
        // Returns the value in QConfig.plist associated with the specified key.
    
    NSString *rval = @"NOT_SET";
    
    // See if the requested key's value can be read.
    NSString *dataValue = [dictQConfig objectForKey:key];
	NSString *msg = [[NSString alloc] initWithFormat: @"UGF.gVfQCfK(): Got value for [%s] key of [%s]",
                                                            [key UTF8String], [dataValue UTF8String]];
    [self debugMsg:msg level:1];
    
    rval = dataValue;
    
    return rval;
    
}

- (bool) validateArguments: (ArgParser *) argParser {
    // Return true if the params specified are valid and complete.
    
    bool bRval = true;
    NSString *action = @"NOT_SET";
	

	// If default start was specified, get startup prams from QConfig.
	if ([argParser doesArg:@"-action" haveValue:@"defaultstart"]) {
		[cli put:@"Detected startup with defaultStart parameters requested.\n"];
		NSString *params = [self getValueFromQConfigForKey:@"DefaultStartParams"];
		NSString *msg = [[NSString alloc] initWithFormat:@"Startup params set to [%@]\n", params];
		[cli put:msg];
		
		// Need to preserve any ags already present (e.g. arg 0, executable path.
		[ap populateArgParserFromString:params preserveZeroParam:true];
		
	}
    
    if ([argParser isInArgs:@"-action" withAValue:true]) {
        action = [[argParser getArgValue:@"-action"] lowercaseString];
    }
    else {
        [cli put:@"Error UGF.validateArguments(): Missing required parameter: -action.  Can not continue.\n"];
        bRval = false;
    }

	if ([argParser isInArgs:@"-debug" withAValue:false]) {
		if ([argParser isInArgs:@"-debuglevel" withAValue:true])
			minDebugMsgLevel = (int) [[ap getArgValue:@"-debuglevel"] integerValue];
		else
			minDebugMsgLevel = -1;

		NSString *msg = [NSString stringWithFormat:@"UGF.validateArguments() Info, debug parameter detected, min debug message level set to %d.\n", minDebugMsgLevel];
        [cli put:msg];
        bInDebug = true;
		
		if (minDebugMsgLevel < 2)
        	[argParser dumpArgsToCLI:cli];
        
    }
    
    // If action is doTest, must also have test number specified.
    if ([action isEqualToString:@"dotest"]) {
        if (![argParser isInArgs:@"-test" withAValue:true]) {
            [cli put:@"Error UGF.validateArguments(): action doTest requires test number be specified.\n"];
            bRval = false;
        }
    }
    
    
    return bRval;
    
}

- (UnearthPlayer *) makePlayer: (NSArray *) existingPlayers {
    // Pass in already existing players to avoid assigning die color already used
    
    // - (id) initWithPlayerType: (UnearthPlayerType) type dieColor: (DelverDieColor) color playerName: (NSString *) name;

    int playerType = -1;
    while (playerType < 0 || playerType > 1) {
        playerType = [cli getInt:@"Select player type (0=human, 1=ai)? "];
    }
    
    int dieColor = -1;
    while (dieColor < 0 || dieColor > 3 || [self isDieColorUsed:dieColor inPlayerArray:existingPlayers]) {
        NSString *msg = [[NSString alloc] initWithFormat:@"Select die color %@?",
                                                         [self getAvailableDieColors:existingPlayers]];
        dieColor = [cli getInt:msg];
    
    }
    
    NSString *name = @"NOT_SET";
    while ([name compare:@"NOT_SET"] == NSOrderedSame || [self isPlayerNameUsed:name inPlayerArray:existingPlayers]) {
        name = [cli getStr:@"Enter unused name for player: "];
    
    }
        
    UnearthPlayer *player = [[UnearthPlayer alloc] initWithPlayerType:playerType
                                                             dieColor:dieColor
                                                           playerName:name];
    
    return player;

}

- (NSString *) getAvailableDieColors: (NSArray *) existingPlayers {
    // Given a list of existing players get the remaining available die colors
    
    NSString *rval = @"(";
    
    NSArray *possibleColors = [[NSArray alloc] initWithObjects:@"0=Orange, ",
                                                               @"1=Yellow, ",
                                                               @"2=Green, ",
                                                               @"3=Blue, ",
                                                               nil];
    
    // Build string of unused colors.
    for (int x=0; x<4; x++) {
        if (![self isDieColorUsed:x inPlayerArray:existingPlayers])
            rval = [rval stringByAppendingString:possibleColors[x]];
        
    }
    
    // remove trailing comma and space, then append closing parenthesis.
    rval = [rval substringToIndex:[rval length]-2];
    rval = [rval stringByAppendingString:@")"];
    
    return rval;
}

- (bool) isDieColorUsed: (int) dieColor inPlayerArray: (NSArray *) existingPlayers {
    bool bRval = false;
    
    for (UnearthPlayer *aPlayer in existingPlayers)
        if ([aPlayer dieColor] == dieColor) {
            bRval = true;
            break;
        }
    
    return bRval;
    
}


- (bool) isPlayerNameUsed: (NSString *) name inPlayerArray: (NSArray *) existingPlayers {
    bool bRval = false;
    
    for (UnearthPlayer *aPlayer in existingPlayers)
        if ([[aPlayer playerName] compare:name] == NSOrderedSame) {
            bRval = true;
            break;
        }
    
    return bRval;
    
}

- (UnearthGameEngine *) makeGameWithArgs: (ArgParser *) argParser {
    
    UnearthGameEngine *uge = [[UnearthGameEngine alloc] init];
    
    // Reference Usage: unearth -action {dotest | defaultstart | playgame }.
    
    // If default start was specified, get startup prams from QConfig.
	/* TODO: Moved default start detection to ugf.validateArguments(), remove this block when fully validated.
    if ([argParser doesArg:@"-action" haveValue:@"defaultstart"]) {
        [cli put:@"Detected startup with defaultStart parameters requested.\n"];
        NSString *params = [self getValueFromQConfigForKey:@"DefaultStartParams"];
        NSString *msg = [[NSString alloc] initWithFormat:@"Startup params set to [%@]\n", params];
        [cli put:msg];
        
        // Need to preserve any ags already present (e.g. arg 0, executable path.
        [ap populateArgParserFromString:params preserveZeroParam:true];
        
    }
	*/
    
    // If factory members haven't been populated, do so now.
    bFactoryMembersPopulated = [self populateFactoryMembers];
    if (!bFactoryMembersPopulated) {
        [self debugMsg:@"ERROR: PopulateFactoryMembers() returned false. Can not continue." level:1];
        
    }
    
    if ([ap doesArg:@"-action" haveValue:@"dotest"]) {
        // Get test number
        NSInteger testNumber = [[ap getArgValue:@"-test"] integerValue];
        [self doTest:testNumber];
        
    }
    
    if ([ap doesArg:@"-action" haveValue:@"playgame"]) {
        NSArray *players = [self populatePlayerArray];
        
        // Get a random end of age card
        int endOfAgeIdx = [re getNextRandBetween:0 maxValueInclusive:4];
        EndOfAgeCard *endOfAgeCard = [endOfAgeDeck objectAtIndex:endOfAgeIdx];

        // TODO: Expand gameDataDict dictionary used to pass info into game engine.
        //       e.g. passing shuffled decks, random end of age card, & stonebag
        NSDictionary *gameDataDict = @{ @"PlayerArray" : players,
                                        @"EndOfAgeCard" : endOfAgeCard,
                                        @"StoneBag" : stoneBag
                                        };
        [uge populateGameFromDictionary:gameDataDict];

    }
    
    return uge;
    
}

- (bool) populateFactoryMembers {
    // Populates decks from plist files.
    bool bRval = true;

    /*
     Decks to build:
     x- wondersDeck  // 15x named, 10x lesser, 6x greater
     x- delverDeck   // 38x generated from n original possibilities
     x- endOfAgeDeck //  5x, shuffled for game, top card used in this game run.
     x- ruinDeck     // 25x, 5x colors and 5x combos of claim and stone value.
     
    */

    const int buildStepCount = 5;
    bool buildResults[buildStepCount] =  {false};
    buildResults[0] = [self populateDelverDeck];
    buildResults[1] = [self populateEndOfAgeDeck];
    buildResults[2] = [self populateRuinDeck];
    buildResults[3] = [self populateWonderDeck];
    
    // Make stone bag, 60x, 15x of each color (defined in Stone.h as StoneColor...)
    buildResults[4] = [self populateStoneBag];
    
    for (int x=0; x<buildStepCount; x++) {
        // if any deck build failed return false.
        if (buildResults[x] == false)
            bRval = false;
    }
    
    return bRval;
    
}

- (bool) populateStoneBag {
    bool bRval = true;
    
    StoneColor allColors[4] = {StoneColorRed,
                                StoneColorYellow,
                                StoneColorBlue,
                                StoneColorBlack};

    NSMutableArray *allStones = [[NSMutableArray alloc] init];
    int idNumber = 0;
    for (int colorIdx=0; colorIdx < 4; colorIdx++) {
        StoneColor currentColor = allColors[colorIdx];
        // make 15 copies of each stone color
        for (int x=0; x<15; x++) {
            Stone *currentStone = [[Stone alloc] initWithColor:currentColor idNumber:idNumber];
            [allStones addObject:currentStone];
            idNumber++;
        } // for x
        
    } // for colorIdx
    
    // Randomize stones
    stoneBag = [[NSArray alloc] init];
    for (int x = 59; x >= 0; x--) {
        NSRange randRange = NSMakeRange(0,x);
        int stoneIdx = [re getNextRandInRange:randRange];
        stoneBag = [stoneBag arrayByAddingObject:[allStones objectAtIndex:stoneIdx]];
        [allStones removeObjectAtIndex:stoneIdx];
        
    }
    
    return bRval;
    
}

- (bool) populateRuinDeck {
    
    bool bRval = true;
    
    // for each ruin card color, make a set of cards
    /*
     Claim Values: 9, 11, 13, 15, 17
     Stone Values: 2,  2,  2,  3,  3
     Colors: 5x as defined in RuinCard header enumeration.
     
     */
    
    int allClaimValues[5] = {9, 11, 13, 15, 17};
    int allStoneValues[5] = {2, 2, 2, 3, 3};
    RuinCardColor allColors[5] = {RuinCardColorPeach,
                                    RuinCardColorGreen,
                                    RuinCardColorBlue,
                                    RuinCardColorPurple,
                                    RuinCardColorGray};
    
    ruinsDeck = [[NSArray alloc] init];
    for (int colorIdx=0; colorIdx < 5; colorIdx++) {
        RuinCardColor currentColor = allColors[colorIdx];
        for (int valueIdx=0; valueIdx < 5; valueIdx++) {
            int currentClaimValue = allClaimValues[valueIdx];
            int currentStoneValue = allStoneValues[valueIdx];
            RuinCard *currentCard = [[RuinCard alloc] initWithColor:currentColor
                                                         claimValue:currentClaimValue
                                                         stoneValue:currentStoneValue];
            ruinsDeck = [ruinsDeck arrayByAddingObject:currentCard];
            
        } // for valueIdx
        
    } // for colorIdx
    
    return bRval;
    
}

- (bool) populateDelverDeck {
    
    bool bRval = true;
    
    delverDeck = [[NSArray alloc] init];
    NSArray *delverCardData = [self getDataForQConfigKey:@"DataFile_DelverCards"];
    for(NSString *aCardData in delverCardData) {
        // Data format is in line zero: #ID, Title, Text, Count
        // Sample data string: 100, Ancient Map, This turn you may reroll your Excavation roll., 5
        
        // if the card data string starts with #, ignore it.
        if ([aCardData characterAtIndex:0] != '#') {
            
            // parse the card data and extract how many of each card type to make
            NSArray *cardDataParts = [aCardData componentsSeparatedByString:@","];
            NSString *strCardInstanceCount = [cardDataParts objectAtIndex:3];
            NSInteger cardInstanceCount = [strCardInstanceCount integerValue];
            
            // Make the specified number of cards, adding them to the delverDeck member.
            for (int x=0; x<cardInstanceCount; x++) {
                DelverCard *aCard = [[DelverCard alloc] initWithString:aCardData];
                delverDeck = [delverDeck arrayByAddingObject:aCard];
                
            } // for x
        } // if != #
    } // for aCardData...
    
    
    NSString *msg = [[NSString alloc] initWithFormat:@"UGF.PopDelverDeck() Built Delver Deck w/ %ld cards.",
                     [delverDeck count]];
    [self debugMsg:msg level:2];
    
    return bRval;
    
}

- (bool) populateEndOfAgeDeck {
    
    bool bRval = true;
    
    endOfAgeDeck = [[NSArray alloc] init];
    NSArray *endOfAgeCardData = [self getDataForQConfigKey:@"DataFile_EndOfAgeCards"];
    for(NSString *aCardData in endOfAgeCardData) {
        // Data format is in line zero: #ID, Title, Text, ClaimValue, StoneValue
        // Sample data string: 200, Day of Rest, Each player draws three cards from the Delver deck, 0, 0
        
        // if the card data string starts with #, ignore it.
        if ([aCardData characterAtIndex:0] != '#') {
            // End of age cards do not have multiple copies, just make one of the card specified.
            EndOfAgeCard *aCard = [[EndOfAgeCard alloc] initWithString:aCardData];
            endOfAgeDeck = [endOfAgeDeck arrayByAddingObject:aCard];

        } // if != #
    } // for aCardData...
    
    
    NSString *msg = [[NSString alloc] initWithFormat:@"UGF.PopEndOfAgeDeck() Built End of Age Deck w/ %ld cards.",
                     [endOfAgeDeck count]];
    [self debugMsg:msg level:2];
    
    return bRval;
    
}

- (bool) populateWonderDeck {
    
    bool bRval = true;
    
    wonderDeck = [[NSArray alloc] init];
    NSArray *wonderCardData = [self getDataForQConfigKey:@"DataFile_WonderCards"];
    for(NSString *aCardData in wonderCardData) {
        // Data format is in line zero: #ID, Title, Text, ColorRule
        // Sample data string: 300, Lesser Wonders, Lesser Wonders are worth between 2 and 4 points, ??????
        
        // if the card data string starts with #, ignore it.
        if ([aCardData characterAtIndex:0] != '#') {
            // Wonder cards do not have multiple copies, just make one of the card specified.
            Wonder *aCard = [[Wonder alloc] initWithString:aCardData];
            wonderDeck = [wonderDeck arrayByAddingObject:aCard];
            
        } // if != #
    } // for aCardData...
    
    
    NSString *msg = [[NSString alloc] initWithFormat:@"UGF.PopWonderDeck() Built Wonder Deck w/ %ld cards.",
                     [wonderDeck count]];
    [self debugMsg:msg level:2];
    
    return bRval;
    
}

- (NSString *) startupAction {
	
	NSString *rval = @"NOT_SET";
	
	if ([ap isInArgs:@"-action" withAValue:true])
		rval = [ap getArgValue:@"-action"];
	
	return rval;
	
}

- (void) debugMsg: (NSString *) msg {
    // If debug mode is turned on output the specified message via the command line interface.
	
	[self debugMsg:msg level:0];
    
}

- (void) debugMsg: (NSString *) msg level: (int) msgLevel {
	// If debug mode is turned on output the specified message via the command line interface.
	
	// Add the message level to the message
	msg = [msg stringByAppendingFormat:@"(Severity: %d)\n", msgLevel];
	
	if (bInDebug && (msgLevel >= minDebugMsgLevel))
		[cli put:msg];
	
}

@end
