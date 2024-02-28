FROM osrf/ros:foxy-desktop

SHELL ["/bin/bash", "-c"] 

RUN apt-get update --fix-missing -y && apt-get install -y --allow-unauthenticated \
    clang-6.0 \
    clang-format-6.0 \
    clang-tidy-6.0 \
    python3-pip \
    libpoco-dev \
    libeigen3-dev \
    ros-foxy-control-msgs \
    ros-foxy-xacro \
    ros-foxy-ament-cmake-clang-format \
    ros-foxy-ament-clang-format \
    ros-foxy-ament-flake8 \
    ros-foxy-ament-cmake-clang-tidy \
    ros-foxy-angles \
    ros-foxy-ros2-control \
    ros-foxy-realtime-tools \
    ros-foxy-control-toolbox \
    ros-foxy-control-msgs \
    ros-foxy-moveit \
    ros-foxy-ros2-controllers \
    ros-foxy-joint-state-publisher \
    ros-foxy-joint-state-publisher-gui \
    python3-colcon-common-extensions \
    libpoco-dev \
    libeigen3-dev \
    build-essential \
    cmake \
    git \
    nano \
    python3-pip


RUN pip3 install --upgrade pip

WORKDIR /home
RUN git clone --recursive https://github.com/frankaemika/libfranka --branch 0.10.0

WORKDIR /home/libfranka
RUN mkdir /home/libfranka/build
WORKDIR /home/libfranka/build

RUN cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF ..
RUN cmake --build .
RUN cpack -G DEB
RUN dpkg -i libfranka-*.deb

RUN mkdir -p /home/franka_ros2_ws/src
WORKDIR /home/franka_ros2_ws
RUN git clone https://github.com/frankaemika/franka_ros2.git src/franka_ros2
RUN source /opt/ros/foxy/setup.bash && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --symlink-install
RUN echo "source /home/franka_ros2_ws/install/setup.bash" >> ~/.bashrc

