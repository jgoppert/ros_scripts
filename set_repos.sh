#!/bin/bash
rosinstall_generator desktop_full --rosdistro indigo --deps --wet-only --tar | wstool merge - -t src 
