//
//  WildcardGestureRecognizer.h
//  Challenger
//
//  Created by ChenZihan on 16/3/31.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^TouchesEventBlock)(NSSet * touches, UIEvent * event);
@interface WildcardGestureRecognizer : UIGestureRecognizer{
    TouchesEventBlock touchesBeganCallback;
}
@property(copy) TouchesEventBlock touchesBeganCallback;
@property(copy) TouchesEventBlock touchesEndCallback;
@end
