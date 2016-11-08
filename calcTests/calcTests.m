//
//  calcTests.m
//  calcTests
//
//  Created by Kirill Varlamov on 15.07.16.
//  Copyright © 2016 Kirill Varlamov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Calculator.h"

@interface calcTests : XCTestCase

@end

@implementation calcTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - operationsTest

- (void)testPlusOperation {
    Calculator *calc = [Calculator new];
    [calc setFirstNumber:@5];
    [calc setSecondNumber:@7];
    [calc setOperation:MCPlusOperation];
    XCTAssertEqual([calc actCalculation].doubleValue, 14);
}

- (void)testMinusOperation {
    Calculator *calc = [Calculator new];
    [calc setFirstNumber:@(-58)];
    [calc setSecondNumber:@7];
    [calc setOperation:MCMinusOperation];
    XCTAssertEqual([calc actCalculation].doubleValue, -65);
}

- (void)testMultOperation {
    Calculator *calc = [Calculator new];
    [calc setFirstNumber:@(-40)];
    [calc setSecondNumber:@(-30)];
    [calc setOperation:MCMultOperation];
    XCTAssertEqual([calc actCalculation].doubleValue, 1200);
}

- (void)testDivOperation {
    Calculator *calc = [Calculator new];
    [calc setFirstNumber:@35];
    [calc setSecondNumber:@7];
    [calc setOperation:MCDivOperation];
    XCTAssertEqual([calc actCalculation].doubleValue, 5);
    
    [calc setSecondNumber:@0];
    XCTAssertEqualObjects([calc actCalculation], @"Ошибка");
}

- (void)testNoOpeartion {
    Calculator *calc = [Calculator new];
    [calc setFirstNumber:@35];
    [calc setOperation:MCNoOperation];
    XCTAssertEqual([calc actCalculation].doubleValue, 35);

}

#pragma mark - memoryTest

- (void)testSetMemory {
    Calculator *calc = [Calculator new];
    [calc setMemoryValue:@777 Operation:MCSaveMomory];
    XCTAssertEqualObjects([calc getMemoryValue], @777);
}

- (void)testPlusMemory {
    Calculator *calc = [Calculator new];
    [calc setMemoryValue:@777 Operation:MCSaveMomory];
    [calc setMemoryValue:@333 Operation:MCPlusMemory];
    XCTAssertEqualObjects([calc getMemoryValue], @1110);
}

- (void)testMinusMemory {
    Calculator *calc = [Calculator new];
    [calc setMemoryValue:@500 Operation:MCSaveMomory];
    [calc setMemoryValue:@150 Operation:MCMinusMemory];
    XCTAssertEqualObjects([calc getMemoryValue], @350);
}

- (void)testClearMemory {
    Calculator *calc = [Calculator new];
    [calc setMemoryValue:@500 Operation:MCSaveMomory];
    [calc setMemoryValue:nil Operation:MCClearMemory];
    XCTAssertEqualObjects([calc getMemoryValue], @0);
}

#pragma mark - overflow

- (void)testOverflow {
    Calculator *calc = [Calculator new];
    [calc setFirstNumber:@(DBL_MAX-100)];
    [calc setSecondNumber:@(DBL_MAX)];
    [calc setOperation:MCPlusOperation];
    XCTAssertEqualObjects([calc actCalculation], @"Ошибка");
    
}

@end
