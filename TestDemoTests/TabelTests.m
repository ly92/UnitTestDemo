//
//  TabelTests.m
//  TestDemo
//
//  Created by 李勇 on 2016/12/29.
//  Copyright © 2016年 aoke. All rights reserved.
//

#import "TabelTests.h"

@implementation TabelTests

/**
 *  每个test方法执行之前调用
 *
 */
- (void)setUp {
    [super setUp];
    //定义
    self.VC = [[ViewController alloc] init];
}

/**
 *  每个test方法执行之后调用,释放测试用例的资源代码，这个方法会每个测试用例执行后调用
 */
- (void)tearDown {
    
    //结束后释放
    self.VC = nil;
    
    [super tearDown];
}



- (void)testControllerReturnsCorrectNumberOfRows
{
    XCTAssertEqual(1, [self.VC tableView:self.VC.tableView numberOfRowsInSection:0],@"此处返回得到的行数错误");
}


- (void)testControllerSetsUpCellCorrectly
{
    id mockTable = OCMClassMock([UITableView class]);
    [[[mockTable expect] andReturn:nil] dequeueReusableCellWithIdentifier:@"HappyNewYear"];
    
    UITableViewCell *cell = [self.VC tableView:mockTable cellForRowAtIndexPath:nil];
    
    XCTAssertNotNil(cell, @"此处应该返回一个cell");
    XCTAssertEqualObjects(@"Happy New Year!", cell.textLabel.text, @"返回的字符串错误");
    
    [mockTable verify];
}
@end
