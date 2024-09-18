#!/usr/bin/env python3

import rospy
from geometry_msgs.msg import Twist
from turtlesim.srv import SetPen , Spawn , Kill

class Turtle:
    
    def __init__(self, name):
        self.name = name
        self.velocity_publisher = rospy.Publisher(f'/{name}/cmd_vel', Twist, queue_size=10)
    
    def set_path_color(self, r, g, b, width=3):
        service = f'/{self.name}/set_pen'
        rospy.wait_for_service(service)
        try:
            set_pen = rospy.ServiceProxy(service, SetPen)
            set_pen(r, g, b, width, 0)

        except rospy.ServiceException:
            rospy.logerr("'SetPen' Service Failed!")
    
    def relocate(self, linear_vel, angular_vel):
        try:
            vel_msg = Twist()
            vel_msg.linear.x = linear_vel
            vel_msg.angular.z = angular_vel
            for _ in range(10):
                self.velocity_publisher.publish(vel_msg)
                rospy.sleep(0.01)

        except:
            rospy.logerr("Failed to relocate turtle!")

    def delete(self):
        rospy.wait_for_service('/kill')
        try:
            kill_turtle = rospy.ServiceProxy('/kill', Kill)
            kill_turtle(self.name)
            rospy.loginfo("Turtle '%s' has been deleted!", self)

        except rospy.ServiceException:
            rospy.logerr("'Kill' Service Failed!")

    def spawn(self, x, y, theta):
        rospy.wait_for_service('/spawn')
        try:
            spawn_turtle_service = rospy.ServiceProxy('/spawn', Spawn)
            spawn_turtle_service(x, y, theta, self.name)
            rospy.loginfo("'%s' has been spawned!", self.name)

        except rospy.ServiceException:
            rospy.logerr("'Spawn' Service Failed!")


class Controller:
    
    def __init__(self, param, rate):
        self.param = param
        self.turtle_names = self.read_turtles()
        self.turtles = [Turtle(name) for name in self.turtle_names]
        self.rate = rate

    def read_turtles(self):
        while not rospy.is_shutdown():
            rate = rospy.Rate(50)  # 50hz
            try:
                turtle_names = rospy.get_param(self.param)
                if not turtle_names :
                    rospy.logwarn("No turtles specified to move.")
                    rate.sleep()
                    continue
                else:
                    rospy.loginfo("Turtles specified to move!")                
                    break

            except KeyError:
                rospy.logwarn("Parameter 'turtles' not found. Retrying...")
                rate.sleep()
                continue
        return turtle_names 


    def set_all_turtles_path_color(self, r, g, b):
        try:
            for turtle in self.turtles:
                turtle.set_path_color(r, g, b)
                
        except:
            rospy.logerr("Failed to set all the path colors of turtles!")
        
    def move_all_turtles(self, linear_vel):
        try:            
            for turtle in self.turtles:
                turtle.relocate(linear_vel, 0)
                rospy.sleep(self.rate)

            rospy.loginfo("All turtles have been moved!")            
        except:
            rospy.logerr("Failed to move all turtles!")

    def rotate_all_turtles(self, angular_vel):
        try:
            for turtle in self.turtles:
                turtle.relocate(0, angular_vel)    #radians 
                rospy.sleep(self.rate)

            rospy.loginfo("All turtles have been rotated!")
        except:
            rospy.logerr("Failed to rotate all turtles!")

    def relocate_all_turtles(self,linear_vel,angular_vel):        
        try:
            for turtle in self.turtles:
                turtle.relocate(linear_vel, angular_vel)    #radians 
                rospy.sleep(self.rate)

            rospy.loginfo("All turtles have been relocated!")            
        except:
            rospy.logerr("Failed to relocate all turtles!")


 
