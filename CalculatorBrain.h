//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Iain Smith on 19/11/2011.
//  Copyright (c) 2011 b099l3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)clearProgramStack;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;

@end
