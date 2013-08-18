#include <stdlib.h>
#include <stdio.h>

#define ARRAY_SIZE       50

typedef struct
{
    int id;
    int tot_threads;
} thread_args;

typedef int spinlock_t;

void initialise(void);
void finalise(void);

void spinlock_create(spinlock_t* lock);
void spinlock_lock(spinlock_t* lock);
void spinlock_unlock(spinlock_t* lock);

void* thread_work(void *);
