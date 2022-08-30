cmake_minimum_required(VERSION 3.22)

set(CMAKE_BUILD_TYPE Debug)

project("mylib")

ADD_LIBRARY(${PROJECT_NAME}
    STATIC 
    ${CMAKE_CURRENT_LIST_DIR}/src/mylib.c
)

include_directories(
    ${CMAKE_CURRENT_LIST_DIR}/include
    ${CMAKE_CURRENT_LIST_DIR}
)


