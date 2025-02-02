#
# 'make'        build executable file 'main'
# 'make clean'  removes all .o and executable files
#

mode := DEBUG

# define the Cpp compiler to use
CXX = g++

# define any compile-time flags
ifeq ($(mode), RELEASE)
CXXFLAGS    := -std=c++17 -Wno-unused -Wno-narrowing
LFLAGS      := -lsfml-graphics -lsfml-window -lsfml-system -mwindows
OUTPUT	    := output\build
else ifeq ($(mode), DEBUG)
CXXFLAGS	:= -std=c++17 -Wall -Wextra -g 
LFLAGS 		:= -lsfml-graphics -lsfml-window -lsfml-system
OUTPUT	    := output\debug
endif

# define source directory
SRC		:= src src/ZHOR_ENGINE src/scenes

# define include directory
INCLUDE	:= include

# define lib directory
LIB		:= lib lib/SFML output

ifeq ($(OS),Windows_NT)
MAIN	:= main.exe
SOURCEDIRS	:= $(SRC)
INCLUDEDIRS	:= $(INCLUDE)
LIBDIRS		:= $(LIB)
FIXPATH = $(subst /,\,$1)
RM			:= del /q /f
MD	:= mkdir
else
MAIN	:= main
SOURCEDIRS	:= $(shell find $(SRC) -type d)
INCLUDEDIRS	:= $(shell find $(INCLUDE) -type d)
LIBDIRS		:= $(shell find $(LIB) -type d)
FIXPATH = $1
RM = rm -f
MD	:= mkdir -p
endif

# define any directories containing header files other than /usr/include
INCLUDES	:= $(patsubst %,-I%, $(INCLUDEDIRS:%/=%))

# define the C libs
LIBS		:= $(patsubst %,-L%, $(LIBDIRS:%/=%))

# define the C source files
SOURCES		:= $(wildcard $(patsubst %,%/*.cpp, $(SOURCEDIRS)))

# define the C object files 
OBJECTS		:= $(SOURCES:.cpp=.o)

#
# The following part of the makefile is generic; it can be used to 
# build any executable just by changing the definitions above and by
# deleting dependencies appended to the file from 'make depend'
#

OUTPUTMAIN	:= $(call FIXPATH,$(OUTPUT)/$(MAIN))

all: $(OUTPUT) $(MAIN)
	@echo Executing 'all' complete!

$(OUTPUT):
	$(MD) $(OUTPUT)

$(MAIN): $(OBJECTS) 
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(OUTPUTMAIN) $(OBJECTS) $(LFLAGS) $(LIBS)

# this is a suffix replacement rule for building .o's from .c's
# it uses automatic variables $<: the name of the prerequisite of
# the rule(a .c file) and $@: the name of the target of the rule (a .o file) 
# (see the gnu make manual section about automatic variables)
.cpp.o:
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $<  -o $@

.PHONY: clean

clean:
	$(RM) $(call FIXPATH,$(OBJECTS))
	@cls

run: all clean
	.\$(OUTPUTMAIN)
	@echo Executing 'run: all' complete!
