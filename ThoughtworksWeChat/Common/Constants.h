//
//  Constants.h
//  ThoughtworksWeChat
//
//  Created by YangFani on 2020/10/16.
//

#ifndef Constants_h
#define Constants_h


#define color_with_rgb(r,g,b)               [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define color_with_rgba(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBCOLOR_HEX(h)                     color_with_rgb((((h)>>16)&0xFF), (((h)>>8)&0xFF), ((h)&0xFF))
#define SCREEN_WIDTH                        [[UIScreen mainScreen] bounds].size.width

#define COMMENT_USERNAME_TEXT_COLOR         RGBCOLOR_HEX(0x8590AE)
#define COMMENT_CONTENT_TEXT_COLOR          RGBCOLOR_HEX(0x000000)
#define COMMENT_BACKGROUND_COLOR            RGBCOLOR_HEX(0xF0F0F2)
#define COMMENT_SEPARATOR_LINE_COLOR        RGBCOLOR_HEX(0xF4F4F2)

#endif /* Constants_h */
