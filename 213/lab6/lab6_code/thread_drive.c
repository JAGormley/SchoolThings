#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <pthread.h>
#include "thread_work.h"

#define NUM_THREADS  7 

extern int comp[];
extern int compHead;
extern int compTail;

void enqueue(int data)
{
    comp[compHead] = data;
    compHead = (compHead + 1) % ARRAY_SIZE;
}

int main (int argc, char** argv)
{
    int i;
    pthread_t threads[NUM_THREADS];
    thread_args targs[NUM_THREADS];
    void *status;

    initialise();

    for ( i = 0; i < 29; i++ )
        enqueue(i);

    for ( i = 0; i < NUM_THREADS; i++)
    {
        targs[i].id = i;
        targs[i].tot_threads = NUM_THREADS;
        pthread_create(&threads[i], NULL,
                thread_work, (void *) &targs[i]);
    }

    for ( i = 0; i < NUM_THREADS; i++)
        pthread_join(threads[i], &status);

    finalise();
}