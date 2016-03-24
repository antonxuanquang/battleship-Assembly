################################
#
# Makefile: Project 3: Battleship
#
####################################

################
#
# Macros
#
##############
DEBUG= -g
CC= gcc
CFLAGS = $(DEBUG)

AS = as #note: this is already defined: see 'make -p'
ASFLAGS = $(DEBUG)

LFLAGS= $(DEBUG)

RM = /bin/rm
RMFLAGS= -f
OBJS =	main.o \
	begin.o \
	create_board.o \
	create_ship.o \
	show_board.o \
	get_coordinate.o \
	generate_possible_positions.o \
	get_end_coordinate.o \
	put_ship_on_board.o \
	upper_case.o \
	lower_case.o \
	shoot_a_board.o \
	clear_screen.o

EXE= battleship
BACKUPS = *~


###############################
#
# Rules
#
############################
#Main Executable
$(EXE): $(OBJS)
	$(CC) $(LFLAGS) -o $@ $(OBJS)
	$(RM) $(RMFLAGS) *.o

# Assemble any .s files ino the object file
.s.o: 
	$(AS) $(ASFLAGS) -o $@ $<

#Create zip file for dropbox submission
zipfile: 
	mkdir $$USER
	cp *.s Makefile README $$USER
	zip -r $$USER $$USER

#Clean project
clean: 
	$(RM) $(RMFLAGS) $(OBJS) $(EXE)

#Clean and remove backups
distclean:
	$(RM) $(RMFLAGS) $(OBJS) $(EXE) $(BACKUPS)
 
