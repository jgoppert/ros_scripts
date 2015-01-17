#!/bin/bash

# add ros packages repo
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list'
sudo wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -

# install bootstrap deps
sudo apt-get install python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential python-rosinstall python-catkin-tools cmake

# override ros to use gazebo4
if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]
then
	sudo rosdep init
fi
sudo sh -c 'echo """
gazebo_ros:
    ubuntu: [libgazebo4-dev]
gazebo:
    ubuntu: [gazebo4]
""" > /etc/ros/rosdep/local.yaml'
sudo sh -c 'echo "yaml file:///etc/ros/rosdep/local.yaml" > /etc/ros/rosdep/sources.list.d/10-sources.list'

rosdep update

catkin config --init --install --isolate-install --isolate-devel --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo

mkdir -p src
cd src

if [ ! -f .rosinstall ]
then
	wstool init
fi

# fix python install bug
mkdir -p install/python_qt_binding/lib/python2.7/dist-packages/
