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
    
    // Assume not debugging until validateArgs() proves overwise.
    bInDebug = true;
    cli = [[CommandLineInterface alloc] init];
    [self loadQConfigDictionary];
    
    return self;
    
}


- (void) showUsage {
    // Display appropriate invocation options.
    
    [cli put:@"Usage: unearth -action {dotest | defaultstart } -test n \n"];
    
}
    
- (bool) loadQConfigDictionary {
    // Populates the QConfig dictionary object from the plist file.
    // Note: debug messages won't appear from init b/c debug is assumed false until args validated.
    bool bRval = false;
    
    NSBundle *main = [NSBundle mainBundle];
    if (main == nil)
        [self debugMsg:@"UGF.loadQCD() main bundle returned nil.\n"];
    else {
        NSString *msg = [[NSString alloc] initWithFormat:@"lQCD() main bundle acquired.\n\tPath = %s.\n",
                                                            [[main bundlePath] UTF8String]];
        [self debugMsg:msg];
        
    }
    
    NSString *configFilePath = [main pathForResource:@"QConfig" ofType:@"plist" inDirectory:@"QData"];
    NSString *msg = [[NSString alloc] initWithFormat:@"Resource path for QConfig file acquired.\n\tPath = %@\n", configFilePath];
    [self debugMsg:msg];
    
    if (configFilePath != nil) {
        // Load QConfig, it is a dictionary.  Expecting it to contain a key of 'data' with a value of 'QData'
        dictQConfig = [[NSDictionary alloc] initWithContentsOfFile:configFilePath];
        
        msg = @"QConfig keys follow:\n";
        [self debugMsg:msg];
        for (NSString *aKey in [dictQConfig allKeys]) {
            msg = [[NSString alloc] initWithFormat:@"\tKey [%@] = [%@]\n",
                                                    aKey, [dictQConfig valueForKey:aKey]];
            [self debugMsg:msg];
            
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
            
    }
    
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
    
    // Note: including a tilde here causes the full URL to include the path to the running app
    //         before the tilde. This is not documented, m/b a bug in XCode.
    NSString *dataFolder = @"~UnearthData/";
    NSURL *baseURL = [NSURL fileURLWithPath:dataFolder isDirectory:true];
    
    NSURL *urlRelativeDelverCardData = [NSURL URLWithString:@"_DelverCards.plist" relativeToURL:baseURL];
    NSString *msg = [[NSString alloc] initWithFormat:@"UGF.tRDCDfL(): Got full url from base %s.\n",
                                            [[urlRelativeDelverCardData absoluteString] UTF8String]];
    [cli put:msg];
    
    NSArray *delverCardData = [[NSArray alloc] initWithContentsOfURL:urlRelativeDelverCardData];
    
    if ([delverCardData count] < 1)
        [cli put:@"\t Got zero cards in data file\n"];
    
    for(NSString *aCardData in delverCardData) {
        msg = [[NSString alloc] initWithFormat:@"\tGot Card %@\n", aCardData];
        [cli put:msg];
    }
    rval = 0;
    
    return rval;
    
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
    

- (NSString *) getValueFromQConfigForKey: (NSString *) key {
        // Returns the value in QConfig.plist associated with the specified key.
    
    NSString *rval = @"NOT_SET";
    
    // See if the requested key's value can be read.
    NSString *dataValue = [dictQConfig objectForKey:key];
    NSString *msg = [[NSString alloc] initWithFormat: @"UGF.gVFQCFK() Got value for [%s] key of [%s]\n",
                                                            [key UTF8String], [dataValue UTF8String]];
    [self debugMsg:msg];
    
    rval = dataValue;
    
    return rval;
    
}

- (bool) validateArguments: (ArgParser *) argParser {
    // Return true if the params specified are valid and complete.
    
    bool bRval = true;
    NSString *action = @"NOT_SET";
    
    if ([argParser isInArgs:@"-action" withAValue:true]) {
        action = [[argParser getArgValue:@"-action"] lowercaseString];
    }
    else {
        [cli put:@"Error UGF.validateArguments(): Missing required parameter: -action.  Can not continue.\n"];
        bRval = false;
    }
    
    if ([argParser isInArgs:@"-debug" withAValue:false]) {
        [cli put:@"UGF.validateArguments() Info, debug parameter detected.\n"];
        bInDebug = true;
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

- (UnearthGameEngine *) makeGame {
    
    UnearthGameEngine *uge = [[UnearthGameEngine alloc] init];
    
    // TODO: Define better set of default params to be used with UGF.makeGame generic method.
    NSString *params = [self getValueFromQConfigForKey:@"DefaultStartParams"]; //@"-action dotest -test 5 -debug";
    ArgParser *ap = [[ArgParser alloc] init];
    [ap populateArgParserFromString:params];
    uge = [self makeGameWithArgs:ap];
    
    return uge;

}

- (UnearthGameEngine *) makeGameWithArgs: (ArgParser *) ap {
    
    UnearthGameEngine *uge;
    
    if ([ap doesArg:@"-action" haveValue:@"defaultstart"]) {
        [cli put:@"Detected startup with defaultStart parameters requested.\n"];
        uge = [self makeGame];
    }
    else {
        uge = [[UnearthGameEngine alloc] init];

        // TODO: Expand UGE.makeGameWithArgs to handle addn'l -action param values.
        if ([ap doesArg:@"-action" haveValue:@"dotest"]) {
            // Get test number
            NSInteger testNumber = [[ap getArgValue:@"-test"] integerValue];
            [self doTest:testNumber];
            
        }
            
    }
    
    return uge;
    
}

- (void) debugMsg: (NSString *) msg {
    // If debug mode is turned on output the specified message via the command line interface.
    
    if (bInDebug)
        [cli put:msg];
    
}

@end
