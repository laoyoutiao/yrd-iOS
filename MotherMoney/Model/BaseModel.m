//
//  BaseModel.m
//  Project1
//
//  Created by 贝沃it on 15/6/9.
//  Copyright (c) 2015年 贝沃it. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel


-(id)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        [self setAttritute:dic];
    }

    return self;
}

-(void)setAttritute:(NSDictionary *)dic{

    for (NSString *key in dic) {
        
        //截取字符串的第一个字符
        NSString *bagan = [[key substringToIndex:1] uppercaseString];
        
        NSString *end = [key substringFromIndex:1];
        
        //拼出set方法的方法名
        NSString *mothodString = [NSString stringWithFormat:@"set%@%@:",bagan,end];
        
        //转换出set方法
        SEL mothod = NSSelectorFromString(mothodString);
        
        if (mothod && [self respondsToSelector:mothod]) {
            
            //给set方法赋值
            [self performSelector:mothod withObject:[dic objectForKey:key]];
        }
        
    }
    
    for(NSString *key1 in _map){
    
        
        SEL mothod = NSSelectorFromString([_map objectForKey:key1]);
        
        if (mothod && [self respondsToSelector:mothod]) {
            
            //给set方法赋值
            [self performSelector:mothod withObject:[dic objectForKey:key1]];
        }
    
    }


}

@end
