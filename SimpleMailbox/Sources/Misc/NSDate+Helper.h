//
//  NSDate+Helper.h
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)

+ (NSDate*)dateWithString:(NSString*)string;
+ (NSString*)dateStringWithDate:(NSDate*)date;

- (BOOL)isToday;

@end
