//
//  PersonTests.m
//  TestDemo
//
//  Created by 李勇 on 2016/12/29.
//  Copyright © 2016年 aoke. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PersonModel.h"
#import <OCMock/OCMock.h>

@interface PersonTests : XCTestCase

@end


@implementation PersonTests
/**
 *  每个test方法执行之前调用
 *
 */
- (void)setUp {
    [super setUp];


}

/**
 *  每个test方法执行之后调用,释放测试用例的资源代码，这个方法会每个测试用例执行后调用
 */
- (void)tearDown {
    
    //结束后释放
    
    [super tearDown];
}

- (void)testPerson{
    PersonModel *person = [[PersonModel alloc] init];
    
    //创建一个mock对象
    id mockClass = OCMClassMock([PersonModel class]);
    //可以给这个mock对象的方法设置预设的参数和返回值
    OCMStub([mockClass getPersonName]).andReturn(@"liyong");
    
    //用这个预设的值和实际的值进行比较是否相等
    XCTAssertEqualObjects([mockClass getPersonName], [person getPersonName], @"值相等");

}



@end
