#!/usr/bin/env python3

import rospy
from my_turtle import Controller
import sys, select, termios, tty

# The path color of turtles
RGB = {'red' : 200, 'green' : 200, 'blue' : 200}

# Map arrow keys to linear and angular velocities
arrow_keys = {
    'w': (1, 0),    # Move forward
    's': (-1, 0),   # Move backward
    'a': (0, 1),    # Rotate CCW
    'd': (0, -1),   # Rotate CW
    }

# Function to get key press from terminal
def get_key():
    try:
        tty.setraw(sys.stdin.fileno())
        select.select([sys.stdin], [], [], 0)
        key = sys.stdin.read(1)
        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, settings)
        return key
    
    except:
        rospy.logerr("Failed to get keys!")

def move_character():

    controller = Controller('turtles',0)      #no rate

    while not rospy.is_shutdown():
        
        try:
            controller.set_all_turtles_path_color(RGB['red'], RGB['green'], RGB['blue'])

            print("Use keys to move the turtle!")
            print("'w' --> Move forward")
            print("'s' --> Move backward")
            print("'a' --> Rotate CCW")
            print("'d' --> Rotate CW")
            print("'q' --> Quit")

            key = get_key()

            if key in arrow_keys.keys():

                linear_vel = arrow_keys[key][0]
                angular_vel = arrow_keys[key][1]

                controller.relocate_all_turtles(linear_vel,angular_vel)

            elif key == 'q':  # Quit
                break

        except:
            rospy.logerr("Failed to move character!")


if __name__ == '__main__':

    settings = termios.tcgetattr(sys.stdin)
    try:
        rospy.init_node('relocating_keys_node', anonymous=True)
        move_character()

        rospy.loginfo("'relocating_keys_node' has completed successfully!")

    except:
        rospy.logerr("'relocating_keys_node' has a problem!")

    finally:
        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, settings)
