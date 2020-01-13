//
//  ArticlesController.h
//  BeenVerifiedTest
//
//  Created by David Saborio Alvarado on 12/21/19.
//  Copyright © 2019 David Saborio Alvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArticlesController : UIView

@property(nonatomic) NSString *title;
-(void) addTitle: (NSString*)text;
-(void) addDescription: (NSString*)text;
-(void) addAuthor: (NSString*)text;
-(void) addDate: (NSString*)text;
-(void) addImage: (NSString*)url;

@end



NS_ASSUME_NONNULL_END
