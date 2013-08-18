CC = gcc
CFLAGS = -g

all : thread_drive 

thread_work.o: thread_work.c
	$(CC) $(CFLAGS) -c thread_work.c -o thread_work.o -lpthread

thread_drive: thread_drive.c thread_work.o
	$(CC) $(CFLAGS) thread_drive.c -o thread_drive thread_work.o -lpthread

clean:
	rm thread_work.o thread_drive
