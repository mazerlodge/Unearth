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
    
    return self;
    
}


- (void) showUsage {
    // Display appropriate invocation options.
    
    printf("Usage: unearth -action {dotest | defaultstart } -test n \n");
    
}

- (int) doTest: (NSInteger) testNumber {
    
    int rval = -1;
    
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
    NSString *tildePath = @"~/Documents/UnearthData/_DelverCards.plist";
    NSString *fullPath = [tildePath stringByExpandingTildeInPath];
    printf("UGF.tRDCD(): Got string %s.\n", [fullPath UTF8String]);
    
    NSArray *delverCardData = [[NSArray alloc] initWithContentsOfFile:fullPath];
    
    if ([delverCardData count] < 1)
        printf("\t Got zero cards in data file\n");
    
    for(NSString *aCardData in delverCardData)
        printf("\tGot Card %s\n", [aCardData UTF8String]);
    
    rval = 0;
    
    return rval;
    
}


- (int) testReadDelverCardDataWithURL {
    
    int rval = -1;
    
    // Tilde in path expansion, the pedestrian way.
    NSString *tildePath = @"~/Documents/UnearthData/_DelverCards.plist";
    NSString *fullPath = [tildePath stringByExpandingTildeInPath];
    printf("UGF.tRDCDwURL(): Got string %s.\n", [fullPath UTF8String]);
    
    // Use string to populate NSURL object.
    NSURL *urlDelverCardData = [NSURL fileURLWithPath:fullPath];
    printf("UGF.tRDCDwURL(): Got URL absolute path %s.\n", [[urlDelverCardData absoluteString] UTF8String]);
    
    // Read data file into Array using NSURL object.
    NSArray *delverCardData = [[NSArray alloc] initWithContentsOfURL:urlDelverCardData];
    
    if ([delverCardData count] < 1)
        printf("\t Got zero cards in data file\n");
    
    for(NSString *aCardData in delverCardData)
        printf("\tGot Card %s\n", [aCardData UTF8String]);
    
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
    printf("UGF.tRDCDfL(): Got full url from base %s.\n", [[urlRelativeDelverCardData absoluteString] UTF8String]);
    
    NSArray *delverCardData = [[NSArray alloc] initWithContentsOfURL:urlRelativeDelverCardData];
    
    if ([delverCardData count] < 1)
        printf("\t Got zero cards in data file\n");
    
    for(NSString *aCardData in delverCardData)
        printf("\tGot Card %s\n", [aCardData UTF8String]);
    
    rval = 0;
    
    return rval;
    
}


- (int) testExpandTildeInPath {
    
    int rval = -1;
    
    // TEST to see tilde in path expansion, the pedestrian way.
    NSString *tildePath = @"~/Documents";
    NSString *test = [tildePath stringByExpandingTildeInPath];
    printf("UGF.testExpandTildeInPath(): %s.\n", [test UTF8String]);
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
    NSLog(@"tGASF() application Support directory %s", [[applicationSupport absoluteString] UTF8String]);
    
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if (identifier != nil) {
        NSURL *folder = [applicationSupport URLByAppendingPathComponent:identifier];
        [manager createDirectoryAtURL:folder withIntermediateDirectories:true attributes:nil error:&error];
        NSURL *fileURL = [folder URLByAppendingPathComponent:@"QLog.txt"];
        NSLog(@"NSURL file path = %@\n", [fileURL path]);
        
    }
    else {
        NSLog(@"tGASF() Attempt to get NSBundle identifer returned nil.\n");
        
    }

    return rval;
    
}

- (int) testAccessingBundle {
    int rval = -1;
    
    NSBundle *main = [NSBundle mainBundle];
    if (main == nil)
        NSLog(@"tETIP() main bundle returned nil.\n");
    else
        NSLog(@"tETIP() main bundle acquired, path = %s.\n", [[main bundlePath] UTF8String]);
        
    NSString *configFilePath = [main pathForResource:@"QConfig" ofType:@"plist" inDirectory:@"QData"];
    NSLog(@"Got resource path for QConfig file: %@\n", configFilePath);
    
    if (configFilePath != nil) {
        // Load QConfig, it is a dictionary.  Expecting it to contain a key of 'data' with a value of 'QData'
        NSDictionary *dictConfig = [[NSDictionary alloc] initWithContentsOfFile:configFilePath];
     
        for (NSString *aKey in [dictConfig allKeys])
            NSLog(@"\t Got key [%s]", [aKey UTF8String]);
        
        // See if the 'data' key's value can be read.
        NSString *dataValue = [dictConfig objectForKey:@"data"];
        NSLog(@"\t Got value for 'data' key of [%s]\n", [dataValue UTF8String]); 
        
    }
    
    
    return rval;
    
}

- (int) testEnumerationReach {
    
    int rval = -1;
    
    // TEST to see if code can reach player type enumeration.
    UnearthPlayerType q = UnearthPlayerHuman;
    if (q == UnearthPlayerHuman) {
        printf("UGF.testEnumerationReach(): Able to read Enumerations confirmed.\n");
        rval = 0;
    }
    
    return rval;
    
}

- (int) testScanf {
    
    int rval = 0;
    
    // How to scan for integers
    int iVal = 0;
    printf("Did that help (1=y, 2=n)?");
    scanf("%i",&iVal);
    printf("You said %i\n", iVal);
    
    // How to scan for strings, fails with large strings.
    // This is OK: upercalafragileistice
    // This isn't: upercalafragileisticex
    // This causes 'illegal instruction': upercalafragileisticexpealli
    char inputVal;// = "NOT_SET";
    printf("Did that help (Y/N)?");
    scanf("%s", &inputVal);
    NSString *inMessage = [NSString stringWithCString:&inputVal encoding:NSUTF8StringEncoding];
    printf("You said %s\n", [inMessage UTF8String]);
    
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
        printf("Expected 4.2, got %f\n", test4point2);
    }
    
    NSString *testResult = [[NSString alloc] initWithFormat:@"test result = %d", rval];
    [cli put:testResult];
    
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
        printf("Error UGF.validateArguments(): Missing required parameter: -action.  Can not continue.\n");
        bRval = false;
    }
    
    if ([argParser isInArgs:@"-debug" withAValue:false]) {
        printf("Info, UGF.validateArguments(): Debug parameter detected.\n");
        // TODO: Add DumpArgs method to argParser class and invoke it in UGF.validateArguments()
        [argParser dumpArgs];
        
    }
    
    // If action is doTest, must also have test number specified.
    if ([action isEqualToString:@"dotest"]) {
        if (![argParser isInArgs:@"-test" withAValue:true]) {
            printf("Error UGF.validateArguments(): action doTest requires test number be specified.\n");
            bRval = false;
        }
    }
    
    
    return bRval;
    
}

- (UnearthGameEngine *) makeGame {
    
    UnearthGameEngine *uge = [[UnearthGameEngine alloc] init];
    
    // TODO: Define set of default params to be used with UGF.makeGame generic method.
    NSString *params = @"-action dotest -test 1 -debug";
    ArgParser *ap = [[ArgParser alloc] init];
    [ap populateArgParserFromString:params];
    
    return uge;
    
    
}

- (UnearthGameEngine *) makeGameWithArgs: (ArgParser *) ap {
    
    UnearthGameEngine *uge;
    
    if ([ap doesArg:@"-action" haveValue:@"defaultstart"]) {
        printf("Detected startup with defaultStart parameters requested.\n");
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


@end
