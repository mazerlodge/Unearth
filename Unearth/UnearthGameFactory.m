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
            
    }
    
    return rval;
    
}


- (int) testExpandTildeInPath {
    
    int rval = -1;
    
    // TEST to see tilde in path expansion, the pedestrian way.
    NSString *tildePath = @"~/Documents";
    NSString *test = [tildePath stringByExpandingTildeInPath];
    printf("UGF.testExpandTildeInPath(): %s.\n", [test UTF8String]);
    rval = 0;
    
    // Maybe better?
    NSBundle *main = [NSBundle mainBundle];
    NSString *resourcePath = [main pathForResource:@"DelverCards" ofType:@"plist"];
    NSLog(@"Got resource path for delver cards: %@\n", resourcePath);
    
    // Test getting current application
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *applicationSupport = [manager URLForDirectory:NSApplicationSupportDirectory
                                                inDomain:NSUserDomainMask
                                       appropriateForURL:nil
                                                  create:false
                                                   error:&error];
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if (identifier != nil) {
        NSURL *folder = [applicationSupport URLByAppendingPathComponent:identifier];
        [manager createDirectoryAtURL:folder withIntermediateDirectories:true attributes:nil error:&error];
        NSURL *fileURL = [folder URLByAppendingPathComponent:@"QLog.txt"];
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
