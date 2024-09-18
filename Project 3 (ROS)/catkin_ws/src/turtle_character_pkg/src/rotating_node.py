#!/usr/bin/env python3

import rospy
from my_turtle import Controller

# The path color of turtles
RGB = {'red' : 200, 'green' : 200, 'blue' : 200}

def rotate_turtles(angular_vel):

    controller = Controller('turtles',0.001)     #rate 1000 Hz

    while not rospy.is_shutdown():
        try:
            controller.set_all_turtles_path_color(RGB['red'], RGB['green'], RGB['blue'])
            controller.rotate_all_turtles(angular_vel)    

        except:
            rospy.logerr("Failed to move character!")


if __name__ == '__main__':
    try:
        rospy.init_node('rotating_node', anonymous=True)
        angular_vel = rospy.get_param('~angular_vel', 0)    # Default : angular velocity = 0
        rotate_turtles(angular_vel)
        
        rospy.loginfo("'rotating_node' has completed successfully!")

    except:
        rospy.logerr("'rotating_node' has a problem!")
