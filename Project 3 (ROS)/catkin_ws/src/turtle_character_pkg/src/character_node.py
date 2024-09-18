#!/usr/bin/env python3

import rospy
from my_turtle import Turtle

# Coordinates to form the number '2'
coordinates_2 = [
    # Top curve line
    (4.5, 8,0),      
    (5, 8.3, 0),  
    (5.5, 8.5, 0),
    (6, 8.5, 0),
    (6.5, 8.5, 0),
    (7.0, 8.3, 0),
    (7.5, 8.0, 0),

    # Cross line
    (7.5, 7.5, 0),   
    (7.1, 7, 0),                               
    (6.7, 6.5, 0), 
    (6.3, 6, 0), 
    (5.9, 5.5, 0), 
    (5.5, 5, 0), 
    (5.1, 4.5, 0), 
    (4.7, 4, 0), 

    # Bottom line
    (4.5, 3.5, 0.0),                
    (5.0, 3.5, 0.0),
    (5.5, 3.5, 0.0),
    (6.0, 3.5, 0.0),
    (6.5, 3.5, 0.0),
    (7.0, 3.5, 0.0),
    (7.5, 3.5, 0.0),
]

# Coordinates to form the 'lamda'
coordinates_lamda = [

    # line '\' of lamda
    (5.2, 9, 0),
    (5.5, 9, 0),
    (5.8, 9, 0),
    (6, 8.5, 0),
    (6.2, 8, 0),

    # line '/\' of lamda
    (6.4, 7.5, 0),
    (6.2, 7.5, 0),

    (6.6, 7, 0),
    (6, 7, 0),

    (6.8, 6.5, 0),
    (5.8, 6.5, 0),

    (7, 6, 0),
    (5.6, 6, 0),

    (7.2, 5.5, 0),
    (5.4, 5.5, 0),

    (7.4, 5, 0),
    (5.2, 5, 0),

    (7.6, 4.5, 0),
    (5, 4.5, 0),

    (7.8, 4, 0),
    (4.8, 4, 0),

    (8, 3.5, 0),    
    (8.3, 3.5, 0),
    (8.6, 3.5, 0),
    (4.6, 3.5, 0),
    
]


def draw_character(character):

    try:
        turtles = []

        if   (character == 1):
            coordinates = coordinates_lamda
        elif (character == 2):
            coordinates = coordinates_2

        for i, (x, y, theta) in enumerate(coordinates):
            turtle_name = f'turtle{i+1}'
            turtle = Turtle(turtle_name)
            turtle.spawn(x, y, theta)

            turtles.append(turtle.name)

        rospy.set_param('turtles', turtles)
        rospy.loginfo("Drawing the character has finished!")
    
    except:
        rospy.logerr("Failed to draw character!")



if __name__ == '__main__':
    try:
        rospy.init_node('character_node', anonymous=True)

        # character:  1 ---> lamda   
        # character:  2 ---> 2  
        character = rospy.get_param('~character', 1)  # Default : (lamda) 
        
        turtle1 = Turtle('turtle1')
        turtle1.delete()
        draw_character(character)

        rospy.loginfo("'character_node' has completed successfully!")

    except:
        rospy.logerr("'character_node' has a problem!")
