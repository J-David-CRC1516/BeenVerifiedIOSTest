//
//  ArticlesController.m
//  BeenVerifiedTest
//
//  Created by David Saborio Alvarado on 12/21/19.
//  Copyright © 2019 David Saborio Alvarado. All rights reserved.
//

#import "ArticlesController.h"

@interface ArticlesController()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;

@end


@implementation ArticlesController

NSString *webLink;

-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder: aDecoder];
    
    if(self){
        [self customInit];
    }
    
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        [self customInit];
    }
    
    return self;
}

-(void) customInit {
    [[NSBundle mainBundle] loadNibNamed:@"ArticlesView" owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.frame = self.bounds;
}

-(void) addTitle: (NSString*)text{
    _titleLabel.text = text;
}

-(void) addDescription: (NSString*)text{
    _descriptionLabel.text = text;
}

-(void) addAuthor: (NSString*)text{
    _authorLabel.text = text;
}

-(void) addDate: (NSString*)text{
    _dateLabel.text = text;
}

-(void) addImage: (NSString*)url{
    dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    url = [url stringByReplacingOccurrencesOfString:@".com" withString:@".com/fit-in/500x/filters:autojpg()"];
    
    @try{
        dispatch_async(imageQueue, ^{
            
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                    
                if([[NSFileManager defaultManager] fileExistsAtPath:url]){
                    self->_articleImage.image = [UIImage imageNamed:@"UIBarButtonSystemItemCamera"];
                }else{
                    self->_articleImage.image = [UIImage imageWithData: imageData];
                }
            });
        });
        
        }
    @catch(NSException *exception){
        self->_articleImage.image = [UIImage imageNamed:@"UIBarButtonSystemItemCamera"];
    }
}



@end
